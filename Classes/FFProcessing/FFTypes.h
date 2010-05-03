//
//  FFTypes.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010 Yelp. All rights reserved.
//


#include "libavutil/pixfmt.h"
#include "libavcodec/avcodec.h"

typedef enum PixelFormat FFPixelFormat;

typedef struct {
  int width;
  int height;
  FFPixelFormat pixelFormat;
} FFPictureFormat;

typedef struct {
  AVFrame *frame;
  FFPictureFormat pictureFormat;
} FFPictureFrame;

static inline FFPictureFormat FFPictureFormatMake(int width, int height, FFPixelFormat pixelFormat) {
  return (FFPictureFormat){width, height, pixelFormat};
}

static inline FFPictureFrame FFPictureFrameMake(AVFrame *frame, FFPictureFormat pictureFormat) {
  return (FFPictureFrame){frame, pictureFormat};
}

extern FFPictureFormat FFPictureFormatNone;
extern FFPictureFrame FFPictureFrameNone;

static inline BOOL FFPictureFormatIsNone(FFPictureFormat pictureFormat) {
  return (pictureFormat.width == 0 && pictureFormat.height == 0 && pictureFormat.pixelFormat == PIX_FMT_NONE);
}

typedef struct {
  uint8_t r;
  uint8_t g;
  uint8_t b;
} FFRGB;

static inline FFRGB FFRGBMake(uint8_t r, uint8_t g, uint8_t b) {
  return (FFRGB){r, g, b};
}
