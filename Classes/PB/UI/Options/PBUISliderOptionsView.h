//
//  PBUISliderOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/24/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIBaseOptionsView.h"

@interface PBUISliderOptionsView : PBUIBaseOptionsView {
  UISlider *_slider;
}

@property (readonly, nonatomic) UISlider *slider;

@end
