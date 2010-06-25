//
//  YKUIView.h
//  YelpKit
//
//  Created by Gabriel Handford on 6/19/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIView+Utils.h"

@class YKUIView;

@protocol YKUIViewDelegate <NSObject>
@optional
- (void)view:(YKUIView *)view didTouchWhenDisabled:(NSSet *)touches event:(UIEvent *)event;
@end

@interface YKUIView : UIView {

  BOOL _touchDisabled;
  BOOL _touchDisabledUserInteractionEnabled;
  
  BOOL _frameFixed;
  
  id<YKUIViewDelegate> _delegate; // weak
  
}

@property (assign, nonatomic, getter=isTouchDisabled) BOOL touchDisabled;
@property (assign, nonatomic, getter=isFrameFixed) BOOL frameFixed; // If YES, setFrame is a no-op

@property (assign, nonatomic) id<YKUIViewDelegate> delegate;

- (void)animateVerticalWithStart:(CGFloat)start end:(CGFloat)end;

//! For debugging bounds
- (void)drawBoundsDebugging;

@end
