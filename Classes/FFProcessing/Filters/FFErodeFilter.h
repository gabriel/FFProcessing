//
//  FFErodeFilter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/9/10.
//  Copyright 2010. All rights reserved.
//

#import "cv.h"

#import "FFFilter.h"

@interface FFErodeFilter : NSObject <FFFilter> {
  IplImage *_image;
  
  int _iterations;
}

@property (assign, nonatomic) int iterations;

@end
