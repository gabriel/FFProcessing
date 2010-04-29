//
//  YPUIControl.m
//  YelpKit
//
//  Created by Gabriel Handford on 10/27/09.
//  Copyright 2009. All rights reserved.
//

#import "YPUIControl.h"

@implementation YPUIControl 

@synthesize target=_target, action=_action, highlightedEnabled=_highlightedEnabled, selectedEnabled=_selectedEnabled;

+ (void)removeAllTargets:(UIControl *)control {
  for (id target in [control allTargets]) {
    for (NSString *actionString in [control actionsForTarget:target forControlEvent:[control allControlEvents]]) {
      if (target == control) continue; // Skip self target so target/action still works
      [control removeTarget:target action:NSSelectorFromString(actionString) forControlEvents:[control allControlEvents]];
    }
  }
}

- (void)removeAllTargets {
  [YPUIControl removeAllTargets:self];
}

- (BOOL)touchesAllInView:(NSSet */*of UITouch*/)touches withEvent:(UIEvent *)event {
  // If any touch not in button, ignore
  for(UITouch *touch in touches) {
    CGPoint point = [touch locationInView:self];
    if (![self pointInside:point withEvent:event]) return NO;
  }
  return YES;
}

- (void)setTarget:(id)target action:(SEL)action {
  [self removeTarget:self action:@selector(_didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
  [self addTarget:self action:@selector(_didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
  _target = target;
  _action = action;
}

- (void)_didTouchUpInside {
  [_target performSelector:_action withObject:self];
  [self didTouchUpInside];
}

- (void)didTouchUpInside { }

#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {    
  if (_highlightedEnabled) {
    if (![self touchesAllInView:touches withEvent:event]) return; 
    self.highlighted = YES;
    [self setNeedsDisplay];
  } 
  [super touchesBegan:touches withEvent:event];
  if (_highlightedEnabled) {
    // Force runloop to redraw so highlighted control appears instantly; must come after call to super
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {  
  if (_selectedEnabled && [self touchesAllInView:touches withEvent:event]) {
    self.selected = !self.isSelected;
  }  
  
  [super touchesEnded:touches withEvent:event];
  
  if (_highlightedEnabled) {
    self.highlighted = NO;
    [self setNeedsDisplay];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {  
  [super touchesCancelled:touches withEvent:event];
  if (_highlightedEnabled) {
    self.highlighted = NO;
    [self setNeedsDisplay];
  }  
}

@end