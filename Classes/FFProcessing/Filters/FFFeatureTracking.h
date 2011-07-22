//
//  FFFeatureTracking.h
//  FFProcessing
//
//  Created by Gabriel Handford on 7/24/10.
//  Copyright 2010. All rights reserved.
//


#import "cv.h"

#import "FFFilter.h"

@interface FFFeatureTracking : NSObject <FFFilter> {
  IplImage *_image;
  IplImage *_grey;
  
  IplImage *_eigen;
  IplImage *_temp;
}

@end