//
//  FFFilters.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010. All rights reserved.
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

- (FFAVFrame)filterAVFrame:(FFAVFrame)avFrame error:(NSError **)error {
  for (id<FFFilter> filter in _filters) {
    avFrame = [filter filterAVFrame:avFrame error:error];
    if (avFrame.frame == NULL) return FFAVFrameNone;
  }
  return avFrame;
}

@end
