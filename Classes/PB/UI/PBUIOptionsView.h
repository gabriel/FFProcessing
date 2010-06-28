//
//  PBUIOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/24/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIModeOptionsView.h"
#import "PBUISliderOptionsView.h"
#import "PBUIEdgeOptionsView.h"
#import "PBUIErodeOptionsView.h"
#import "FFGLImaging.h"
#import "FFFilter.h"

@protocol PBOptionsDelegate <NSObject>
- (void)updateImagingOptions:(FFGLImagingOptions)options;
- (void)updateFilter:(id<FFFilter>)filter;
@end

@interface PBUIOptionsView : UIScrollView {
  PBUIModeOptionsView *_modeOptionsView;
  
  id<PBOptionsDelegate> _optionsDelegate;
  
  FFGLImagingOptions _imagingOptions; 
  
  // Mode options
  PBUISliderOptionsView *_hueOptionsView;
  PBUISliderOptionsView *_brightnessOptionsView;
  PBUISliderOptionsView *_blurOptionsView;
  PBUISliderOptionsView *_contrastOptionsView;
  
  PBUIEdgeOptionsView *_edgeOptionsView;
  PBUIErodeOptionsView *_erodeOptionsView;
  
  NSMutableArray *_views;
  NSInteger _index;
  CGFloat _pageWidth;
}

@property (assign, nonatomic) id<PBOptionsDelegate> optionsDelegate;

- (void)popToRootViewAnimated:(BOOL)animated;

@end
