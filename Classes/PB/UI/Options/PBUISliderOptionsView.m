//
//  PBUISliderOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/24/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUISliderOptionsView.h"

#import "YKCGUtils.h"

@implementation PBUISliderOptionsView

@synthesize slider=_slider;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 20, 280, 22)];
    _slider.minimumValue = 0;
    _slider.maximumValue = 2.0;
    _slider.value = 1.0;
    [self addSubview:_slider];
  }
  return self;
}

- (void)dealloc {
  [_slider release];
  [super dealloc];
}

- (void)layoutSubviews {
  _slider.frame = YKCGRectToCenterX(_slider.frame, self.frame);
}


@end
