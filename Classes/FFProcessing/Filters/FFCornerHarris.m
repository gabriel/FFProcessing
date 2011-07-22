//
//  FFCornerHarris.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/18/10.
//  Copyright 2010. All rights reserved.
//

#import "FFCornerHarris.h"

#import "FFTypes.h"

@implementation FFCornerHarris

@synthesize apertureSize=_apertureSize, blockSize=_blockSize, k=_k;

- (id)init {
  if ((self = [super init])) {
    _blockSize = 3;
    _apertureSize = 3;
    _k = 0.04;
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
  if (!_output) _output = cvCreateImage(size, IPL_DEPTH_32F, 1);
  
  _image->imageData = (char *)frame->data[0];
  cvCvtColor(_image, _grey, CV_BGRA2GRAY);
  
  cvCornerHarris(_grey, _output, _blockSize, _apertureSize, _k);
  
  // UNTESTED
  
  cvScale(_output, _output, 100, 0.00);
  cvCvtColor(_output, _image, CV_GRAY2BGRA);

  return frame;
}

@end