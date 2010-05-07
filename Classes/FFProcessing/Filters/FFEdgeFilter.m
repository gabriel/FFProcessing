//
//  FFEdgeFilter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEdgeFilter.h"

#import "FFUtils.h"

@implementation FFEdgeFilter

- (void)dealloc {
  FFAVFrameRelease(_avFrame);
  [super dealloc];
}

- (FFAVFrame)filterPictureFrame:(FFAVFrame)avFrame error:(NSError **)error {
  
  NSAssert(avFrame.avFormat.pixelFormat == PIX_FMT_RGB24, @"Can only edge filter on PIX_FMT_RGB24");
  
  if (_avFrame.frame == NULL)
    _avFrame = FFAVFrameCreate(avFrame.avFormat);
  
  int x = 0;
  int y = 0;
  int width = avFrame.avFormat.width;
  int height = avFrame.avFormat.height;
  
  while (y < height) {

    
    // Next position
    x++;
    if (x >= width) {
      x = 0;
      y++;
    }
  }  
  
  return avFrame;
}

@end
