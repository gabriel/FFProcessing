//
//  FFOpticalFlow.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/27/10.
//  Copyright 2010. All rights reserved.
//

#import "FFOpticalFlow.h"

#import "FFTypes.h"
#import "FFUtils.h"

@implementation FFOpticalFlow

- (id)init {
  if ((self = [super init])) { }
  return self;
}

- (void)dealloc {
  if (_image) cvReleaseImage(&_image);
  if (_frame1) cvReleaseImage(&_frame1);
  if (_temp) cvReleaseImage(&_temp);
  if (_eigen) cvReleaseImage(&_eigen);
  if (_pyramid1) cvReleaseImage(&_pyramid1);
  if (_pyramid2) cvReleaseImage(&_pyramid2);
  [super dealloc];
}

- (FFVFrameRef)filterFrame:(FFVFrameRef)frame error:(NSError **)error {
  
  static int frameCount = 0;
  
  CvSize size = cvSize(frame->format.width, frame->format.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 4);
  if (!_frame1) _frame1 = cvCreateImage(size, IPL_DEPTH_8U, 1);
  if (!_frame2) _frame2 = cvCreateImage(size, IPL_DEPTH_8U, 1);
  if (!_temp) _temp = cvCreateImage(size, IPL_DEPTH_32F, 1);
  if (!_eigen) _eigen = cvCreateImage(size, IPL_DEPTH_32F, 1);
  if (!_pyramid1) _pyramid1 = cvCreateImage(size, IPL_DEPTH_8U, 1);
  if (!_pyramid2) _pyramid2 = cvCreateImage(size, IPL_DEPTH_8U, 1);
  
  _image->imageData = (char *)frame->data[0];
  // If first frame, save to frame1; Otherwise save frame2 and proceed
  if ((frameCount++ % 2) == 0) {
    cvCvtColor(_image, _frame1, CV_BGRA2GRAY);
    return nil;
  } else {
    cvCvtColor(_image, _frame2, CV_BGRA2GRAY);
  }
  
  const int MAX_FEATURES = 400;  
  CvPoint2D32f features1[MAX_FEATURES];
  int featureCount = MAX_FEATURES;
  const double qualityLevel = 0.1;
  const double minDistance = 5;
  const int eigBlockSize = 3;
  const int useHarris = false;
  const double k = 0.04; // Used only if harris
  const CvScalar color = {0, 0, 255, 0};
  
  cvGoodFeaturesToTrack(_frame1, _eigen, _temp,
                        features1, &featureCount, qualityLevel,
                        minDistance, NULL, eigBlockSize, useHarris, k);

  CvPoint2D32f features2[MAX_FEATURES];
  
  // The i-th element of this array will be non-zero if and only if the i-th feature of
  // frame 1 was found in frame 2
  char opticalFlowFoundFeature[MAX_FEATURES];
  
  // The i-th element of this array is the error in the optical flow for the i-th feature
  // of frame1 as found in frame 2.  If the i-th feature was not found (see the array above)
  // I think the i-th entry in this array is undefined.
  float opticalFlowFeatureError[MAX_FEATURES];
  
  // This is the window size to use to avoid the aperture problem
  CvSize opticalFlowWindow = cvSize(3, 3);
  
  // This termination criteria tells the algorithm to stop when it has either done 5 iterations or when
  // epsilon is better than .3.  You can play with these parameters for speed vs. accuracy but these values
  // work pretty well in many situations.
  CvTermCriteria opticalFlowTerminationCriteria = cvTermCriteria(CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 5, 0.3);

  // Pyramidal Lucas Kanade Optical Flow
  // _frame1 is the first frame with the known features
  // _frame2 is the second frame where we want to find the first frame's features
  // _pyramid1 is workspace for the algorithm (1)
  // _pyramid2 is workspace for the algorithm (2)
  // features1 are the features from the first frame
  // features2 is the (outputted) locations of those features in the second frame
  // featureCount is the number of features in features1
  // opticalFlowWindow is the size of the window to use to avoid the aperture problem
  // 5 is the maximum number of pyramids to use.  0 would be just one level
  // opticalFlowFoundFeature is as described above (non-zero iff feature found by the flow)
  // opticalFlowFeatureError is as described above (error in the flow for this feature)
  // opticalFlowTerminationCriteria is as described above (how long the algorithm should look)
  // 0 means disable enhancements; For example, the second array isn't pre-initialized with guesses
  cvCalcOpticalFlowPyrLK(_frame1, _frame2, _pyramid1, _pyramid2, features1, features2, 
                         featureCount, opticalFlowWindow, 5, opticalFlowFoundFeature, opticalFlowFeatureError, 
                         opticalFlowTerminationCriteria, 0);
  
  for (int i = 0; i < featureCount; i++) {
    CvPoint p0 = cvPoint(cvRound(features1[i].x), cvRound(features1[i].y));
    CvPoint p1 = cvPoint(cvRound(features2[i].x), cvRound(features2[i].y));
    cvLine(_image, p0, p1, color, 2, 8, 0);
  }

  return frame;
}

@end