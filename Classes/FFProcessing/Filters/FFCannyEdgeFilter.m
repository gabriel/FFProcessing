//
//  FFCannyEdgeFilter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/3/10.
//  Copyright 2010. All rights reserved.
//

#import "FFCannyEdgeFilter.h"

#import "FFTypes.h"
#import "cv.h"

@implementation FFCannyEdgeFilter

- (void)dealloc {
  if (_image) cvReleaseImage(&_image);
  if (_grey) cvReleaseImage(&_grey);
  if (_edges) cvReleaseImage(&_edges);
  if (_output) cvReleaseImage(&_output);
  [super dealloc];
}

- (FFAVFrame)filterAVFrame:(FFAVFrame)avFrame error:(NSError **)error {

  CvSize size = cvSize(avFrame.avFormat.width, avFrame.avFormat.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 3);
  if (!_grey) _grey = cvCreateImage(size, IPL_DEPTH_8U, 1);
  if (!_edges) _edges = cvCreateImage(size, IPL_DEPTH_8U, 1);
  if (!_output) _output = cvCreateImage(size, IPL_DEPTH_8U, 3);
  
  _image->imageData = (char *)avFrame.frame->data[0];

  cvCvtColor(_image, _grey, CV_RGB2GRAY);
  cvCanny(_grey, _edges, 10, 100, 3);
  
  cvCvtColor(_edges, _output, CV_GRAY2RGB);
  avFrame.frame->data[0] = (uint8_t *)_output->imageData;
  
  return avFrame;
}

@end
