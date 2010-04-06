//
//  FFEncoder.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEncoder.h"
#import "FFUtils.h"


@interface FFEncoder ()
- (BOOL)_prepareVideo:(NSError **)error;
- (AVStream *)_addVideoStream:(NSError **)error;
@end

@implementation FFEncoder

- (id)initWithOptions:(FFOptions *)options presets:(FFPresets *)presets path:(NSString *)path format:(NSString *)format codecName:(NSString *)codecName {
  if ((self = [super init])) {
    _options = [options retain]; 
    _presets = [presets retain];
    _path = [path retain];
    _format = [format retain];
    _codecName = [codecName retain];
    _currentPTS = 0;
  }
  return self;
}

- (void)dealloc {
  [self close];
  [_options release];
  [_path release];
  [_format release];
  [_codecName release];
  [super dealloc];
}

- (AVCodecContext *)videoCodecContext {
  if (_videoStream == NULL) return NULL;
  return _videoStream->codec;
}

- (BOOL)open:(NSError **)error {
  if (_formatContext) {
    FFSetError(error, FFErrorCodeOpenAlready, -1, @"Encoder is already open");
    return NO;
  }
  
  FFInitialize();
  
  const char *filename = [_path UTF8String];  
  FFDebug(@"Encoder; path=%@, format=%@", _path, _format);
  AVOutputFormat *outputFormat = av_guess_format([_format UTF8String], NULL, NULL);
  if (!outputFormat) {
    FFSetError(error, FFErrorCodeUnknownOutputFormat, -1, @"Couldn't deduce output format");
    return NO;
  }
  
  // If overriding output format codec
  if (_codecName) {
    AVCodec *codec = avcodec_find_encoder_by_name([_codecName UTF8String]);
    if (codec == NULL) {
      FFSetError(error, FFErrorCodeCodecNotFound, -1, @"Codec not found with name: %@", _codecName);
      return NO;
    }    
    outputFormat->video_codec = codec->id;
  }  
  
  /* allocate the output media context */
  _formatContext = avformat_alloc_context();
  if (!_formatContext) {
    FFSetError(error, FFErrorCodeAllocFormatContext, -1, @"Couldn't allocate format context");
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
    FFSetError(error, FFErrorCodeInvalidFormatParameters, averror, @"Invalid output format parameters");
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
      FFSetError(error, FFErrorCodeOpen, averror, @"Couldn't open file");
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
    FFSetError(error, FFErrorCodeAllocStream, -1, @"Couldn't allocate stream");
    return NULL;
  }
  
  AVCodecContext *codecContext = stream->codec;
  
  avcodec_get_context_defaults2(codecContext, CODEC_TYPE_VIDEO);
  
  codecContext->codec_id = _formatContext->oformat->video_codec;
  codecContext->codec_type = CODEC_TYPE_VIDEO;

  [_presets apply:codecContext];
  [_options apply:codecContext];
  
  return stream;
}

- (BOOL)_prepareVideo:(NSError **)error {
  AVCodecContext *codecContext = _videoStream->codec;
  
  AVCodec *codec = avcodec_find_encoder(codecContext->codec_id);
  if (codec == NULL) {
    FFSetError(error, FFErrorCodeCodecNotFound, -1, @"Codec not found");
    return NO;
  }

  int averror = avcodec_open(codecContext, codec);
  if (averror < 0) {
    FFSetError(error, FFErrorCodeCodecOpen, averror, @"Couldn't open codec");
    return NO;
  }
  
  _videoBufferSize = 200000;
  _videoBuffer = av_malloc(_videoBufferSize);

  return YES;
}

- (BOOL)writeHeader:(NSError **)error {  
  int averror = av_write_header(_formatContext);
  if (averror != 0) {
    FFSetError(error, FFErrorCodeWriteHeader, averror, @"Couldn't write header");
    return NO;
  }
  FFDebug(@"Wrote header");
  return YES;
}

- (BOOL)writeTrailer:(NSError **)error {
  int averror = av_write_trailer(_formatContext);
  if (averror != 0) {
    FFSetError(error, FFErrorCodeWriteTrailer, averror, @"Couldn't write trailer");
    return NO;
  }
  FFDebug(@"Wrote trailer");
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
  
  [_converter release];
  _converter = nil;
}

- (int)encodeVideoFrame:(AVFrame *)picture error:(NSError **)error {    
  AVCodecContext *codecContext = _videoStream->codec;
  
  //FFDebug(@"Encode frame, pts=%lld", picture->pts);
  //AVFrame *picture = [_converter scalePicture:picture error:error];

  int bytesEncoded = avcodec_encode_video(codecContext, _videoBuffer, _videoBufferSize, picture);
  if (bytesEncoded < 0) {
    FFSetError(error, FFErrorCodeEncodeFrame, bytesEncoded, @"Error encoding frame");
    return bytesEncoded; // Error number
  }
  //FFDebug(@"Encoded frame; pts=%lld, coded_frame->pts=%lld", picture->pts, codecContext->coded_frame->pts);    
  _frameBytesEncoded = bytesEncoded;
  return bytesEncoded;
}

- (AVFrame *)codedFrame {
  return _videoStream->codec->coded_frame;
}

- (BOOL)writeVideoBuffer:(NSError **)error duration:(int64_t)duration {   
  if (_frameBytesEncoded == 0) return NO;
  
  AVCodecContext *codecContext = _videoStream->codec;
  
  AVPacket packet;        
  av_init_packet(&packet);
  
  if (codecContext->coded_frame->pts != AV_NOPTS_VALUE)
    packet.pts = av_rescale_q(codecContext->coded_frame->pts, codecContext->time_base, _videoStream->time_base);
  
  codecContext->coded_frame->pts += duration;

  FFDebug(@"Write video buffer: %d, pts=%lld", _frameBytesEncoded, packet.pts);
  
//  if (codecContext->coded_frame->dts != AV_NOPTS_VALUE)
//    packet.dts = av_rescale_q(codecContext->coded_frame->dts, codecContext->time_base, _videoStream->time_base);
  
  if (codecContext->coded_frame->key_frame)
    packet.flags |= PKT_FLAG_KEY;
  
  packet.stream_index = _videoStream->index;
  packet.data = _videoBuffer;
  packet.size = _frameBytesEncoded;
  
  int averror = av_interleaved_write_frame(_formatContext, &packet);
  if (averror != 0) {
    FFSetError(error, FFErrorCodeWriteFrame, averror, @"Error writing interleaved frame");
    return NO;
  }

  return YES;
}

- (BOOL)writeVideoFrame:(AVFrame *)picture error:(NSError **)error {   
  int bytesEncoded = [self encodeVideoFrame:picture error:error];
  if (bytesEncoded < 0) return NO;
  
  // If bytesEncoded is zero, there was buffering
  if (bytesEncoded > 0) {
    if (![self writeVideoBuffer:error duration:20]) { // XXX(gabe): FIXME
      return NO;
    }      
  }  
  return YES;
}


@end
