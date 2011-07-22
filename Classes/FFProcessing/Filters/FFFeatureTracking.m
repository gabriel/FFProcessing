//
//  FFFeatureTracking.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/24/10.
//  Copyright 2010. All rights reserved.
//

#import "FFFeatureTracking.h"

#import "FFTypes.h"

const int MAX_CORNERS = 100;

@implementation FFFeatureTracking

- (id)init {
  if ((self = [super init])) {
  }
  return self;
}

- (void)dealloc {
  if (_image) cvReleaseImage(&_image);
  if (_grey) cvReleaseImage(&_grey);
  if (_temp) cvReleaseImage(&_temp);
  if (_eigen) cvReleaseImage(&_eigen);
  [super dealloc];
}

- (FFVFrameRef)filterFrame:(FFVFrameRef)frame error:(NSError **)error {
  
  CvSize size = cvSize(frame->format.width, frame->format.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 4);
  if (!_grey) _grey = cvCreateImage(size, IPL_DEPTH_8U, 1);
  if (!_temp) _temp = cvCreateImage(size, IPL_DEPTH_32F, 1);
  if (!_eigen) _eigen = cvCreateImage(size, IPL_DEPTH_32F, 1);
  
  _image->imageData = (char *)frame->data[0];
  cvCvtColor(_image, _grey, CV_BGRA2GRAY);

  CvPoint2D32f corners[MAX_CORNERS];
  int cornerCount = MAX_CORNERS;
  static double qualityLevel = 0.1;
  static double minDistance = 5;
  static int eigBlockSize = 3;
  static int useHarris = false;
  static double k = 0.04; // Used only if harris
  CvScalar color = {0, 0, 255, 0};

  cvGoodFeaturesToTrack(_grey, _eigen, _temp,
                        corners, &cornerCount, qualityLevel,
                        minDistance, NULL, eigBlockSize, useHarris, k);
  
  //cvScale(_eigen, _eigen, 100, 0.00);
  
  // Draw circles around detected corners in original image
  int radius = frame->format.height/25;
  for (int i = 0; i < cornerCount; i++) {    
    CvPoint point = cvPoint((int)(corners[i].x + 0.5f), (int)(corners[i].y + 0.5f));
    cvCircle(_image, point, radius, color, 1, 8, 0);
  }

  return frame;
}

@end