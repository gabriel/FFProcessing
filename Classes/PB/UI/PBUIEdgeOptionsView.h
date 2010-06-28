//
//  PBUIEdgeOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/27/10.
//  Copyright 2010. All rights reserved.
//

#import "FFFilter.h"

#import "FFCannyEdgeFilter.h"

@protocol PBOptionsDelegate;

@interface PBUIEdgeOptionsView : UIView {
  UISlider *_slider1;
  UISlider *_slider2;
  
  FFCannyEdgeFilter *_filter;
  
  id<PBOptionsDelegate> _optionsDelegate;
}

@property (readonly, nonatomic) UISlider *slider1;
@property (readonly, nonatomic) UISlider *slider2;

@property (assign, nonatomic) id<PBOptionsDelegate> optionsDelegate;

- (void)update;

@end
