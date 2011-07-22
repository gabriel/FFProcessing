//
//  PBUIModeNavigationView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/24/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIModeNavigationView.h"

@implementation PBUIModeNavigationView

@synthesize optionsDelegate=_optionsDelegate;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _views = [[NSMutableArray alloc] initWithCapacity:10];
    
    _modeOptionsView = [[PBUIModeOptionsView alloc] initWithFrame:CGRectZero];
    [_modeOptionsView addButtonWithTitle:@"Edge" tag:1 target:self action:@selector(_selectEdge:)];        
    [_modeOptionsView addButtonWithTitle:@"Erode" tag:2 target:self action:@selector(_selectErode:)];        
    [_modeOptionsView addButtonWithTitle:@"Hue" tag:3 target:self action:@selector(_selectHue:)];    
    [_modeOptionsView addButtonWithTitle:@"Smooth" tag:4 target:self action:@selector(_selectSmooth:)];    
    [_modeOptionsView addButtonWithTitle:@"Feature" tag:5 target:self action:@selector(_selectFeatureTracking:)];    
    [_modeOptionsView addButtonWithTitle:@"Optical" tag:6 target:self action:@selector(_selectOpticalFlow:)];    
    /*
    [_modeOptionsView addButtonWithTitle:@"Brightness" tag:4 target:self action:@selector(_selectBrightness)];
    [_modeOptionsView addButtonWithTitle:@"Blur" tag:5 target:self action:@selector(_selectBlur)];
    [_modeOptionsView addButtonWithTitle:@"Contrast" tag:6 target:self action:@selector(_selectContrast)];        
     */
    [self addSubview:_modeOptionsView];
    
    // Imaging
    _hueOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_hueOptionsView.slider addTarget:self action:@selector(_hueSliderChanged) forControlEvents:UIControlEventValueChanged];
    _brightnessOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_brightnessOptionsView.slider addTarget:self action:@selector(_brightnessSliderChanged) forControlEvents:UIControlEventValueChanged];
    _blurOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_blurOptionsView.slider addTarget:self action:@selector(_blurSliderChanged) forControlEvents:UIControlEventValueChanged];
    _contrastOptionsView = [[PBUISliderOptionsView alloc] initWithFrame:CGRectZero];
    [_contrastOptionsView.slider addTarget:self action:@selector(_contrastSliderChanged) forControlEvents:UIControlEventValueChanged];
    _imagingOptions = FFGLImagingOptionsMake(0, 1.0);
    _hueOptionsView.slider.value = _imagingOptions.hueAmount;
    _brightnessOptionsView.slider.value = _imagingOptions.brightnessAmount;
    _blurOptionsView.slider.value = _imagingOptions.blurAmount;
    _contrastOptionsView.slider.value = _imagingOptions.contrastAmount;

    _edgeOptionsView = [[PBUIEdgeOptionsView alloc] initWithFrame:CGRectZero];
    _erodeOptionsView = [[PBUIErodeOptionsView alloc] initWithFrame:CGRectZero];
    _smoothOptionsView = [[PBUISmoothOptionsView alloc] initWithFrame:CGRectZero];
    _smoothOptionsView.display = NO;
    _featureTrackingOptionsView = [[PBUIFeatureTrackingOptionsView alloc] initWithFrame:CGRectZero];
    _featureTrackingOptionsView.display = NO;
    _opticalFlowOptionsView = [[PBUIOpticalFlowOptionsView alloc] initWithFrame:CGRectZero];
    _opticalFlowOptionsView.display = NO;
    
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
  [_smoothOptionsView release];
  [_featureTrackingOptionsView release];
  [_opticalFlowOptionsView release];
  
  [_modeOptionsView release];
  [super dealloc];
}

- (void)layoutSubviews {
  _modeOptionsView.frame = CGRectMake(0, 22, self.yk_width, self.yk_height - 22);

  _pageWidth = self.yk_width;
  self.contentSize = CGSizeMake(_pageWidth * 10, self.yk_height);
}

- (void)pushView:(UIView *)view animated:(BOOL)animated {
  _index++;
  view.frame = CGRectMake((_pageWidth * _index), 0, _pageWidth, self.frame.size.height);
  [_views addObject:view];  
  [self addSubview:view];
  [self setContentOffset:CGPointMake(_pageWidth * _index, 0) animated:animated];
  [self setNeedsDisplay];
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

- (void)clear {
  [_optionsDelegate updateFilter:NULL];
  _imagingOptions.mode = 0;
  [_optionsDelegate updateImagingOptions:_imagingOptions];  
  [_modeOptionsView clearSelected];
}

- (void)_selectView:(UIView *)view optionsView:(PBUIBaseOptionsView *)optionsView {
  if ([_modeOptionsView isSelected:view.tag]) {
    [_modeOptionsView setSelected:view.tag];
    optionsView.optionsDelegate = _optionsDelegate;
    [optionsView update];
    if (optionsView.display)
      [self pushView:optionsView animated:YES];  
  } else {
    [self clear];
  }  
}

#pragma mark -

- (void)_selectHue:(UIView *)view { 
  if ([_modeOptionsView isSelected:view.tag]) {
    [_modeOptionsView setSelected:view.tag];
    _imagingOptions.mode = FFGLImagingHue;
    _imagingOptions.hueAmount = _hueOptionsView.slider.value;
    [_optionsDelegate updateImagingOptions:_imagingOptions];
    [self pushView:_hueOptionsView animated:YES];
  } else {
    [self clear];
  }
}

/*
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
 */

- (void)_selectEdge:(UIView *)view {  
  [self _selectView:view optionsView:_edgeOptionsView];
}

- (void)_selectErode:(UIView *)view {  
  [self _selectView:view optionsView:_erodeOptionsView];
}

- (void)_selectSmooth:(UIView *)view {
  [self _selectView:view optionsView:_smoothOptionsView];
}

- (void)_selectFeatureTracking:(UIView *)view {
  [self _selectView:view optionsView:_featureTrackingOptionsView];
}

- (void)_selectOpticalFlow:(UIView *)view {
  [self _selectView:view optionsView:_opticalFlowOptionsView];
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
