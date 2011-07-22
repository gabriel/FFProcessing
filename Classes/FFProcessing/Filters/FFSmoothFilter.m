//
//  FFSmoothFilter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/6/10.
//  Copyright 2010. All rights reserved.
//

#import "FFSmoothFilter.h"
#import "FFUtils.h"

@implementation FFSmoothFilter

- (void)dealloc {
  if (_image) cvReleaseImage(&_image);
  [super dealloc];
}

- (FFVFrameRef)filterFrame:(FFVFrameRef)frame error:(NSError **)error {
  
  CvSize size = cvSize(frame->format.width, frame->format.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 4);
  
  _image->imageData = (char *)frame->data[0];

  cvSmooth(_image, _image, CV_GAUSSIAN, 3, 0, 0, 0);
    
  frame->data[0] = (uint8_t *)_image->imageData;

  return frame;
}

@end
