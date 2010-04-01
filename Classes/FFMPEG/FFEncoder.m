//
//  FFEncoder.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEncoder.h"
#import "FFUtils.h"
#import "FFDefines.h"

@interface FFEncoder ()
- (BOOL)_prepareVideo:(NSError **)error;
- (AVStream *)_addVideoStream:(NSError **)error;
@end

@implementation FFEncoder

@synthesize currentVideoFrameIndex=_currentVideoFrameIndex;

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat videoBitRate:(int)videoBitRate {
  if ((self = [super init])) {
    _width = width; 
    _height = height;
    _pixelFormat = pixelFormat;
    _videoBitRate = videoBitRate;
  }
  return self;
}

- (void)dealloc {
  [self close];
  [super dealloc];
}

- (AVCodecContext *)videoCodecContext {
  if (_videoStream == NULL) return NULL;
  return _videoStream->codec;
}

- (BOOL)open:(NSString *)path format:(NSString *)format error:(NSError **)error {  
  if (_formatContext) {
    FFSetError(error, FFErrorCodeOpenAlready, @"Encoder is already open");
    return NO;
  }
  
  FFInitialize();
  
  const char *filename = [path UTF8String];  
  AVOutputFormat *outputFormat = av_guess_format([format UTF8String], filename, NULL);
  if (!outputFormat) {
    FFSetError(error, FFErrorCodeUnknownOutputFormat, @"Couldn't deduce output format");
    return NO;
  }
  
  /* allocate the output media context */
  _formatContext = avformat_alloc_context();
  if (!_formatContext) {
    FFSetError(error, FFErrorCodeAllocFormatContext, @"Couldn't allocate format context");
    return NO;
  }
  _formatContext->oformat = outputFormat;
  snprintf(_formatContext->filename, sizeof(_formatContext->filename), "%s", filename);
  
  
  if (outputFormat->video_codec != CODEC_ID_NONE) {
    _videoStream = [self _addVideoStream:error];
    if (!_videoStream) {
      [self close];
      return NO;
    }
    
    // Some formats want stream headers to be separate
    if (outputFormat->flags & AVFMT_GLOBALHEADER)
      _videoStream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
  }

  /*!
  if (outputFormat->audio_codec != CODEC_ID_NONE) {
    _audioStream = add_audio_stream(_formatContext, outputFormat->audio_codec);
  }
   */
  
  // Set the output parameters (must be done even if no parameters)
  if (av_set_parameters(_formatContext, NULL) < 0) {
    FFSetError(error, FFErrorCodeInvalidFormatParameters, @"Invalid output format parameters");
    [self close];
    return NO;
  }

  dump_format(_formatContext, 0, filename, 1);
    
  if (![self _prepareVideo:error]) {
    [self close];
    return NO;
  }
  //if (![self _prepareAudio:error]) return NO;

  // Setup any format context settings
  _formatContext->max_delay = (int)(0.7 * AV_TIME_BASE);  

  if (!(outputFormat->flags & AVFMT_NOFILE)) {
    if (url_fopen(&_formatContext->pb, filename, URL_WRONLY) < 0) {
      FFSetError(error, FFErrorCodeOpen, @"Couldn't open file");
      [self close];
      return NO;
    }
  }
  return YES;
}

/* add a video output stream */
- (AVStream *)_addVideoStream:(NSError **)error {
  
  AVStream *stream = av_new_stream(_formatContext, 0);
  
  if (!stream) {
    FFSetError(error, FFErrorCodeAllocStream, @"Couldn't allocate stream");
    return NULL;
  }
  
  AVCodecContext *codecContext = stream->codec;
  codecContext->codec_id = _formatContext->oformat->video_codec;
  codecContext->codec_type = CODEC_TYPE_VIDEO;
  
  codecContext->bit_rate = _videoBitRate;
  // Resolution must be a multiple of two
  codecContext->width = _width;
  codecContext->height = _height;
  
  /*
   time_base: this is the fundamental unit of time (in seconds) in terms
   of which frame timestamps are represented. for fixed-fps content,
   timebase should be 1/framerate and timestamp increments should be
   identically 1. 
   */
  codecContext->time_base.den = 25; // Frames per second
  codecContext->time_base.num = 1;
  codecContext->gop_size = 12; /* emit one intra frame every twelve frames at most */
  codecContext->pix_fmt = _pixelFormat;
  
  if (codecContext->codec_id == CODEC_ID_MPEG2VIDEO) {
    // For testing, we also add B frames
    codecContext->max_b_frames = 2;
  }
  
  if (codecContext->codec_id == CODEC_ID_MPEG1VIDEO){
    /* Needed to avoid using macroblocks in which some coeffs overflow.
     This does not happen with normal video, it just happens here as
     the motion of the chroma plane does not match the luma plane. */
    codecContext->mb_decision = 2;
  }
    
  return stream;
}

- (BOOL)_prepareVideo:(NSError **)error {
  AVCodecContext *codecContext = _videoStream->codec;

  AVCodec *codec = avcodec_find_encoder(codecContext->codec_id);
  if (!codec) {
    FFSetError(error, FFErrorCodeVideoCodecNotFound, @"Codec not found");
    return NO;
  }

  if (avcodec_open(codecContext, codec) < 0) {
    FFSetError(error, FFErrorCodeVideoCodecOpen, @"Couldn't open codec");
    return NO;
  }
  
  _videoBufferSize = 200000;
  _videoBuffer = av_malloc(_videoBufferSize);
  _currentVideoFrameIndex = 0;    

  NSAssert(_pixelFormat == codecContext->pix_fmt, @"Mismatched pixel format");  
  NSAssert(_width == codecContext->width, @"Mismatched width");
  NSAssert(_height == codecContext->height, @"Mismatched height");

  return YES;
}

- (BOOL)writeHeader:(NSError **)error {  
  if (av_write_header(_formatContext) != 0) {
    FFSetError(error, FFErrorCodeWriteHeader, @"Couldn't write header");
    return NO;
  }
  FFDebug(@"Wrote header");
  return YES;
}

- (BOOL)writeTrailer:(NSError **)error {
  if (av_write_trailer(_formatContext) != 0) {
    FFSetError(error, FFErrorCodeWriteTrailer, @"Couldn't write trailer");
    return NO;
  }
  FFDebug(@"Wrote trailer");
  return YES;
}  

- (void)close {
  // Close video
  if (_videoStream != NULL) {
    if (_videoStream->codec != NULL) avcodec_close(_videoStream->codec);
    _videoStream = NULL;
  }

  if (_videoBuffer != NULL) {
    av_free(_videoBuffer);
    _videoBuffer = NULL;
  }
  
  if (_formatContext != NULL) {
    // Free the streams
    for (int i = 0; i < _formatContext->nb_streams; i++) {
      av_freep(&_formatContext->streams[i]->codec);
      av_freep(&_formatContext->streams[i]);
    }
    
    if (!(_formatContext->oformat->flags & AVFMT_NOFILE)) {
      url_fclose(_formatContext->pb);
    }
  
    av_free(_formatContext);
    _formatContext = NULL;
  }
}

- (int)encodeVideoFrame:(AVFrame *)picture error:(NSError **)error {    
  AVCodecContext *codecContext = _videoStream->codec;

  int bytesEncoded = avcodec_encode_video(codecContext, _videoBuffer, _videoBufferSize, picture);
  if (bytesEncoded < 0) {
    FFSetError(error, FFErrorCodeEncodeFrame, @"Error encoding frame");
    return bytesEncoded; // Error number
  }
  return bytesEncoded;
}

- (BOOL)writeVideoBuffer:(NSError **)error {   
  AVCodecContext *codecContext = _videoStream->codec;
  
  AVPacket packet;        
  av_init_packet(&packet);
  
  if (codecContext->coded_frame->pts != AV_NOPTS_VALUE)
    packet.pts = av_rescale_q(codecContext->coded_frame->pts, codecContext->time_base, _videoStream->time_base);
  
  if (codecContext->coded_frame->key_frame)
    packet.flags |= PKT_FLAG_KEY;
  
  packet.stream_index = _videoStream->index;
  packet.data = _videoBuffer;
  packet.size = _videoBufferSize;
  
  if (av_interleaved_write_frame(_formatContext, &packet) != 0) {
    FFSetError(error, FFErrorCodeWriteFrame, @"Error writing interleaved frame");
    return NO;
  }
  
  _currentVideoFrameIndex++;
  return YES;
}

- (BOOL)writeVideoFrame:(AVFrame *)picture error:(NSError **)error {   
  int bytesEncoded = [self encodeVideoFrame:picture error:error];
  if (bytesEncoded < 0) return NO;
  
  // If bytesEncoded is zero, there was buffering
  if (bytesEncoded > 0) {
    if (![self writeVideoBuffer:error]) {
      return NO;
    }      
  }  
  return YES;
}


@end
