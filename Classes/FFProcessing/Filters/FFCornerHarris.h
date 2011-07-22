//
//  FFCornerHarris.h
//  FFProcessing
//
//  Created by Gabriel Handford on 7/18/10.
//  Copyright 2010. All rights reserved.
//

#import "cv.h"

#import "FFFilter.h"

@interface FFCornerHarris : NSObject <FFFilter> {
  IplImage *_image;
  IplImage *_grey;
  IplImage *_output;
  
  int _blockSize;
  int _apertureSize;
  double _k;
}

@property (assign, nonatomic) int blockSize;
@property (assign, nonatomic) int apertureSize;
@property (assign, nonatomic) double k;

@end
