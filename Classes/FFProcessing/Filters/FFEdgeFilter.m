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
  FFPictureFrameRelease(_pictureFrame);
  [super dealloc];
}

- (FFPictureFrame)filterPictureFrame:(FFPictureFrame)pictureFrame error:(NSError **)error {
  
  NSAssert(pictureFrame.pictureFormat.pixelFormat == PIX_FMT_RGB24, @"Can only edge filter on PIX_FMT_RGB24");
  
  if (_pictureFrame.frame == NULL)
    _pictureFrame = FFPictureFrameCreate(pictureFrame.pictureFormat);
  
  int x = 0;
  int y = 0;
  int width = pictureFrame.pictureFormat.width;
  int height = pictureFrame.pictureFormat.height;
  
  while (y < height) {

    
    // Next position
    x++;
    if (x >= width) {
      x = 0;
      y++;
    }
  }  
  
  return pictureFrame;
}

@end
