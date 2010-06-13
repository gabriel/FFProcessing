//
//  FFTypes.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010. All rights reserved.
//

typedef enum {
  kFFPixelFormatType_None = 0,
  kFFPixelFormatType_YUV420P,
  kFFPixelFormatType_32BGRA,
  kFFPixelFormatType_32RGBA,
  kFFPixelFormatType_32ARGB,
  kFFPixelFormatType_24RGB,
  kFFPixelFormatType_1Monochrome,  
} FFPixelFormat;

typedef struct {
  int width;
  int height;
  FFPixelFormat pixelFormat;
} FFVFormat;

struct __FFVFrame {  
  uint8_t *data[4]; //! Pointer to the picture planes  
  int linesize[4]; //! Line size of picture planes
  
  int64_t pts;
  FFVFormat format;
  int32_t flags; // Flags (see FFVFLAGS)
} _FFVFrame;

typedef enum {
  FFVFLAGS_EXTERNAL_DATA = 1 << 1
} FFVFLAGS;

typedef struct _FFRational {
  int num; // Numerator
  int den; // Denominator
} FFRational;

typedef struct __FFVFrame *FFVFrameRef;

#pragma mark FFAVFormat

static inline FFVFormat FFVFormatMake(int width, int height, FFPixelFormat pixelFormat) {
  return (FFVFormat){width, height, pixelFormat};
}

static inline NSString *NSStringFromFFVFormat(FFVFormat format) {
  return [NSString stringWithFormat:@"(%d,%d,%d)", format.width, format.height, format.pixelFormat];
}

BOOL FFVFormatIsEqual(FFVFormat format1, FFVFormat format2);

extern FFVFormat FFVFormatNone;

#pragma mark FFVFrame

FFVFrameRef FFVFrameCreate(FFVFormat format);

FFVFrameRef FFVFrameCreateWithData(FFVFormat format, uint8_t *data);

void FFVFrameSetData(FFVFrameRef frame, uint8_t *data);

void FFVFrameRelease(FFVFrameRef frame);

void FFVFrameCopy(FFVFrameRef source, FFVFrameRef dest);

FFVFrameRef FFVFrameCreateFromCGImage(CGImageRef image);

#pragma mark - 

static inline uint8_t *FFVFrameGetData(FFVFrameRef frame, int index) {
  return frame->data[index];
}

static inline int FFVFrameGetBytesPerPixel(FFVFrameRef frame, int index) {
  return frame->linesize[index] / frame->format.width;
}

static inline int FFVFrameGetBytesPerRow(FFVFrameRef frame, int index) {
  return frame->linesize[index];
}

static inline FFVFormat FFVFrameGetFormat(FFVFrameRef frame) {
  return frame->format;
}

/*!
#pragma mark FFRBG

static inline void FFVFrameGetRGB(FFVFrameRef frame, int x, int y, uint8_t *r, uint8_t *g, uint8_t *b) {
  //NSAssert(frame->format.pixelFormat == , @"Only supports RGB24");
  int p = (x * (FFVFrameGetBytesPerPixel(frame, 0))) + (y * FFVFrameGetBytesPerRow(frame, 0));
  
  uint8_t *data = FFVFrameGetData(frame, 0);
  *r = data[p];
  *g = data[p + 1];
  *b = data[p + 2];
}

static inline void FFVFrameSetRGB(FFVFrameRef frame, int x, int y, uint8_t r, uint8_t g, uint8_t b) {
  int p = (x * (FFVFrameGetBytesPerPixel(frame, 0))) + (y * FFVFrameGetBytesPerRow(frame, 0));
  uint8_t *data = FFVFrameGetData(frame, 0);
  data[p] = r;
  data[p + 1] = g;
  data[p + 2] = b;
}
*/
