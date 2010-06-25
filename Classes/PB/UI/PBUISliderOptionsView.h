//
//  PBUISliderOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/24/10.
//  Copyright 2010. All rights reserved.
//

@class PBUISliderOptionsView;

@protocol PBUISliderOptionsViewDelegate <NSObject>
- (void)optionsView:(PBUISliderOptionsView *)optionsView didChangeValue:(float)value;
@end

@interface PBUISliderOptionsView : UIView {
  UISlider *_slider;
  
  id<PBUISliderOptionsViewDelegate> _delegate;
}

@property (assign, nonatomic) id<PBUISliderOptionsViewDelegate> delegate;
@property (readonly, nonatomic) float value;
@property (readonly, nonatomic) UISlider *slider;

@end
