//
//  PBUIOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/24/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIOptionsView.h"

#import "GHNSMutableArray+Utils.h"

@implementation PBUIOptionsView

@synthesize optionsDelegate=_optionsDelegate;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _modeOptionsView = [[PBUIModeOptionsView alloc] initWithFrame:CGRectZero];
    [_modeOptionsView addButtonWithTitle:@"Hue" target:self action:@selector(_selectHue)];    
    [_modeOptionsView addButtonWithTitle:@"Brightness" target:self action:@selector(_selectBrightness)];
    [_modeOptionsView addButtonWithTitle:@"Blur" target:self action:@selector(_selectBlur)];
    [_modeOptionsView addButtonWithTitle:@"Contrast" target:self action:@selector(_selectContrast)];        
    [self addSubview:_modeOptionsView];
    
    _hueOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_hueOptionsView.slider addTarget:self action:@selector(_hueSliderChanged) forControlEvents:UIControlEventValueChanged];

    _brightnessOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_brightnessOptionsView.slider addTarget:self action:@selector(_brightnessSliderChanged) forControlEvents:UIControlEventValueChanged];

    _blurOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_blurOptionsView.slider addTarget:self action:@selector(_blurSliderChanged) forControlEvents:UIControlEventValueChanged];

    _contrastOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_contrastOptionsView.slider addTarget:self action:@selector(_contrastSliderChanged) forControlEvents:UIControlEventValueChanged];
    
    _options = (FFGLImagingOptions){NO, 0.0};
    
    self.scrollEnabled = NO;
  }
  return self;
}

- (void)dealloc {
  _hueOptionsView.delegate = nil;
  [_hueOptionsView release];
  [_modeOptionsView release];
  [super dealloc];
}

- (void)layoutSubviews {
  _modeOptionsView.frame = YKCGRectZeroOrigin(self.frame);

  _pageWidth = self.frame.size.width;
  self.contentSize = CGSizeMake(_pageWidth * 10, self.frame.size.height);  
}

- (void)pushView:(UIView *)view animated:(BOOL)animated {
  _index++;
  view.frame = CGRectMake((_pageWidth * _index), 0, _pageWidth, self.frame.size.height);
  [_views addObject:view];  
  [self addSubview:view];
  [self setContentOffset:CGPointMake(_pageWidth * _index, 0) animated:animated];
}

- (void)popViewAnimated:(BOOL)animated {
  [self setContentOffset:CGPointMake(_pageWidth * (_index - 1), 0) animated:animated];
  UIView *view = [_views gh_removeLastObject];
  [view removeFromSuperview];
  _index--;
}

- (void)popToRootViewAnimated:(BOOL)animated {
  [self setContentOffset:CGPointMake(0, 0) animated:animated];
  for (UIView *view in _views)
    [view removeFromSuperview];
  [_views removeAllObjects];
  _index = 0;  
}

- (void)_clearOptionsEnabled {
  _options.hueEnabled = NO;
  _options.brightnessEnabled = NO;
  _options.blurEnabled = NO;
  _options.contrastEnabled = NO;
}

- (void)_selectHue { 
  [self _clearOptionsEnabled];
  _options.hueEnabled = YES;
  [_optionsDelegate optionsView:self didChangeOptions:_options];
  [self pushView:_hueOptionsView animated:YES];
}

- (void)_selectBrightness { 
  [self _clearOptionsEnabled];
  _options.brightnessEnabled = YES;
  [_optionsDelegate optionsView:self didChangeOptions:_options];
  [self pushView:_brightnessOptionsView animated:YES];  
}

- (void)_selectBlur { 
  [self _clearOptionsEnabled];
  _options.blurEnabled = YES;
  [_optionsDelegate optionsView:self didChangeOptions:_options];
  [self pushView:_blurOptionsView animated:YES];    
}

- (void)_selectContrast {
  [self _clearOptionsEnabled];
  _options.contrastEnabled = YES;
  [_optionsDelegate optionsView:self didChangeOptions:_options];
  [self pushView:_contrastOptionsView animated:YES];      
}

#pragma mark -

- (void)_hueSliderChanged {
  _options.hueAmount = _hueOptionsView.value;
  [_optionsDelegate optionsView:self didChangeOptions:_options];
}

- (void)_brightnessSliderChanged {
  _options.brightnessAmount = _brightnessOptionsView.value;
  [_optionsDelegate optionsView:self didChangeOptions:_options];  
}

- (void)_blurSliderChanged {
  _options.blurAmount = _blurOptionsView.value;
  [_optionsDelegate optionsView:self didChangeOptions:_options];  
}

- (void)_contrastSliderChanged {
  _options.contrastAmount = _contrastOptionsView.value;
  [_optionsDelegate optionsView:self didChangeOptions:_options];  
}

@end
