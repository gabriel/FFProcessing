//
//  YKUIView+Utils.m
//  YelpKit
//
//  Created by Gabriel Handford on 10/6/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIView+Utils.h"

@implementation UIView (YPUtils)

- (NSInteger)yk_removeAllSubviews {
  NSInteger subviewCount = [self.subviews count];
  for(UIView *subview in self.subviews)
    [subview removeFromSuperview];
  return subviewCount;
}

- (void)yk_addHeight:(CGFloat)delta animated:(BOOL)animated {
  if (animated) [UIView beginAnimations:@"yk_addHeight" context:nil];
  self.frame = YKCGRectSetHeight(self.frame, self.frame.size.height + delta);
  [self.superview yk_addHeight:delta animated:NO];
  if (animated) [UIView commitAnimations];
}

- (void)_yp_findSubviewsOfClass:(Class)class view:(UIView *)view subviews:(NSMutableArray *)subviews limit:(NSInteger)limit {
  if ([subviews count] >= limit) return;
  for(UIView *subview in [view subviews]) {
    if ([subviews count] >= limit) break;
    if ([subview isKindOfClass:class]) {
      [subviews addObject:subview];
    } else {
      [self _yp_findSubviewsOfClass:class view:subview subviews:subviews limit:limit];
    }
  } 
}

- (NSArray *)yk_findSubviewsOfClass:(Class)class limit:(NSInteger)limit {
  NSMutableArray *subviews = [NSMutableArray arrayWithCapacity:2];
  [self _yp_findSubviewsOfClass:class view:self subviews:subviews limit:limit];
  return subviews;
} 

- (NSString *)yk_debugSubviews:(NSInteger)level {
  NSMutableString *debug = [NSMutableString string];
  [debug appendFormat:@"View: %@", self];
  for(UIView *subview in [self subviews]) {
    [debug appendFormat:@"\n --"];
    for(NSInteger i = 0; i < level; i++) [debug appendFormat:@" --"];
    [debug appendFormat:@" %@", [subview yk_debugSubviews:(level + 1)]];
  }
  return debug;  
}

- (NSString *)yk_debugSubviews {
  return [self yk_debugSubviews:0];
}

+ (void)yk_redrawSubviewsForView:(UIView *)view {
  [view setNeedsDisplay];
  for (UIView *subview in view.subviews) {
    [self yk_redrawSubviewsForView:subview];
  }
}

- (void)yk_redrawSubviews {
  [UIView yk_redrawSubviewsForView:self];
}

#pragma mark -

//
// From Three20 UIViewAdditions
//

- (CGFloat)yk_left {
  return self.frame.origin.x;
}

- (void)setYk_left:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)yk_top {
  return self.frame.origin.y;
}

- (void)setYk_top:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (CGFloat)yk_right {
  return self.frame.origin.x + self.frame.size.width;
}

- (void)setYk_right:(CGFloat)right {
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}

- (CGFloat)yk_bottom {
  return self.frame.origin.y + self.frame.size.height;
}

- (void)setYk_bottom:(CGFloat)bottom {
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}

- (CGFloat)yk_centerX {
  return self.center.x;
}

- (void)setYk_centerX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)yk_centerY {
  return self.center.y;
}

- (void)setYk_centerY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)yk_width {
  return self.frame.size.width;
}

- (void)setYk_width:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)yk_height {
  return self.frame.size.height;
}

- (void)setYk_height:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

- (CGFloat)yk_screenX {
  CGFloat x = 0;
  for (UIView *view = self; view; view = view.superview) {
    x += view.yk_left;
  }
  return x;
}

- (CGFloat)yk_screenY {
  CGFloat y = 0;
  for (UIView *view = self; view; view = view.superview) {
    y += view.yk_top;
  }
  return y;
}

- (CGFloat)yk_screenViewX {
  CGFloat x = 0;
  for (UIView *view = self; view; view = view.superview) {
    x += view.yk_left;
    
    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView *scrollView = (UIScrollView *)view;
      x -= scrollView.contentOffset.x;
    }
  }
  
  return x;
}

- (CGFloat)yk_screenViewY {
  CGFloat y = 0;
  for (UIView* view = self; view; view = view.superview) {
    y += view.yk_top;
    
    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView* scrollView = (UIScrollView*)view;
      y -= scrollView.contentOffset.y;
    }
  }
  return y;
}

- (CGRect)yk_screenFrame {
  return CGRectMake(self.yk_screenViewX, self.yk_screenViewY, self.yk_width, self.yk_height);
}

- (CGPoint)yk_offsetFromView:(UIView*)otherView {
  CGFloat x = 0, y = 0;
  for (UIView* view = self; view && view != otherView; view = view.superview) {
    x += view.yk_left;
    y += view.yk_top;
  }
  return CGPointMake(x, y);
}

- (UIScrollView *)yk_findFirstScrollView {
  if ([self isKindOfClass:[UIScrollView class]])
    return (UIScrollView *)self;
  
  for (UIView *child in self.subviews) {
    UIScrollView* it = [child yk_findFirstScrollView];
    if (it)
      return it;
  }
  
  return nil;
}

- (UIView *)yk_firstViewOfClass:(Class)cls {
  if ([self isKindOfClass:cls])
    return self;
  
  for (UIView *child in self.subviews) {
    UIView *it = [child yk_firstViewOfClass:cls];
    if (it)
      return it;
  }
  
  return nil;
}

- (UIView *)yk_firstParentOfClass:(Class)cls {
  if ([self isKindOfClass:cls]) {
    return self;
  } else if (self.superview) {
    return [self.superview yk_firstParentOfClass:cls];
  } else {
    return nil;
  }
}

- (UIView *)yk_findChildWithDescendant:(UIView*)descendant {
  for (UIView* view = descendant; view && view != self; view = view.superview) {
    if (view.superview == self) {
      return view;
    }
  }
  
  return nil;
}

- (void)yk_removeSubviews {
  while (self.subviews.count) {
    UIView* child = self.subviews.lastObject;
    [child removeFromSuperview];
  }
}

@end
