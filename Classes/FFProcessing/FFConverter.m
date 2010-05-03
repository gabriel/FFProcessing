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

- (id)initWithPictureFormat:(FFPictureFormat)pictureFormat {
  if ((self = [self init])) {
    _pictureFormat = pictureFormat;
  }
  return self;
}

- (void)dealloc {
  FFPictureFrameRelease(_pictureFrame);
  [super dealloc];
}  

- (FFPictureFrame)scalePicture:(FFPictureFrame)pictureFrame error:(NSError **)error {
  struct SwsContext *scaleContext = NULL;
  
  FFPictureFormat pictureFormat = _pictureFormat;
  if (pictureFormat.width == 0) pictureFormat.width = pictureFrame.pictureFormat.width;
  if (pictureFormat.height == 0) pictureFormat.height = pictureFrame.pictureFormat.height;
  if (pictureFormat.pixelFormat == PIX_FMT_NONE) pictureFormat.pixelFormat = pictureFrame.pictureFormat.pixelFormat;  
  
  NSAssert(pictureFormat.width != 0 && pictureFormat.height != 0 && pictureFormat.pixelFormat != PIX_FMT_NONE, @"Invalid picture format");
  
  if (_pictureFrame.frame == NULL) {
    _pictureFrame = FFPictureFrameCreate(pictureFormat);
    if (_pictureFrame.frame == NULL) {
      FFSetError(error, FFErrorCodeAllocateFrame, -1, @"Couldn't allocate frame in converter");
      return _pictureFrame;
    }
  }
  
  scaleContext = sws_getCachedContext(scaleContext, 
                                       pictureFrame.pictureFormat.width, pictureFrame.pictureFormat.height, pictureFrame.pictureFormat.pixelFormat,
                                       pictureFormat.width, pictureFormat.height, pictureFormat.pixelFormat, 
                                       SWS_BICUBIC, NULL, NULL, NULL);
  
  if (scaleContext == NULL) {
    FFSetError(error, FFErrorCodeScaleContext, -1, @"No scale context");
    return FFPictureFrameNone;
  }
  
  sws_scale(scaleContext, 
            (const uint8_t* const *)pictureFrame.frame->data, 
            (const int *)pictureFrame.frame->linesize, 
            0,
            pictureFormat.height, 
            _pictureFrame.frame->data, 
            _pictureFrame.frame->linesize);
  
  _pictureFrame.frame->pts = pictureFrame.frame->pts;
  
  return _pictureFrame;
}

#pragma mark FFFilter

- (FFPictureFrame)filterPictureFrame:(FFPictureFrame)pictureFrame error:(NSError **)error {
  return [self scalePicture:pictureFrame error:error];
}

@end
