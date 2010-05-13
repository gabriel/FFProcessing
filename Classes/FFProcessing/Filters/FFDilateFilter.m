//
//  FFDilateFilter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/13/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDilateFilter.h"


@implementation FFDilateFilter

- (void)dealloc {
  // TODO(gabe): Fix leak
  //if (_image) cvReleaseImage(&_image);
  [super dealloc];
}

- (FFAVFrame)filterAVFrame:(FFAVFrame)avFrame error:(NSError **)error {
  
  CvSize size = cvSize(avFrame.avFormat.width, avFrame.avFormat.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 4);
  
  _image->imageData = (char *)avFrame.frame->data[0];
  
  cvDilate(_image, _image, NULL, 4);
  
  avFrame.frame->data[0] = (uint8_t *)_image->imageData;
  
  return avFrame;
}

@end
