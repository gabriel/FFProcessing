//
//  FFCannyEdgeFilter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/3/10.
//  Copyright 2010. All rights reserved.
//

#import "cv.h"

@interface FFCannyEdgeFilter : NSObject {
  IplImage *_image;
  IplImage *_grey;
  IplImage *_edges;
  IplImage *_output;
}

@end
