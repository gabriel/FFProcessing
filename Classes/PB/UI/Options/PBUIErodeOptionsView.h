//
//  PBUIErodeOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/27/10.
//  Copyright 2010. All rights reserved.
//

#import "FFFilter.h"

#import "FFErodeFilter.h"
#import "PBUIBaseOptionsView.h"

@interface PBUIErodeOptionsView : PBUIBaseOptionsView {
  UISlider *_slider;
  
  FFErodeFilter *_filter;
}

@property (readonly, nonatomic) UISlider *slider;

@end