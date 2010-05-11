//
//  FFErodeFilter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/9/10.
//  Copyright 2010. All rights reserved.
//

#import "FFErodeFilter.h"

#import "FFTypes.h"
#import "FFUtils.h"

@implementation FFErodeFilter

- (void)dealloc {
  if (_image) cvReleaseImage(&_image);
  [super dealloc];
}

- (FFAVFrame)filterAVFrame:(FFAVFrame)avFrame error:(NSError **)error {
  
  CvSize size = cvSize(avFrame.avFormat.width, avFrame.avFormat.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 3);
  
  _image->imageData = (char *)avFrame.frame->data[0];
  
  FFDebug(@"Erode");
  cvErode(_image, _image, NULL, 3);

  avFrame.frame->data[0] = (uint8_t *)_image->imageData;
  
  return avFrame;
}

@end
