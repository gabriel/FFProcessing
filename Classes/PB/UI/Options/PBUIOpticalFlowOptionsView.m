//
//  PBUIOpticalFlowOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/27/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIOpticalFlowOptionsView.h"


@implementation PBUIOpticalFlowOptionsView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.title = @"Optical Flow";
    _filter = [[FFOpticalFlow alloc] init];
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
