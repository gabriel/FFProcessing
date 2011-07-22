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

- (void)addButtonWithTitle:(NSString *)title tag:(NSInteger)tag target:(id)target action:(SEL)action {
  PBGridButton *button = [[PBGridButton alloc] init];
  button.tag = tag;
  button.text = title;
  button.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
  [button setTarget:target action:action];
  [self addControl:button];
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

@implementation PBGridButton 

@synthesize text=_text;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _font = [[UIFont fontWithName:@"Helvetica" size:18.0f] retain];
    _minFontSize = 12.0f;
    _shadowColor = [[UIColor whiteColor] retain];
    _selectedShadowColor = [[UIColor whiteColor] retain];
    _textColor = [[UIColor whiteColor] retain];    
    _selectedTextColor = [[UIColor colorWithRed:0.6 green:0.9 blue:0.6 alpha:1.0] retain];
    _shadowBlur = 20.0;
    _selectedShadowBlur = 100.0;
    self.selectedEnabled = YES;
  }
  return self;
}

- (void)dealloc {
  [_font release];
  [_shadowColor release];
  [_selectedShadowColor release];
  [_text release];
  [_textColor release];
  [_selectedTextColor release];
  [super dealloc];
}

- (NSString *)description {
  return GHDescription(@"text");
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  UIColor *shadowColor = _shadowColor;
  CGFloat shadowBlur = _shadowBlur;
  UIColor *textColor = _textColor;
  
  if (self.isSelected) {
    shadowColor = _selectedShadowColor;
    shadowBlur = _selectedShadowBlur;
    textColor = _selectedTextColor;
  }
  CGContextSetShadowWithColor(context, CGSizeZero, shadowBlur, shadowColor.CGColor);   
  
  [textColor setFill];

  [_text gh_drawInRect:self.bounds font:_font minFontSize:_minFontSize actualFontSize:nil
      lineBreakMode:UILineBreakModeWordWrap alignment:(GHNSStringAlignmentVerticalCenter | GHNSStringAlignmentHorizontalCenter)];
}

@end
