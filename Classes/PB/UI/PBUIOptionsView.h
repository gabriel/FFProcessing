//
//  PBUIOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/24/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIModeOptionsView.h"
#import "PBUISliderOptionsView.h"
#import "FFGLImaging.h"

@class PBUIOptionsView;

@protocol PBUIOptionsViewDelegate <NSObject>
- (void)optionsView:(PBUIOptionsView *)optionsView didChangeOptions:(FFGLImagingOptions)options;
@end

@interface PBUIOptionsView : UIScrollView {
  PBUIModeOptionsView *_modeOptionsView;
  
  id<PBUIOptionsViewDelegate> _optionsDelegate;
  
  FFGLImagingOptions _options;
  
  // Mode options
  PBUISliderOptionsView *_hueOptionsView;
  PBUISliderOptionsView *_brightnessOptionsView;
  PBUISliderOptionsView *_blurOptionsView;
  PBUISliderOptionsView *_contrastOptionsView;
  
  NSMutableArray *_views;
  NSInteger _index;
  CGFloat _pageWidth;
}

@property (assign, nonatomic) id<PBUIOptionsViewDelegate> optionsDelegate;

- (void)popToRootViewAnimated:(BOOL)animated;

@end
