//
//  YKUIView.m
//  YelpKit
//
//  Created by Gabriel Handford on 6/19/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIView.h"
#import "YKCGUtils.h"
#import "YKDefines.h"

@implementation YKUIView

@synthesize touchDisabled=_touchDisabled, frameFixed=_frameFixed, delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    // Must be initialized in case self.touchDisabled = NO is called before YES
    _touchDisabledUserInteractionEnabled = self.userInteractionEnabled;
  }
  return self;
}

- (void)setFrame:(CGRect)frame {
  if (_frameFixed) return;
  [super setFrame:frame];
}

- (void)drawBoundsDebugging {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetRGBStrokeColor(context, 1.0f, 0, 0, 1.0f);
  CGContextStrokeRectWithWidth(context, self.bounds, 1);
}

#pragma mark Touch (Disabling)

- (void)setTouchDisabled:(BOOL)touchDisabled {  
  _touchDisabled = touchDisabled;
  // Backup existing userInteractionEnabled setting
  if (touchDisabled) {
    _touchDisabledUserInteractionEnabled = self.userInteractionEnabled;
    self.userInteractionEnabled = YES;
  } else {
    self.userInteractionEnabled = _touchDisabledUserInteractionEnabled;
  }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  // If disable return ourselves since we will then ignore touches
  if (_touchDisabled) return self;
  return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  
  if (_touchDisabled) {
    if ([_delegate respondsToSelector:@selector(view:didTouchWhenDisabled:event:)]) {
      YPDebug(@"Touch while disabled");
      [_delegate view:self didTouchWhenDisabled:touches event:event];
    }
    return;
  }
  [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  if (_touchDisabled) return;
  [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (_touchDisabled) return;
  [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  if (_touchDisabled) return;
  [super touchesCancelled:touches withEvent:event];
}

#pragma mark Animation Help

- (void)animateVerticalWithStart:(CGFloat)start end:(CGFloat)end {  
  if (self.frame.origin.y == end) return; // Ignore if we are already at the end offset
  
  self.frame = YKCGRectSetOrigin(self.frame, 0, start);     
  [UIView beginAnimations:NULL context:nil];
  self.frame = YKCGRectSetOrigin(self.frame, 0, end);   
  [UIView commitAnimations];
}

@end
