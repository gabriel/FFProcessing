//
//  FFCanny.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/3/10.
//  Copyright 2010. All rights reserved.
//

#import "cv.h"

#import "FFFilter.h"

@interface FFCanny : NSObject <FFFilter> {
  IplImage *_image;
  IplImage *_grey;
  IplImage *_output;
  
  double _threshold1;
  double _threshold2;
  int _apertureSize;
}

@property (assign, nonatomic) double threshold1;
@property (assign, nonatomic) double threshold2;
@property (assign, nonatomic) int apertureSize;


@end
