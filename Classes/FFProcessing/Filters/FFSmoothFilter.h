//
//  FFSmoothFilter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 7/6/10.
//  Copyright 2010. All rights reserved.
//

#import "cv.h"
#import "FFFilter.h"

@interface FFSmoothFilter : NSObject <FFFilter> {
  IplImage *_image;
}

@end
