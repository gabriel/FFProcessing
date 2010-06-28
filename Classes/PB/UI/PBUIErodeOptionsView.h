//
//  PBUIErodeOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/27/10.
//  Copyright 2010. All rights reserved.
//

#import "FFFilter.h"

#import "FFErodeFilter.h"

@protocol PBOptionsDelegate;

@interface PBUIErodeOptionsView : UIView {
  UISlider *_slider;
  
  FFErodeFilter *_filter;
  
  id<PBOptionsDelegate> _optionsDelegate;
}

@property (readonly, nonatomic) UISlider *slider;

@property (assign, nonatomic) id<PBOptionsDelegate> optionsDelegate;

- (void)update;

@end