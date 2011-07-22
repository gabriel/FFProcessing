//
//  PBUIFeatureTrackingOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/24/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIFeatureTrackingOptionsView.h"

@implementation PBUIFeatureTrackingOptionsView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.title = @"Feature Tracking";
    _filter = [[FFFeatureTracking alloc] init];
  }
  return self;
}

- (void)dealloc {
  [_filter release];
  [super dealloc];
}

- (void)update {
  [self.optionsDelegate updateFilter:_filter];
}

@end