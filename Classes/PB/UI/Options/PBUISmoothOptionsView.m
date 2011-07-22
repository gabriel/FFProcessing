//
//  PBUISmoothOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/6/10.
//  Copyright 2010 All rights reserved.
//

#import "PBUISmoothOptionsView.h"

@implementation PBUISmoothOptionsView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.title = @"Smooth";
    _filter = [[FFSmoothFilter alloc] init];
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
