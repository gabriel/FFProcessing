//
//  FFTypes.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"
#import "FFUtils.h"

FFVFormat FFVFormatNone = {0, 0, PIX_FMT_NONE};

FFVFrameRef FFVFrameCreate(FFVFormat format) {
  int size = avpicture_get_size(format.pixelFormat, format.width, format.height);
  uint8_t *data = av_malloc(size);  
  if (data == NULL)
    return NULL;

  return FFVFrameCreateWithData(format, data);  
}

void FFVFrameCopy(FFVFrameRef source, FFVFrameRef dest) {
  dest->format = source->format;
  dest->pts = source->pts;
  FFVFrameSetData(dest, source->data[0]);
}

void FFVFrameSetData(FFVFrameRef frame, uint8_t *data) {
  // TODO(gabe): Release existing data?
  FFVFormat format = FFVFrameGetFormat(frame);
  avpicture_fill((AVPicture *)frame, data, format.pixelFormat, format.width, format.height);
}

FFVFrameRef FFVFrameCreateWithData(FFVFormat format, uint8_t *data) {  
  FFVFrameRef frame = (FFVFrameRef)malloc(sizeof(FFVFrame));  
  if (data != NULL) FFVFrameSetData(frame, data);
  return frame;
}

void FFVFrameRelease(FFVFrameRef frame) {
  if (frame) {
    if (frame->data) {
      free(frame->data);
      frame->data[0] = NULL;
    }
    free(frame);
  }
}

FFVFrameRef FFVFrameCreateFromAVFrame(AVFrame *avFrame, FFVFormat format) {
  FFVFrameRef frame = FFVFrameCreateWithData(format, NULL);
  FFVFrameCopyFromAVFrame(frame, avFrame, format);
  return frame;
}

void FFVFrameCopyFromAVFrame(FFVFrameRef frame, AVFrame *avFrame, FFVFormat format) {
  // TODO(gabe): Release existing data?
  av_picture_copy((AVPicture *)frame, (AVPicture *)avFrame, format.pixelFormat, 
                  format.width, format.height);
}

FFVFrameRef FFVFrameCreateFromCGImage(CGImageRef image) {

  //CGBitmapInfo info = CGImageGetBitmapInfo(image); // CGImage may return pixels in RGBA, BGRA, or ARGB order
	CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(image));
	size_t bpp = CGImageGetBitsPerPixel(image);
  
  FFPixelFormat pixelFormat = PIX_FMT_NONE;
  if (colorSpaceModel == kCGColorSpaceModelRGB && bpp >= 24 && bpp <= 32) {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(image);
    switch (alphaInfo) {
      case kCGImageAlphaPremultipliedLast: pixelFormat = PIX_FMT_RGBA; break;
      case kCGImageAlphaPremultipliedFirst: pixelFormat = PIX_FMT_ARGB; break;
      case kCGImageAlphaNone: pixelFormat = PIX_FMT_RGB24; break;      
      default: FFWarn(@"Invalid alpha info: %d", alphaInfo); break;
    }
  } else if (colorSpaceModel == kCGColorSpaceModelMonochrome && bpp == 8) {
    pixelFormat = PIX_FMT_MONOWHITE;
  }
  
  if (pixelFormat == PIX_FMT_NONE) {
    FFWarn(@"Invalid pixel format for colorSpaceModel=%d, bpp=%d", colorSpaceModel, bpp);
    return NULL;
  }
  FFVFormat format = FFVFormatMake(CGImageGetWidth(image), CGImageGetHeight(image), pixelFormat);
  
  CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(image));
  uint8_t *data = (uint8_t *)CFDataGetBytePtr(dataRef);  
  CFIndex length = CFDataGetLength(dataRef);
  uint8_t *dataCopy = av_malloc(length);
  memcpy(dataCopy, data, length); 
  CFRelease(dataRef);
  
  return FFVFrameCreateWithData(format, dataCopy);
}
