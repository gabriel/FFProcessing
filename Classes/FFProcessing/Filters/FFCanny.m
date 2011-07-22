//
//  FFCanny.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/3/10.
//  Copyright 2010. All rights reserved.
//

#import "FFCanny.h"

#import "FFTypes.h"

@implementation FFCanny

@synthesize threshold1=_threshold1, threshold2=_threshold2, apertureSize=_apertureSize;

- (id)init {
  if ((self = [super init])) {
    _threshold1 = 10;
    _threshold2 = 100;
    _apertureSize = 3;
  }
  return self;
}

- (void)dealloc {
  if (_image) cvReleaseImage(&_image);
  if (_grey) cvReleaseImage(&_grey);
  if (_output) cvReleaseImage(&_output);  
  [super dealloc];
}

- (FFVFrameRef)filterFrame:(FFVFrameRef)frame error:(NSError **)error {

  CvSize size = cvSize(frame->format.width, frame->format.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 4);
  if (!_grey) _grey = cvCreateImage(size, IPL_DEPTH_8U, 1);
  if (!_output) _output = cvCreateImage(size, IPL_DEPTH_8U, 1);
  
  _image->imageData = (char *)frame->data[0];
  cvCvtColor(_image, _grey, CV_BGRA2GRAY);
  
  cvCanny(_grey, _output, _threshold1, _threshold2, _apertureSize);
  
  cvCvtColor(_output, _image, CV_GRAY2BGRA);
  frame->data[0] = (uint8_t *)_image->imageData;
  
  return frame;
}

@end
