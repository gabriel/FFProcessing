//
//  PBUIEdgeOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/27/10.
//  Copyright 2010. All rights reserved.
//

#import "FFFilter.h"

#import "FFCanny.h"
#import "PBUIBaseOptionsView.h"

@interface PBUIEdgeOptionsView : PBUIBaseOptionsView {
  UISlider *_slider1;
  UISlider *_slider2;
  UISlider *_slider3;
  
  FFCanny *_filter;
}

- (void)update;

@end
