//
//  FFOpticalFlow.h
//  FFProcessing
//
//  Created by Gabriel Handford on 7/27/10.
//  Copyright 2010. All rights reserved.
//


#import "cv.h"

#import "FFFilter.h"

@interface FFOpticalFlow : NSObject <FFFilter> {
  IplImage *_image;
  IplImage *_frame1;
  IplImage *_frame2;
  
  IplImage *_eigen;
  IplImage *_temp;
  
  IplImage *_pyramid1;
  IplImage *_pyramid2;
}

@end
