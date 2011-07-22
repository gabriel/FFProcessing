//
//  PBUIBaseOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 7/6/10.
//  Copyright 2010 All rights reserved.
//

#import "YKUIView.h"
#import "YKUIView+Utils.h"
#import "YKUIButton.h"

#import "FFGLImaging.h"
#import "FFFilter.h"

@protocol PBOptionsDelegate <NSObject>
- (void)updateImagingOptions:(FFGLImagingOptions)options;
- (void)updateFilter:(id<FFFilter>)filter;
@end

@interface PBUIBaseOptionsView : YKUIView {
  UILabel *_titleLabel;
  YKUIButton *_backButton;
  
  UIView *_contentView;
  
  BOOL _display;

  id<PBOptionsDelegate> _optionsDelegate;
}

@property (assign, nonatomic) id<PBOptionsDelegate> optionsDelegate;
@property (retain, nonatomic) NSString *title;
@property (readonly, nonatomic) UIView *contentView;
@property (assign, nonatomic) BOOL display;

- (void)update;

@end
