//
//  PBUICornerOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 7/18/10.
//  Copyright 2010. All rights reserved.
//

#import "FFFilter.h"

#import "FFCornerHarris.h"
#import "PBUIBaseOptionsView.h"

@interface PBUICornerOptionsView : PBUIBaseOptionsView {
  UISlider *_slider1;
  UISlider *_slider2;
  UISlider *_slider3;
  
  FFCornerHarris *_filter;
}

- (void)update;

@end