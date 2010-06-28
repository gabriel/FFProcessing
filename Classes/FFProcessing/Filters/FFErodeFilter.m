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

@synthesize iterations=_iterations;

- (id)init {
  if ((self = [super init])) {
    _iterations = 3;
  }
  return self;
}

- (void)dealloc {
  if (_image) cvReleaseImage(&_image);
  [super dealloc];
}

- (FFVFrameRef)filterFrame:(FFVFrameRef)frame error:(NSError **)error {
  
  CvSize size = cvSize(frame->format.width, frame->format.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 4);
  
  _image->imageData = (char *)frame->data[0];
  
  cvErode(_image, _image, NULL, _iterations);

  frame->data[0] = (uint8_t *)_image->imageData;
  
  return frame;
}

@end
