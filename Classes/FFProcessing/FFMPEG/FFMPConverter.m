//
//  FFMPConverter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFMPConverter.h"
#import "FFUtils.h"
#import "FFTypes.h"
#import "FFMPUtils.h"

#include "libswscale/swscale.h"

@implementation FFMPConverter

- (id)initWithFormat:(FFVFormat)format {
  if ((self = [self init])) {
    _format = format;
  }
  return self;
}

- (void)dealloc {
  FFVFrameRelease(_frame);
  [super dealloc];
}  

- (FFVFrameRef)scaleFrame:(FFVFrameRef)frame error:(NSError **)error {
  struct SwsContext *scaleContext = NULL;
  
  // Set conversion parameters based on input frame if any are 0 or none
  FFVFormat format = _format;
  FFVFormat frameFormat = FFVFrameGetFormat(frame);
  if (format.width == 0) format.width = frameFormat.width;
  if (format.height == 0) format.height = frameFormat.height;
  if (format.pixelFormat == kFFPixelFormatType_None) format.pixelFormat = frameFormat.pixelFormat;  
  
  NSAssert(format.width != 0 && format.height != 0 && format.pixelFormat != kFFPixelFormatType_None, @"Invalid picture format");
  
  if (_frame == NULL || !FFVFormatIsEqual(_frame->format, format)) {
    FFVFrameRelease(_frame);
    _frame = FFVFrameCreate(format);
    if (_frame == NULL) {
      FFSetError(error, FFErrorCodeAllocateFrame, @"Couldn't allocate frame in converter");
      return NULL;
    }
  }

  FFDebug(@"Converting from %@ to %@", NSStringFromFFVFormat(frameFormat),
          NSStringFromFFVFormat(format));

  FFDebug(@"Converting (FFMP) %d,%d,%d to %d,%d,%d", 
          frameFormat.width, frameFormat.height, PixelFormatFromFFPixelFormat(frameFormat.pixelFormat),
          format.width, format.height, PixelFormatFromFFPixelFormat(format.pixelFormat));

  scaleContext = sws_getCachedContext(scaleContext, 
                                      frameFormat.width, frameFormat.height, PixelFormatFromFFPixelFormat(frameFormat.pixelFormat),
                                      format.width, format.height, PixelFormatFromFFPixelFormat(format.pixelFormat), 
                                      SWS_FAST_BILINEAR, NULL, NULL, NULL);
  
  if (scaleContext == NULL) {
    FFMPSetError(error, FFErrorCodeScaleContext, -1, @"No scale context for %@ to %@", 
               NSStringFromFFVFormat(frameFormat),
               NSStringFromFFVFormat(format));
    return NULL;
  }
  
  //FFDebug(@"Converting from %@ to %@", NSStringFromFFAVFormat(avFrame.avFormat),
  //        NSStringFromFFAVFormat(avFormat));
  
  sws_scale(scaleContext, 
            (const uint8_t* const *)frame->data,
            (const int *)frame->linesize,
            0,
            format.height, 
            _frame->data,
            _frame->linesize);
  
  // TODO(gabe): Should make sure we have all the fields set with fill method (probably do this in FFTypes)
  _frame->pts = frame->pts;
  
  return _frame;
}

#pragma mark FFFilter

- (FFVFrameRef)filterFrame:(FFVFrameRef)frame error:(NSError **)error {
  return [self scaleFrame:frame error:error];
}

@end
