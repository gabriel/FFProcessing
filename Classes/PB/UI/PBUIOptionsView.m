//
//  PBUIOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/24/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIOptionsView.h"

#import "GHNSMutableArray+Utils.h"

#import "FFCannyEdgeFilter.h"
#import "FFErodeFilter.h"

@implementation PBUIOptionsView

@synthesize optionsDelegate=_optionsDelegate;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _views = [[NSMutableArray alloc] initWithCapacity:10];
    
    _modeOptionsView = [[PBUIModeOptionsView alloc] initWithFrame:CGRectZero];
    [_modeOptionsView addButtonWithTitle:@"Hue" target:self action:@selector(_selectHue)];    
    [_modeOptionsView addButtonWithTitle:@"Brightness" target:self action:@selector(_selectBrightness)];
    [_modeOptionsView addButtonWithTitle:@"Blur" target:self action:@selector(_selectBlur)];
    [_modeOptionsView addButtonWithTitle:@"Contrast" target:self action:@selector(_selectContrast)];        
    [_modeOptionsView addButtonWithTitle:@"Edge" target:self action:@selector(_selectEdge)];        
    [_modeOptionsView addButtonWithTitle:@"Erode" target:self action:@selector(_selectErode)];        
    [self addSubview:_modeOptionsView];
    
    _hueOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_hueOptionsView.slider addTarget:self action:@selector(_hueSliderChanged) forControlEvents:UIControlEventValueChanged];

    _brightnessOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_brightnessOptionsView.slider addTarget:self action:@selector(_brightnessSliderChanged) forControlEvents:UIControlEventValueChanged];

    _blurOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_blurOptionsView.slider addTarget:self action:@selector(_blurSliderChanged) forControlEvents:UIControlEventValueChanged];

    _contrastOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_contrastOptionsView.slider addTarget:self action:@selector(_contrastSliderChanged) forControlEvents:UIControlEventValueChanged];
    
    _edgeOptionsView = [[PBUIEdgeOptionsView alloc] initWithFrame:CGRectZero];
    _erodeOptionsView = [[PBUIErodeOptionsView alloc] initWithFrame:CGRectZero];
    
    _imagingOptions = FFGLImagingOptionsMake(0, 1.0);
    
    _hueOptionsView.slider.value = _imagingOptions.hueAmount;
    _brightnessOptionsView.slider.value = _imagingOptions.brightnessAmount;
    _blurOptionsView.slider.value = _imagingOptions.blurAmount;
    _contrastOptionsView.slider.value = _imagingOptions.contrastAmount;

    self.scrollEnabled = NO;
  }
  return self;
}

- (void)dealloc {
  [_views release];
  
  [_hueOptionsView release];
  [_brightnessOptionsView release];
  [_blurOptionsView release];
  [_contrastOptionsView release];
  
  [_edgeOptionsView release];
  [_erodeOptionsView release];
  
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

- (void)setOptionsDelegate:(id<PBOptionsDelegate>)optionsDelegate {
  _optionsDelegate = optionsDelegate;
  _edgeOptionsView.optionsDelegate = optionsDelegate;
  _erodeOptionsView.optionsDelegate = optionsDelegate;
}

- (void)_selectHue { 
  _imagingOptions.mode = FFGLImagingHue;
  _imagingOptions.hueAmount = _hueOptionsView.slider.value;
  [_optionsDelegate updateImagingOptions:_imagingOptions];
  [self pushView:_hueOptionsView animated:YES];
}

- (void)_selectBrightness { 
  _imagingOptions.mode = FFGLImagingBrightness;
  _imagingOptions.brightnessAmount = _brightnessOptionsView.slider.value;
  [_optionsDelegate updateImagingOptions:_imagingOptions];
  [self pushView:_brightnessOptionsView animated:YES];  
}

- (void)_selectBlur { 
  _imagingOptions.mode = FFGLImagingBlur;
  _imagingOptions.blurAmount = _blurOptionsView.slider.value;
  [_optionsDelegate updateImagingOptions:_imagingOptions];
  [self pushView:_blurOptionsView animated:YES];    
}

- (void)_selectContrast {
  _imagingOptions.mode = FFGLImagingContrast;
  _imagingOptions.contrastAmount = _contrastOptionsView.slider.value;
  [_optionsDelegate updateImagingOptions:_imagingOptions];
  [self pushView:_contrastOptionsView animated:YES];      
}

- (void)_selectEdge {  
  [_edgeOptionsView update];
  [self pushView:_edgeOptionsView animated:YES];      
}

- (void)_selectErode {  
  [_erodeOptionsView update];
  [self pushView:_erodeOptionsView animated:YES];  
}

#pragma mark -

- (void)_hueSliderChanged {
  _imagingOptions.hueAmount = _hueOptionsView.slider.value;
  [_optionsDelegate updateImagingOptions:_imagingOptions];
}

- (void)_brightnessSliderChanged {
  _imagingOptions.brightnessAmount = _brightnessOptionsView.slider.value;
  [_optionsDelegate updateImagingOptions:_imagingOptions];
}

- (void)_blurSliderChanged {
  _imagingOptions.blurAmount = _blurOptionsView.slider.value;
  [_optionsDelegate updateImagingOptions:_imagingOptions];
}

- (void)_contrastSliderChanged {
  _imagingOptions.contrastAmount = _contrastOptionsView.slider.value;
  [_optionsDelegate updateImagingOptions:_imagingOptions];
}

@end
