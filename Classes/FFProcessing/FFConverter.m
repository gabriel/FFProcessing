//
//  FFConverter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFConverter.h"
#import "FFUtils.h"
#import "FFTypes.h"

#include "libswscale/swscale.h"

@implementation FFConverter

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
  if (format.pixelFormat == PIX_FMT_NONE) format.pixelFormat = frameFormat.pixelFormat;  
  
  NSAssert(format.width != 0 && format.height != 0 && format.pixelFormat != PIX_FMT_NONE, @"Invalid picture format");
  
  if (_frame == NULL) {
    _frame = FFVFrameCreate(format);
    if (_frame == NULL) {
      FFSetError(error, FFErrorCodeAllocateFrame, -1, @"Couldn't allocate frame in converter");
      return NULL;
    }
  }
  
  scaleContext = sws_getCachedContext(scaleContext, 
                                       frameFormat.width, frameFormat.height, frameFormat.pixelFormat,
                                       format.width, format.height, format.pixelFormat, 
                                       SWS_FAST_BILINEAR, NULL, NULL, NULL);
  
  if (scaleContext == NULL) {
    FFSetError(error, FFErrorCodeScaleContext, -1, @"No scale context for %@ to %@", 
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
