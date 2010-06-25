//
//  PBUIModeOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/23/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIModeOptionsView.h"


@implementation PBUIModeOptionsView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [self initWithFrame:frame rowCount:2 columnCount:3])) {
    self.insets = UIEdgeInsetsMake(0, 0, 0, 0);    
  }
  return self;
}

- (void)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
  YKUIGridButton *button = [[YKUIGridButton alloc] initWithTitle:title image:nil highlightedImage:nil];
  button.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  button.label.textColor = [UIColor whiteColor];
  button.label.highlightedTextColor = [UIColor grayColor];
  button.label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
  [button setTarget:target action:action];
  [self addView:button];
  [button release];
}

/*!
- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  CGContextRef context = UIGraphicsGetCurrentContext();
  YKCGContextDrawBorder(context, self.bounds, YKUIBorderStyleTopOnly, NULL, [UIColor whiteColor].CGColor, 4.0, 0.0, 0.0);
}
 */

@end
