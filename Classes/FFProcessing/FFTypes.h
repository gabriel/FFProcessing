//
//  FFTypes.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010. All rights reserved.
//


#include "libavutil/pixfmt.h"
#include "libavcodec/avcodec.h"

typedef enum PixelFormat FFPixelFormat;

typedef struct {
  int width;
  int height;
  FFPixelFormat pixelFormat;
} FFAVFormat;

typedef struct {
  AVFrame *frame;
  FFAVFormat avFormat;
} FFAVFrame;

typedef struct {
  uint8_t r;
  uint8_t g;
  uint8_t b;
} FFRGB;

#pragma mark FFAVFormat

static inline FFAVFormat FFAVFormatMake(int width, int height, FFPixelFormat pixelFormat) {
  return (FFAVFormat){width, height, pixelFormat};
}

static inline NSString *NSStringFromFFAVFormat(FFAVFormat avFormat) {
  return [NSString stringWithFormat:@"(%d,%d,%d)", avFormat.width, avFormat.height, avFormat.pixelFormat];
}

extern FFAVFormat FFAVFormatNone;

static inline BOOL FFAVFormatIsNone(FFAVFormat avFormat) {
  return (avFormat.width == 0 && avFormat.height == 0 && avFormat.pixelFormat == PIX_FMT_NONE);
}

#pragma mark FFRBG

static inline FFRGB FFRGBMake(uint8_t r, uint8_t g, uint8_t b) {
  return (FFRGB){r, g, b};
}

static inline FFRGB FFRGBAt(FFAVFrame avFrame, int x, int y) {
  // TODO(gabe): Fixme
  //NSAssert(avFrame.avFormat.pixelFormat == PIX_FMT_RGB24, @"Only supports PIX_FMT_RGB24");
  int p = (x * 3) + (y * avFrame.frame->linesize[0]);
  FFRGB rgb;
  rgb.r = avFrame.frame->data[0][p];
  rgb.g = avFrame.frame->data[0][p + 1];
  rgb.b = avFrame.frame->data[0][p + 2];  
  return rgb;
}

static inline void FFRGBSetAt(FFAVFrame avFrame, int x, int y, FFRGB rgb) {
  int p = (x * 3) + (y * avFrame.frame->linesize[0]);
  avFrame.frame->data[0][p] = rgb.r;
  avFrame.frame->data[0][p + 1] = rgb.g;
  avFrame.frame->data[0][p + 2] = rgb.b;
}

#pragma mark AVFrame

extern FFAVFrame FFAVFrameNone;

static inline FFAVFrame FFAVFrameMake(AVFrame *frame, FFAVFormat avFormat) {
  return (FFAVFrame){frame, avFormat};
}

FFAVFrame FFAVFrameCreate(FFAVFormat avFormat);

FFAVFrame FFAVFrameCreateWithData(FFAVFormat avFormat, uint8_t *data);

void FFAVFrameSetData(FFAVFrame avFrame, uint8_t *data);

void FFAVFrameRelease(FFAVFrame avFrame);

FFAVFrame FFAVFrameCreateFromCGImageRef(CGImageRef image);

