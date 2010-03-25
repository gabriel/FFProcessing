//
//  FFEncoder.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFEncoder.h"
#import "FFCommon.h"
#import "FFDefines.h"

@interface FFEncoder ()
- (BOOL)_prepareVideo:(NSError **)error;
- (AVStream *)_addVideoStream:(NSError **)error;
- (BOOL)_writeVideoFrame:(NSError **)error;
@end

@implementation FFEncoder

- (BOOL)open:(NSString *)path error:(NSError **)error {
  const char *filename = [path UTF8String];  
  AVOutputFormat *outputFormat = av_guess_format(NULL, filename, NULL);
  if (!outputFormat) {
    FFSetError(error, FFErrorCodeUnknownOutputFormat, @"Couldn't deduce output format from file extension");
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
      return NO;
    }
  }

  /*!
  if (outputFormat->audio_codec != CODEC_ID_NONE) {
    _audioStream = add_audio_stream(_formatContext, outputFormat->audio_codec);
  }
   */
  
  // Set the output parameters (must be done even if no parameters)
  if (av_set_parameters(_formatContext, NULL) < 0) {
    FFSetError(error, FFErrorCodeInvalidFormatParameters, @"Invalid output format parameters");
    return NO;
  }

  dump_format(_formatContext, 0, filename, 1);
    
  if (![self _prepareVideo:error]) return NO;
  //if (![self _prepareAudio:error]) return NO;

  if (!(outputFormat->flags & AVFMT_NOFILE)) {
    if (url_fopen(&_formatContext->pb, filename, URL_WRONLY) < 0) {
      FFSetError(error, FFErrorCodeOpen, @"Couldn't open file");
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
  
  codecContext->bit_rate = 400000;
  // Resolution must be a multiple of two
  codecContext->width = 352;
  codecContext->height = 288;
  
  /*
   time_base: this is the fundamental unit of time (in seconds) in terms
   of which frame timestamps are represented. for fixed-fps content,
   timebase should be 1/framerate and timestamp increments should be
   identically 1. 
   */
  codecContext->time_base.den = 25; // Frames per second
  codecContext->time_base.num = 1;
  codecContext->gop_size = 12; /* emit one intra frame every twelve frames at most */
  codecContext->pix_fmt = PIX_FMT_YUV420P;
  
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
  
  // Some formats want stream headers to be separate
  if(_formatContext->oformat->flags & AVFMT_GLOBALHEADER)
    _formatContext->flags |= CODEC_FLAG_GLOBAL_HEADER;
  
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
  
  _pixelFormat = codecContext->pix_fmt;
  _width = codecContext->width;
  _height = codecContext->height;
  _picture = FFCreatePicture(_pixelFormat, _width, _height);
  
  if (!_picture) {    
    FFSetError(error, FFErrorCodeAllocateFrame, @"Couldn't create picture");
    return NO;
  }  
  
  return YES;
}

- (void)writeFrames:(NSError **)error {

  av_write_header(_formatContext);
  
  while ([self _writeVideoFrame:error]) { }
  
  av_write_trailer(_formatContext);

}  

- (void)close {
  // Close video
  if (_videoStream != NULL) avcodec_close(_videoStream->codec);

  if (_picture != NULL) {
    av_free(_picture->data[0]);
    av_free(_picture);
  }
  if (_videoBuffer != NULL) av_free(_videoBuffer);
  
  // Free the streams
  for (int i = 0; i < _formatContext->nb_streams; i++) {
    av_freep(&_formatContext->streams[i]->codec);
    av_freep(&_formatContext->streams[i]);
  }
  
  if (!(_formatContext->oformat->flags & AVFMT_NOFILE)) {
    url_fclose(_formatContext->pb);
  }

  if (_formatContext != NULL) av_free(_formatContext);
}

- (BOOL)_writeVideoFrame:(NSError **)error {
  
  AVCodecContext *codecContext = _videoStream->codec;
  
  // Stop at 200 frames
  if (_currentVideoFrameIndex > 200) return NO;
  
  // Fill in dummy picture data
  FFFillYUVImage(_picture, _currentVideoFrameIndex, _width, _height);
  
  int bytesEncoded = avcodec_encode_video(codecContext, _videoBuffer, _videoBufferSize, _picture);

  // If bytesEncoded is zero, there was buffering
  if (bytesEncoded > 0) {
  
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
  }
  
  _currentVideoFrameIndex++;
  return YES;
}


@end
