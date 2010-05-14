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

- (FFVFrameRef)filterFrame:(FFVFrameRef)frame error:(NSError **)error {
  
  CvSize size = cvSize(frame->format.width, frame->format.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 4);
  
  _image->imageData = (char *)frame->data[0];
  
  cvDilate(_image, _image, NULL, 4);
  
  frame->data[0] = (uint8_t *)_image->imageData;
  
  return frame;
}

@end
