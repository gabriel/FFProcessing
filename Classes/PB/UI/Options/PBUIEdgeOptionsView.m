//
//  PBUIEdgeOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/27/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIEdgeOptionsView.h"

#import "PBUIModeNavigationView.h"

@implementation PBUIEdgeOptionsView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.title = @"Edge";
    
    _slider1 = [[UISlider alloc] initWithFrame:CGRectMake(20, 20, 280, 22)];
    _slider1.minimumValue = 0;
    _slider1.maximumValue = 100.0;
    _slider1.value = 10.0;
    [_slider1 addTarget:self action:@selector(_slider1Changed) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_slider1];
    
    _slider2 = [[UISlider alloc] initWithFrame:CGRectMake(20, 60, 280, 22)];
    _slider2.minimumValue = 0;
    _slider2.maximumValue = 1000.0;
    _slider2.value = 100.0;   
    [_slider2 addTarget:self action:@selector(_slider2Changed) forControlEvents:UIControlEventValueChanged];    
    [self.contentView addSubview:_slider2];

    // For aperature, value = 2x + 1
    _slider3 = [[UISlider alloc] initWithFrame:CGRectMake(20, 100, 280, 22)];
    _slider3.minimumValue = 1;
    _slider3.maximumValue = 3;
    _slider3.value = 1;
    [_slider3 addTarget:self action:@selector(_slider3Changed) forControlEvents:UIControlEventValueChanged];    
    [self.contentView addSubview:_slider3];
    
    _filter = [[FFCanny alloc] init];
  }
  return self;
}

- (void)dealloc {
  [_slider1 release];
  [_slider2 release];
  [_slider3 release];
  [_filter release];
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _slider1.frame = YKCGRectToCenterX(_slider1.frame, self.frame);
  _slider2.frame = YKCGRectToCenterX(_slider2.frame, self.frame);
  _slider3.frame = YKCGRectToCenterX(_slider3.frame, self.frame);
}

- (void)update {
  [self.optionsDelegate updateFilter:_filter];
}

- (void)_slider1Changed {
  _filter.threshold1 = roundf(_slider1.value);
  [self.optionsDelegate updateFilter:_filter];
}

- (void)_slider2Changed {
  _filter.threshold2 = roundf(_slider2.value);
  [self.optionsDelegate updateFilter:_filter];
}

- (void)_slider3Changed {
  _filter.apertureSize = (roundf(_slider3.value) * 2) + 1;
  [self.optionsDelegate updateFilter:_filter];
}

@end
