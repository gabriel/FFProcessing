//
//  FFTypes.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"
#import "FFUtils.h"

FFAVFormat FFAVFormatNone = {0, 0, PIX_FMT_NONE};

FFAVFrame FFAVFrameNone = {NULL, {0, 0, PIX_FMT_NONE}};

FFAVFrame FFAVFrameCreate(FFAVFormat avFormat) {
  return FFAVFrameCreateWithData(avFormat, NULL);
}

void FFAVFrameSetData(FFAVFrame avFrame, uint8_t *data) {
  // TODO(gabe): Deallocate existing data
  avpicture_fill((AVPicture *)avFrame.frame, data, avFrame.avFormat.pixelFormat, avFrame.avFormat.width, avFrame.avFormat.height);
}

FFAVFrame FFAVFrameCreateWithData(FFAVFormat avFormat, uint8_t *data) {
  
  AVFrame *picture = avcodec_alloc_frame();
  if (!picture) return FFAVFrameNone;
  
  if (data == NULL) {
    int size = avpicture_get_size(avFormat.pixelFormat, avFormat.width, avFormat.height);
    data = av_malloc(size);
  }
  
  if (data == NULL) {
    av_free(picture);
    return FFAVFrameNone;
  }
  
  avpicture_fill((AVPicture *)picture, data, avFormat.pixelFormat, avFormat.width, avFormat.height);
  return FFAVFrameMake(picture, avFormat);
}

void FFAVFrameRelease(FFAVFrame avFrame) {
  if (avFrame.frame != NULL)  {
    if (avFrame.frame->data != NULL) av_free(avFrame.frame->data[0]);
    av_free(avFrame.frame);
    avFrame.frame = NULL;
  }
}

FFAVFrame FFAVFrameCreateFromCGImageRef(CGImageRef image) {
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
    return FFAVFrameNone;
  }
  FFAVFormat format = FFAVFormatMake(CGImageGetWidth(image), CGImageGetHeight(image), pixelFormat);
  
  CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(image));
  uint8_t *data = (uint8_t *)CFDataGetBytePtr(dataRef);  
  CFIndex length = CFDataGetLength(dataRef);
  uint8_t *dataCopy = av_malloc(length);
  memcpy(dataCopy, data, length); 
  CFRelease(dataRef);
  
  FFAVFrame avFrame = FFAVFrameCreateWithData(format, dataCopy);  
  return avFrame;
}

