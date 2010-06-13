//
//  FFMPUtils.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/9/10.
//  Copyright 2010. All rights reserved.
//

#import "FFMPUtils.h"
#import "FFUtils.h"

#include "libavformat/avformat.h"

NSString *const FFMPErrorCodeKey = @"FFMPErrorCodeKey";

static AVPacket gAVFlushPacket;
static BOOL gFFMPInitialized = NO;


enum PixelFormat PixelFormatFromFFPixelFormat(FFPixelFormat pixelFormat) {
  switch (pixelFormat) {
    case kFFPixelFormatType_YUV420P: return PIX_FMT_YUV420P;
    case kFFPixelFormatType_32BGRA: return PIX_FMT_BGRA;
    case kFFPixelFormatType_32RGBA: return PIX_FMT_RGBA;
    case kFFPixelFormatType_32ARGB: return PIX_FMT_ARGB;
    case kFFPixelFormatType_24RGB: return PIX_FMT_RGB24;
    case kFFPixelFormatType_1Monochrome: return PIX_FMT_MONOWHITE;
    default:
      FFDebug(@"Unknown FF pixel format: %d", pixelFormat);
      return PIX_FMT_NONE;
  }
}

FFPixelFormat FFPixelFormatFromPixelFormat(enum PixelFormat pixelFormat) {
  switch (pixelFormat) {
    case PIX_FMT_YUV420P: return kFFPixelFormatType_YUV420P;
    case PIX_FMT_BGRA: return kFFPixelFormatType_32BGRA;
    case PIX_FMT_RGBA: return kFFPixelFormatType_32RGBA;
    case PIX_FMT_ARGB: return kFFPixelFormatType_32ARGB;
    case PIX_FMT_RGB24: return kFFPixelFormatType_24RGB;
    case PIX_FMT_MONOWHITE: return kFFPixelFormatType_1Monochrome;
    //case PIX_FMT_YUV420P: return;
    default:
      FFDebug(@"Unknown FFMP pixel format: %d", pixelFormat);
      return kFFPixelFormatType_None;
  }  
}

FFVFrameRef FFVFrameCreateFromAVFrame(AVFrame *avFrame, FFVFormat format) {
  FFVFrameRef frame = FFVFrameCreateWithData(format, NULL);
  FFVFrameCopyFromAVFrame(frame, avFrame, format);
  return frame;
}

void FFVFrameCopyFromAVFrame(FFVFrameRef frame, AVFrame *avFrame, FFVFormat format) {
  // TODO(gabe): Release existing data?
  av_picture_copy(AVPictureFromFFVFrame(frame), (AVPicture *)avFrame, PixelFormatFromFFPixelFormat(format.pixelFormat), 
                  format.width, format.height);
}

AVPicture *AVPictureFromFFVFrame(FFVFrameRef frame) {
  return (AVPicture *)frame;
}

void AVFrameFillFromFFVFrame(AVFrame *avFrame, FFVFrameRef frame) {
  FFVFormat format = frame->format;
  avpicture_fill((AVPicture *)avFrame, *frame->data, PixelFormatFromFFPixelFormat(format.pixelFormat), format.width, format.height);
  avFrame->pts = frame->pts;
}

void FFVFrameFillFromAVFrame(FFVFrameRef frame, AVFrame *avFrame) {
  FFVFormat format = frame->format;
  avpicture_fill(AVPictureFromFFVFrame(frame), *avFrame->data, PixelFormatFromFFPixelFormat(format.pixelFormat), format.width, format.height);
  frame->flags |= FFVFLAGS_EXTERNAL_DATA;
  frame->pts = avFrame->pts;
}

FFRational FFRationalFromAVRational(AVRational rational) {
  return (FFRational){rational.num, rational.den};
}

AVRational AVRationalFromFFRational(FFRational rational) {
  return (AVRational){rational.num, rational.den};
}

#pragma mark - 

void FFMPInitialize(void) {
  if (FFMPIsInitialized()) return;
  gFFMPInitialized = YES;
  av_register_all();
  
  av_init_packet(&gAVFlushPacket);
  gAVFlushPacket.data = (uint8_t *)"FLUSH";
}

BOOL FFMPIsInitialized(void) {
  return gFFMPInitialized;
}

BOOL FFIsAVFlushPacket(AVPacket *packet) {
  return (packet->data == gAVFlushPacket.data);
}
