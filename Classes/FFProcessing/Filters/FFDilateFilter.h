//
//  FFDilateFilter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/13/10.
//  Copyright 2010. All rights reserved.
//

#import "cv.h"
#import "FFFilter.h"

@interface FFDilateFilter : NSObject <FFFilter> {
  IplImage *_image;
}

@end
