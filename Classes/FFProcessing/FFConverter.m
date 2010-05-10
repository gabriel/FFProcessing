//
//  FFConverter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFConverter.h"
#import "FFUtils.h"
#import "FFFilter.h"

@implementation FFConverter

- (id)initWithAVFormat:(FFAVFormat)avFormat {
  if ((self = [self init])) {
    _avFormat = avFormat;
  }
  return self;
}

- (void)dealloc {
  FFAVFrameRelease(_avFrame);
  [super dealloc];
}  

- (FFAVFrame)scalePicture:(FFAVFrame)avFrame error:(NSError **)error {
  struct SwsContext *scaleContext = NULL;
  
  // Set conversion parameters based on input frame if any are 0 or none
  FFAVFormat avFormat = _avFormat;
  if (avFormat.width == 0) avFormat.width = avFrame.avFormat.width;
  if (avFormat.height == 0) avFormat.height = avFrame.avFormat.height;
  if (avFormat.pixelFormat == PIX_FMT_NONE) avFormat.pixelFormat = avFrame.avFormat.pixelFormat;  
  
  NSAssert(avFormat.width != 0 && avFormat.height != 0 && avFormat.pixelFormat != PIX_FMT_NONE, @"Invalid picture format");
  
  if (_avFrame.frame == NULL) {
    _avFrame = FFAVFrameCreate(avFormat);
    if (_avFrame.frame == NULL) {
      FFSetError(error, FFErrorCodeAllocateFrame, -1, @"Couldn't allocate frame in converter");
      return _avFrame;
    }
  }
  
  scaleContext = sws_getCachedContext(scaleContext, 
                                       avFrame.avFormat.width, avFrame.avFormat.height, avFrame.avFormat.pixelFormat,
                                       avFormat.width, avFormat.height, avFormat.pixelFormat, 
                                       SWS_FAST_BILINEAR, NULL, NULL, NULL);
  
  if (scaleContext == NULL) {
    FFSetError(error, FFErrorCodeScaleContext, -1, @"No scale context for %@ to %@", 
               NSStringFromFFAVFormat(avFrame.avFormat),
               NSStringFromFFAVFormat(avFormat));
    return FFAVFrameNone;
  }
  
  //FFDebug(@"Converting from %@ to %@", NSStringFromFFAVFormat(avFrame.avFormat),
  //        NSStringFromFFAVFormat(avFormat));
  
  sws_scale(scaleContext, 
            (const uint8_t* const *)avFrame.frame->data, 
            (const int *)avFrame.frame->linesize, 
            0,
            avFormat.height, 
            _avFrame.frame->data, 
            _avFrame.frame->linesize);
  
  _avFrame.frame->pts = avFrame.frame->pts;
  
  return _avFrame;
}

#pragma mark FFFilter

- (FFAVFrame)filterAVFrame:(FFAVFrame)avFrame error:(NSError **)error {
  return [self scalePicture:avFrame error:error];
}

@end
