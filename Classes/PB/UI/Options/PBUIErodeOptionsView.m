//
//  PBUIErodeOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/27/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIErodeOptionsView.h"

#import "PBUIModeNavigationView.h"

@implementation PBUIErodeOptionsView

@synthesize slider=_slider;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.title = @"Erode";
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 20, 280, 22)];
    _slider.minimumValue = 1.0;
    _slider.maximumValue = 5.0;
    _slider.value = 3.0;
    [_slider addTarget:self action:@selector(_sliderChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];
    
    _filter = [[FFErodeFilter alloc] init];
  }
  return self;
}

- (void)dealloc {
  [_slider release];
  [_filter release];
  [super dealloc];
}

- (void)layoutSubviews {
  _slider.frame = YKCGRectToCenterX(_slider.frame, self.frame);
}

- (void)update {
  [self.optionsDelegate updateFilter:_filter];
}

- (void)_sliderChanged {
  _filter.iterations = _slider.value;
  [self.optionsDelegate updateFilter:_filter];
}

@end
