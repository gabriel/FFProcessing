//
//  FFMPEncoder.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#import "FFMPEncoder.h"
#import "FFUtils.h"
#import "FFMPUtils.h"
#import "FFMPPresets.h"


@interface FFMPEncoder ()
- (BOOL)_prepareVideo:(NSError **)error;
- (AVStream *)_addVideoStream:(NSError **)error;
@end

@implementation FFMPEncoder

- (id)initWithOptions:(FFEncoderOptions *)options  {
  if ((self = [super init])) {
    _options = [options retain]; 
    _currentPTS = 0;
  }
  return self;
}

- (void)dealloc {
  [self close];
  [_options release];
  [super dealloc];
}

- (AVCodecContext *)videoCodecContext {
  if (_videoStream == NULL) return NULL;
  return _videoStream->codec;
}

- (BOOL)open:(NSError **)error {
  if (_formatContext) {
    FFMPSetError(error, FFErrorCodeOpenAlready, -1, @"Encoder is already open");
    return NO;
  }
  
  FFMPInitialize();
  
  const char *filename = [_options.path UTF8String];  
  FFDebug(@"Encoder; path=%@, format=%@", _options.path, _options.formatName);
  AVOutputFormat *outputFormat = av_guess_format([_options.formatName UTF8String], NULL, NULL);
  if (!outputFormat) {
    FFMPSetError(error, FFErrorCodeUnknownOutputFormat, -1, @"Couldn't deduce output format");
    return NO;
  }
  
  // If overriding output format codec
  if (_options.codecName) {
    AVCodec *codec = avcodec_find_encoder_by_name([_options.codecName UTF8String]);
    if (codec == NULL) {
      FFMPSetError(error, FFErrorCodeCodecNotFound, -1, @"Codec not found with name: %@", _options.codecName);
      return NO;
    }    
    outputFormat->video_codec = codec->id;
  }  
  
  /* allocate the output media context */
  _formatContext = avformat_alloc_context();
  if (!_formatContext) {
    FFMPSetError(error, FFErrorCodeAllocFormatContext, -1, @"Couldn't allocate format context");
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
  int averror = av_set_parameters(_formatContext, NULL);
  if (averror < 0) {
    FFMPSetError(error, FFErrorCodeInvalidFormatParameters, averror, @"Invalid output format parameters");
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
  //_formatContext->max_delay = (int)(0.7 * AV_TIME_BASE);  
  
  if (!(outputFormat->flags & AVFMT_NOFILE)) {
    int averror = url_fopen(&_formatContext->pb, filename, URL_WRONLY);
    if (averror < 0) {
      FFMPSetError(error, FFErrorCodeOpen, averror, @"Couldn't open file");
      [self close];
      return NO;
    }
  }
  
  _avFrame = avcodec_alloc_frame();
  if (_avFrame == NULL) {
    FFMPSetError(error, FFErrorCodeAllocateFrame, -1, @"Couldn't allocate frame");
    return NO;
  }

  return YES;
}

/* add a video output stream */
- (AVStream *)_addVideoStream:(NSError **)error {
  
  AVStream *stream = av_new_stream(_formatContext, 0);
  
  if (!stream) {
    FFMPSetError(error, FFErrorCodeAllocStream, -1, @"Couldn't allocate stream");
    return NULL;
  }
  
  AVCodecContext *codecContext = stream->codec;
  
  avcodec_get_context_defaults2(codecContext, CODEC_TYPE_VIDEO);
  
  codecContext->codec_id = _formatContext->oformat->video_codec;
  codecContext->codec_type = CODEC_TYPE_VIDEO;

  FFMPPresets *presets = [[FFMPPresets alloc] initWithCodeName:_options.codecName];
  [presets apply:codecContext];
  [presets release];
  codecContext->width = _options.format.width;
  codecContext->height = _options.format.height;
  codecContext->pix_fmt = PixelFormatFromFFPixelFormat(_options.format.pixelFormat);
  codecContext->time_base = AVRationalFromFFRational(_options.videoTimeBase);
  codecContext->sample_aspect_ratio = AVRationalFromFFRational(_options.sampleAspectRatio);  
  
  stream->sample_aspect_ratio = codecContext->sample_aspect_ratio;
  
  return stream;
}

- (BOOL)_prepareVideo:(NSError **)error {
  AVCodecContext *codecContext = _videoStream->codec;
  
  AVCodec *codec = avcodec_find_encoder(codecContext->codec_id);
  if (codec == NULL) {
    FFMPSetError(error, FFErrorCodeCodecNotFound, -1, @"Codec not found");
    return NO;
  }

  int averror = avcodec_open(codecContext, codec);
  if (averror < 0) {
    FFMPSetError(error, FFErrorCodeCodecOpen, averror, @"Couldn't open codec");
    return NO;
  }
  
  _videoBufferSize = 200000;
  _videoBuffer = av_malloc(_videoBufferSize);

  return YES;
}

- (BOOL)writeHeader:(NSError **)error {  
  int averror = av_write_header(_formatContext);
  if (averror != 0) {
    FFMPSetError(error, FFErrorCodeWriteHeader, averror, @"Couldn't write header");
    return NO;
  }
  FFDebug(@"Wrote header");
  return YES;
}

- (BOOL)writeTrailer:(NSError **)error {
  if (_formatContext) {
    int averror = av_write_trailer(_formatContext);
    if (averror != 0) {
      FFMPSetError(error, FFErrorCodeWriteTrailer, averror, @"Couldn't write trailer");
      return NO;
    }
    FFDebug(@"Wrote trailer");
  } else {
    FFMPSetError(error, FFErrorCodeWriteTrailer, 0, @"Couldn't write trailer: no format context");
    return NO;
  }
  return YES;
}  

- (void)close {
  // Close video
  if (_videoStream != NULL) {
    if (_videoStream->codec != NULL && _videoStream->codec->codec != NULL) avcodec_close(_videoStream->codec);
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
      if (_formatContext->pb != NULL) url_fclose(_formatContext->pb);
    }
  
    av_free(_formatContext);
    _formatContext = NULL;
  }  
  
  if (_avFrame != NULL) {
    av_free(_avFrame);
    _avFrame = NULL;
  }
}

- (BOOL)isOpen {
  return (!!_formatContext);
}

- (int)encodeFrame:(FFVFrameRef)frame error:(NSError **)error {
  AVFrameFillFromFFVFrame(_avFrame, frame);  
  return [self encodeAVFrame:_avFrame error:error];
}  

- (int)encodeAVFrame:(AVFrame *)picture error:(NSError **)error {    
  AVCodecContext *codecContext = _videoStream->codec;
  
  int bytesEncoded = avcodec_encode_video(codecContext, _videoBuffer, _videoBufferSize, picture);
  if (bytesEncoded < 0) {
    FFMPSetError(error, FFErrorCodeEncodeFrame, bytesEncoded, @"Error encoding frame");
    return bytesEncoded; // Error number
  }
  _frameBytesEncoded = bytesEncoded;
  return bytesEncoded;
}

- (void *)codedFrame {
  return _videoStream->codec->coded_frame;
}

- (BOOL)writeVideoBuffer:(NSError **)error {   
  if (_frameBytesEncoded == 0) return NO;
  
  AVCodecContext *codecContext = _videoStream->codec;
  
  AVPacket packet;        
  av_init_packet(&packet);
  
  if (codecContext->coded_frame->pts != AV_NOPTS_VALUE) {
    packet.pts = av_rescale_q(codecContext->coded_frame->pts, codecContext->time_base, _videoStream->time_base);
  }

  FFDebugFrame(@"Write video buffer; pts=%lld (%d bytes)", packet.pts, _frameBytesEncoded);
  
//  if (codecContext->coded_frame->dts != AV_NOPTS_VALUE)
//    packet.dts = av_rescale_q(codecContext->coded_frame->dts, codecContext->time_base, _videoStream->time_base);
  
  if (codecContext->coded_frame->key_frame)
    packet.flags |= PKT_FLAG_KEY;
  
  packet.stream_index = _videoStream->index;
  packet.data = _videoBuffer;
  packet.size = _frameBytesEncoded;
  
  int averror = av_interleaved_write_frame(_formatContext, &packet);
  if (averror != 0) {
    FFMPSetError(error, FFErrorCodeWriteFrame, averror, @"Error writing interleaved frame");
    return NO;
  }

  return YES;
}

- (BOOL)writeVideoFrame:(AVFrame *)picture error:(NSError **)error {
  int bytesEncoded = [self encodeAVFrame:picture error:error];
  if (bytesEncoded < 0) {
    FFMPSetError(error, FFErrorCodeEncodeFrame, bytesEncoded, @"Error encoding frame");
    return NO;
  }
  
  return [self writeVideoBuffer:error];
}

@end
