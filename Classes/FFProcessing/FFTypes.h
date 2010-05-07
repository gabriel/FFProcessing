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

static inline FFAVFormat FFAVFormatMake(int width, int height, FFPixelFormat pixelFormat) {
  return (FFAVFormat){width, height, pixelFormat};
}

static inline FFAVFrame FFAVFrameMake(AVFrame *frame, FFAVFormat avFormat) {
  return (FFAVFrame){frame, avFormat};
}

extern FFAVFormat FFAVFormatNone;
extern FFAVFrame FFAVFrameNone;

static inline BOOL FFAVFormatIsNone(FFAVFormat avFormat) {
  return (avFormat.width == 0 && avFormat.height == 0 && avFormat.pixelFormat == PIX_FMT_NONE);
}

typedef struct {
  uint8_t r;
  uint8_t g;
  uint8_t b;
} FFRGB;

static inline FFRGB FFRGBMake(uint8_t r, uint8_t g, uint8_t b) {
  return (FFRGB){r, g, b};
}
