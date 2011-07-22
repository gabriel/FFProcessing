//
//  PBUIModeNavigationView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/24/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIModeOptionsView.h"
#import "PBUISliderOptionsView.h"
#import "PBUIEdgeOptionsView.h"
#import "PBUIErodeOptionsView.h"
#import "PBUISmoothOptionsView.h"
#import "PBUIFeatureTrackingOptionsView.h"
#import "PBUIOpticalFlowOptionsView.h"
#import "FFGLImaging.h"
#import "FFFilter.h"

@interface PBUIModeNavigationView : UIScrollView {
  PBUIModeOptionsView *_modeOptionsView;
  
  id<PBOptionsDelegate> _optionsDelegate;
  
  FFGLImagingOptions _imagingOptions; 
  
  // Mode options

  // Imaging
  PBUISliderOptionsView *_hueOptionsView;
  PBUISliderOptionsView *_brightnessOptionsView;
  PBUISliderOptionsView *_blurOptionsView;
  PBUISliderOptionsView *_contrastOptionsView;
  
  // Filters
  PBUIEdgeOptionsView *_edgeOptionsView;
  PBUIErodeOptionsView *_erodeOptionsView;  
  PBUISmoothOptionsView *_smoothOptionsView;
  PBUIFeatureTrackingOptionsView *_featureTrackingOptionsView;
  PBUIOpticalFlowOptionsView *_opticalFlowOptionsView;
  
  NSMutableArray *_views;
  NSInteger _index;
  CGFloat _pageWidth;
}

@property (assign, nonatomic) id<PBOptionsDelegate> optionsDelegate;

- (void)popToRootViewAnimated:(BOOL)animated;

@end
