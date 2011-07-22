//
//  FFChromaKeyFilter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 7/14/10.
//  Copyright 2010 All rights reserved.
//

#import "cv.h"
#import "FFFilter.h"

@interface FFChromaKeyFilter : NSObject <FFFilter> {
  IplImage *_image;
}

@end

