//
//  FFDecoder.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoder.h"
#import "FFDefines.h"
#import "FFUtils.h"

@implementation FFDecoder

@synthesize open=_open;

- (void)dealloc {
  [self close];
  [super dealloc];
}

- (BOOL)openWithURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error {
  NSParameterAssert(URL);
  
  FFInitialize();
  
  NSString *path = [FFUtils resolvedPathForURL:URL];
  FFDebug(@"Path: %@", path);
  if (!path) {
    FFSetError(error, FFErrorCodeOpen, @"Failed to open, invalid path");
    return NO;
  }
  
  AVInputFormat *avformat = NULL;
  if (format) {
    avformat = av_find_input_format([format UTF8String]);
    if (avformat == NULL) FFSetError(error, FFErrorCodeInputFormatNotFound, @"Couldn't find specified format");
    else FFDebug(@"Format: %s (flags=%x)", avformat->long_name, avformat->flags);
  }

  int averror = av_open_input_file(&_formatContext, [path UTF8String], avformat, 0, NULL);
  if (averror != 0) {
    FFSetError(error, FFErrorCodeOpen, @"Failed to open: %d", averror);
    return NO;
  }
  
  /*!
  _formatContext->flags = AVFMT_FLAG_NONBLOCK;
  _formatContext->max_analyze_duration = 1 * AV_TIME_BASE;
  _formatContext->max_delay = 0;
  _formatContext->preload = 0;
   */
  
  FFDebug(@"Format context flags: %x", _formatContext->flags);
  FFDebug(@"Format max analyze flag: %d", _formatContext->max_analyze_duration);
  
  FFDebug(@"Find stream info");
  averror = av_find_stream_info(_formatContext);
  if (averror < 0) {
    av_close_input_file(_formatContext);
    FFSetError(error, FFErrorCodeStreamInfoNotFound, @"Failed to find stream info");
    return NO;
  }
    
  // Find video stream
  _videoStream = NULL;
  for (int i = 0; i < _formatContext->nb_streams; i++) {
    AVStream *stream = _formatContext->streams[i];
    FFDebug(@"Stream codec type: %d", stream->codec->codec_type);
    if (stream->codec->codec_type == CODEC_TYPE_VIDEO) {
      _videoStream = stream;      
    }
  }
  if (_videoStream == NULL) {
    FFSetError(error, FFErrorCodeVideoStreamNotFound, @"Couldn't find video stream");
    return NO;
  }
  
  FFDebug(@"Finding codec (decoder)");
  AVCodec *codec = avcodec_find_decoder(_videoStream->codec->codec_id);
  if (!codec) {
    FFSetError(error, FFErrorCodeCodecNotFound, @"Codec not found for video stream");
    return NO;
  }
  FFDebug(@"Codec (decoder) found: %s", codec->name);
  
  if (avcodec_open(_videoStream->codec, codec) < 0) {
    FFSetError(error, FFErrorCodeCodecOpen, @"Codec (decoder) open failed for video stream");
    return NO;
  }
  FFDebug(@"Codec opened");

  _open = YES;
  FFDebug(@"Opened");
  return YES;
}

- (int)width {
  if (_videoStream == NULL) return -1;
  return _videoStream->codec->coded_width;
}

- (int)height {
  if (_videoStream == NULL) return -1;
  return _videoStream->codec->coded_height;
}

- (enum PixelFormat)pixelFormat {
  if (_videoStream == NULL) return PIX_FMT_NONE;
  return _videoStream->codec->pix_fmt;
}

- (int)videoBitRate {
  if (_videoStream == NULL) return -1;
  return _videoStream->codec->bit_rate;
}

- (BOOL)readFrame:(AVPacket *)packet error:(NSError **)error {
  
  // Read the packet
  if (av_read_frame(_formatContext, packet) < 0) { 
    FFSetError(error, FFErrorCodeReadFrame, @"Failed to read frame");
    return NO;
  }
  
  //FFDebug(@"Packet size: %d", packet->size);
  
  // Ignore packet if not part of our video stream
  if (packet->stream_index != _videoStream->index) {
    //FFDebug(@"Packet not part of video stream");
    return NO;
  }
  
  // If flush packet, flush and continue
  if (FFIsFlushPacket(packet)) {
    FFDebug(@"avcodec_flush_buffers");
    avcodec_flush_buffers(_videoStream->codec);
    return NO;
  }
  
  return YES;
}

- (BOOL)decodeFrame:(AVFrame *)frame error:(NSError **)error {
  AVPacket packet;
  
  if (![self readFrame:&packet error:error]) 
    return NO;
  
  BOOL decoded = [self decodeFrame:frame packet:&packet error:error];

  av_free_packet(&packet);
  
  return decoded;
}

- (BOOL)decodeFrame:(AVFrame *)frame packet:(AVPacket *)packet error:(NSError **)error {  
  int gotFrame = 0;
  int bytesDecoded = avcodec_decode_video2(_videoStream->codec, frame, &gotFrame, packet);
  
  if (bytesDecoded < 0) return NO;
  if (!gotFrame) return NO;

  return YES;
}

- (void)close {
  if (_formatContext != NULL) av_close_input_file(_formatContext);
  _formatContext = NULL;
  _open = NO;
}

@end
