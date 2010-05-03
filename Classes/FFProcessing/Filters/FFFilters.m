//
//  FFFilters.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFFilters.h"


@implementation FFFilters

- (id)initWithFilters:(NSArray */*of id<FFFilter>*/)filters {
  if ((self = [super init])) {
    _filters = [filters retain];
  }
  return self;
}

- (void)dealloc {
  [_filters release];
  [super dealloc];
}

- (FFPictureFrame)filterPictureFrame:(FFPictureFrame)pictureFrame error:(NSError **)error {
  for (id<FFFilter> filter in _filters) {
    pictureFrame = [filter filterPictureFrame:pictureFrame error:error];
    if (pictureFrame.frame == NULL) return FFPictureFrameNone;
  }
  return pictureFrame;
}

@end
