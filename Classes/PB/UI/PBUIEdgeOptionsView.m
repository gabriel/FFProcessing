//
//  PBUIEdgeOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/27/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIEdgeOptionsView.h"

#import "PBUIOptionsView.h"

@implementation PBUIEdgeOptionsView

@synthesize slider1=_slider1, slider2=_slider2, optionsDelegate=_optionsDelegate;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _slider1 = [[UISlider alloc] initWithFrame:CGRectMake(20, 20, 280, 22)];
    _slider1.minimumValue = 0;
    _slider1.maximumValue = 100.0;
    _slider1.value = 10.0;
    [_slider1 addTarget:self action:@selector(_slider1Changed) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider1];
    
    _slider2 = [[UISlider alloc] initWithFrame:CGRectMake(20, 60, 280, 22)];
    _slider2.minimumValue = 0;
    _slider2.maximumValue = 100.0;
    _slider2.value = 100.0;   
    [_slider2 addTarget:self action:@selector(_slider2Changed) forControlEvents:UIControlEventValueChanged];    
    [self addSubview:_slider2];
    
    _filter = [[FFCannyEdgeFilter alloc] init];
  }
  return self;
}

- (void)dealloc {
  [_slider1 release];
  [_slider2 release];
  [_filter release];
  [super dealloc];
}

- (void)layoutSubviews {
  _slider1.frame = YKCGRectToCenterX(_slider1.frame, self.frame);
  _slider2.frame = YKCGRectToCenterX(_slider2.frame, self.frame);
}

- (void)update {
  [_optionsDelegate updateFilter:_filter];
}

- (void)_slider1Changed {
  _filter.threshold1 = _slider1.value;
  [_optionsDelegate updateFilter:_filter];
}

- (void)_slider2Changed {
  _filter.threshold2 = _slider2.value;
  [_optionsDelegate updateFilter:_filter];
}

@end
