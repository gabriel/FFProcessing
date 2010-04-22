//
//  YPUIButton.m
//  YelpKit
//
//  Created by Gabriel Handford on 12/17/08.
//  Copyright 2008 Yelp. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "YPUIButton.h"


@implementation YPUIButton

@synthesize title=_title, titleColor=_titleColor, titleFont=_titleFont, strokeWidth=_strokeWidth, alternateStrokeWidth=_alternateStrokeWidth,
cornerRadius=_cornerRadius, color=_color, alternateColor=_alternateColor, 
highlightedTitleColor=_highlightedTitleColor, highlightedColor=_highlightedColor, highlightedAlternateColor=_highlightedAlternateColor, highlightedShadingType=_highlightedShadingType,
disabledTitleColor=_disabledTitleColor, disabledColor=_disabledColor, disabledAlternateColor=_disabledAlternateColor, disabledShadingType=_disabledShadingType,
shadingType=_shadingType, borderColor=_borderColor, borderStyle=_borderStyle, titleShadowColor=_titleShadowColor, imageView=_imageView, accessoryImageView=_accessoryImageView, titleAlignment=_titleAlignment, titleHidden=_titleHidden, 
titleEdgeInsets=_titleEdgeInsets, titleShadowOffset=_titleShadowOffset, selectedTitleColor=_selectedTitleColor, selectedColor=_selectedColor, selectedAlternateColor=_selectedAlternateColor, 
selectedShadingType=_selectedShadingType;  


- (id)init {
  return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.titleAlignment = UITextAlignmentCenter;
    
    self.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    self.cornerRadius = 10.0;
    self.strokeWidth = 0.5;
    self.alternateStrokeWidth = 1.0;
    _titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
    
    self.borderColor = [UIColor blackColor];
    self.borderStyle = YPUIBorderStyleRounded;
    self.shadingType = YPUIShadingTypeNone;
    _titleShadowOffset = CGPointMake(1, 0);

    [self setStyle:YPUIButtonStyleBasic];
        
    // Highlighted: White text on gray linear shading
    self.highlightedTitleColor = [UIColor whiteColor];
    self.highlightedShadingType = YPUIShadingTypeLinear;
    self.highlightedColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    self.highlightedAlternateColor = [UIColor colorWithRed:0.675 green:0.675 blue:0.675 alpha:1.0];
    
    // Disabled: Gray text on gray linear shading
    self.disabledTitleColor = [UIColor grayColor];
    self.disabledShadingType = YPUIShadingTypeLinear;
    self.disabledColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    self.disabledAlternateColor = [UIColor colorWithRed:0.675 green:0.675 blue:0.675 alpha:1.0];
    
    self.highlightedEnabled = YES;
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
  if ((self = [self initWithFrame:frame])) {    
    self.title = title;   
    [self setTarget:target action:action];
  }
  return self;
}

- (void)dealloc {
  [_title release];
  [_titleFont release];
  [_titleColor release];
  [_color release];
  [_alternateColor release];
  [_highlightedTitleColor release];
  [_highlightedColor release];
  [_highlightedAlternateColor release];
  [_disabledAlternateColor release];
  [_disabledTitleColor release];
  [_disabledColor release];
  [_borderColor release]; 
  [_titleShadowColor release];
  [_imageView release];
  [_accessoryImageView release];
  [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted {
  for (UIView *view in [self subviews]) {
    if ([view respondsToSelector:@selector(setHighlighted:)]) {
      [(id)view setHighlighted:highlighted];
    }
  }
  [super setHighlighted:highlighted];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  _titleSize = YPCGSizeNull;
}

- (void)didChangeValueForKey:(NSString *)key {
  [super didChangeValueForKey:key];
  [self setNeedsDisplay];
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
  _titleEdgeInsets = titleEdgeInsets;
  _titleSize = YPCGSizeNull;
}

- (void)setTitleFont:(UIFont *)titleFont {
  [titleFont retain];
  [_titleFont release];
  _titleFont = titleFont;
  [self didChangeValueForKey:@"titleFont"];
  _titleSize = YPCGSizeNull;
}

- (UIFont *)titleFont {
  if (!_titleFont)
    return [UIFont boldSystemFontOfSize:14.0];
  return _titleFont;
}

- (void)setTitle:(NSString *)title {
  [title retain];
  [_title release];
  _title = title;
  [self didChangeValueForKey:@"title"];
  _titleSize = YPCGSizeNull;
}


+ (YPUIButton *)button {
  return [[[YPUIButton alloc] initWithFrame:CGRectZero] autorelease];
}

+ (YPUIButton *)buttonWithFrame:(CGRect)frame style:(YPUIButtonStyle)style title:(NSString *)title {
  YPUIButton *button = [[[YPUIButton alloc] initWithFrame:frame] autorelease];
  [button setStyle:style];
  button.title = title;
  return button;
}

- (void)setStyle:(YPUIButtonStyle)style {
  switch(style) {
    case YPUIButtonStyleBasic:
      self.titleColor = [UIColor colorWithRed:(77.0/255.0) green:(95.0/255.0) blue:(154.0/255.0) alpha:1];
      self.titleFont = nil;
      self.titleShadowColor = nil;
      self.color = [UIColor whiteColor];          
      self.alternateColor = nil;
      self.shadingType = YPUIShadingTypeNone;
      self.cornerRadius = 10.0;
      self.strokeWidth = 0.5;   
      break;
      
    case YPUIButtonStyleBlue:
      self.titleColor = [UIColor whiteColor];
      self.titleFont = nil;
      self.titleShadowColor = nil;
      self.color = [UIColor colorWithRed:0.247 green:0.514 blue:0.953 alpha:1.0];
      self.alternateColor = [UIColor colorWithRed:0.114 green:0.333 blue:0.871 alpha:1.0];
      self.shadingType = YPUIShadingTypeLinear;
      self.cornerRadius = 10.0;
      self.strokeWidth = 0.5;   
      break;
      
    case YPUIButtonStyleDarkBlue:           
      self.titleColor = [UIColor whiteColor];
      self.titleFont = nil;
      self.titleShadowColor = [UIColor blackColor];
      self.color = [UIColor colorWithRed:0.0 green:0.322 blue:0.8 alpha:1.0];
      self.alternateColor = [UIColor colorWithRed:0.0 green:0.059 blue:0.8 alpha:1.0];
      self.shadingType = YPUIShadingTypeLinear;
      self.cornerRadius = 6.0;
      self.strokeWidth = 0.5;
      break;

    case YPUIButtonStyleBlack:
      // Normal: White text on black horizontal edge shading
      self.titleColor = [UIColor whiteColor];     
      self.titleFont = nil;
      self.titleShadowColor = nil;
      self.color = [UIColor blackColor];
      self.alternateColor = [UIColor blackColor];   
      self.shadingType = YPUIShadingTypeHorizontalEdge;
      self.cornerRadius = 10.0;
      self.strokeWidth = 0.5; 
      break;
      
    case YPUIButtonStyleGray:
      self.titleColor = [UIColor blackColor];
      self.titleFont = nil;
      self.titleShadowColor = [UIColor whiteColor];
      self.color = [UIColor whiteColor];
      self.alternateColor = [UIColor lightGrayColor];
      self.shadingType = YPUIShadingTypeLinear;
      self.cornerRadius = 6.0;
      self.strokeWidth = 0.5;
      break;
      
    case YPUIButtonStyleLink:
      self.titleColor = [UIColor colorWithRed:(77.0/255.0) green:(95.0/255.0) blue:(154.0/255.0) alpha:1];
      self.titleFont = [UIFont systemFontOfSize:15.0];
      self.titleShadowColor = nil;
      self.color = nil;
      self.alternateColor = nil;
      self.shadingType = YPUIShadingTypeNone;
      self.cornerRadius = 10.0;
      self.strokeWidth = 0;
      break;
      
    case YPUIButtonStyleBlackToolbar:
      self.titleColor = [UIColor whiteColor];     
      self.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:13];
      self.titleShadowColor = nil;
      self.color = [UIColor colorWithWhite:0 alpha:0.5];
      self.alternateColor = [UIColor colorWithWhite:0 alpha:0.5];   
      self.shadingType = YPUIShadingTypeHorizontalEdge;
      self.cornerRadius = 6.0;
      self.strokeWidth = 0.5; 
      self.highlightedTitleColor = [UIColor colorWithWhite:0.8 alpha:1];
      self.highlightedShadingType = YPUIShadingTypeHorizontalEdge;
      self.highlightedColor = [UIColor colorWithWhite:0.2 alpha:0.6];
      self.highlightedAlternateColor = [UIColor colorWithWhite:0.2 alpha:0.6];
      self.disabledTitleColor = [UIColor colorWithWhite:0.9 alpha:0.6];
      self.disabledShadingType = self.shadingType;
      self.disabledColor = self.color;
      self.disabledAlternateColor = self.alternateColor;
      break;
      
    case YPUIButtonStyleToggleBlue:
      self.color = [UIColor colorWithRed:(120.0/255.0) green:(141.0/255.0) blue:(169.0/255.0) alpha:1.0];     
      self.cornerRadius = 10.0;
      self.strokeWidth = 0.5; 
      self.shadingType = YPUIShadingTypeHorizontalEdge;
      
      self.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:14];
      self.titleColor = [UIColor whiteColor];
      self.titleShadowColor = [UIColor colorWithWhite:0 alpha:0.6];
      self.titleShadowOffset = CGPointMake(0, -1);      
      
      self.highlightedTitleColor = [UIColor whiteColor];     
      self.highlightedColor = [UIColor colorWithRed:0.29 green:0.42 blue:0.61 alpha:1.0];
      self.highlightedAlternateColor = nil;
      self.highlightedShadingType = YPUIShadingTypeHorizontalEdge;
      break;
  }
}

- (UIColor *)textColorForState:(UIControlState)state {
  
  BOOL isHighlighted = self.isHighlighted;
  BOOL isDisabled = !self.isEnabled;
  
  if (_highlightedTitleColor && isHighlighted) {
    return _highlightedTitleColor;
  } else if (_disabledTitleColor && isDisabled) {
    return _disabledTitleColor;
  } else if (_titleColor) {
    return _titleColor;
  } else {
    return [UIColor blackColor];
  }
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  if (YPCGSizeIsNull(_titleSize) && _title) {
    CGSize constrainedToSize = self.frame.size;
    constrainedToSize.width -= (_titleEdgeInsets.left + _titleEdgeInsets.right);
    _titleSize = [_title sizeWithFont:self.titleFont constrainedToSize:constrainedToSize lineBreakMode:UILineBreakModeTailTruncation];    
  }
  
  UIControlState state = self.state;
  CGRect bounds = self.bounds;
  CGSize size = bounds.size;
  
  BOOL isHighlighted = self.isHighlighted;
  BOOL isSelected = self.isSelected;
  BOOL isDisabled = !self.isEnabled;
  
  YPUIShadingType shadingType = _shadingType;
  UIColor *color = _color;
  UIColor *alternateColor = _alternateColor;
  
  if (isDisabled) {
    if (_disabledShadingType != YPUIShadingTypeNone) shadingType = _disabledShadingType;
    if (_disabledColor) color = _disabledColor;
    if (_disabledAlternateColor) alternateColor = _disabledAlternateColor;    
  } else if (isHighlighted) { //  || self.isTracking ; TODO(gabe): Check if we still need the tracking
    if (_highlightedShadingType != YPUIShadingTypeNone) shadingType = _highlightedShadingType;
    if (_highlightedColor) color = _highlightedColor;
    if (_highlightedAlternateColor) alternateColor = _highlightedAlternateColor;
  } else if (isSelected) {
    // Set from selected properties; Fall back to highlighted properties
    if (_selectedShadingType != YPUIShadingTypeNone) shadingType = _selectedShadingType;
    else if (_highlightedShadingType != YPUIShadingTypeNone) shadingType = _highlightedShadingType;
    if (_selectedColor) color = _selectedColor;
    else if (_highlightedColor) color = _highlightedColor;
    if (_selectedAlternateColor) alternateColor = _selectedAlternateColor;
    else if (_highlightedAlternateColor) alternateColor = _highlightedAlternateColor;
  }
  
  UIColor *fillColor = color;
  
  UIImage *icon = _imageView.image;
  if (isHighlighted && _imageView.highlightedImage) icon = _imageView.highlightedImage;
  
  UIImage *accessoryIcon = _accessoryImageView.image;
  if (isHighlighted && _accessoryImageView.highlightedImage) accessoryIcon = _accessoryImageView.highlightedImage;
  
  if (color && shadingType != YPUIShadingTypeNone) {
    YPContextAddStyledRect(context, bounds, _borderStyle, _strokeWidth, _alternateStrokeWidth, _cornerRadius);  
    CGContextClip(context);
    YPContextDrawShadingWithHeight(context, color.CGColor, alternateColor.CGColor, self.bounds.size.height, shadingType);
    fillColor = nil;
  }
  
  if (_strokeWidth > 0) {
    YPDrawBorder(context, bounds, _borderStyle, fillColor.CGColor, _borderColor.CGColor, _strokeWidth, _alternateStrokeWidth, _cornerRadius);
  }
  
  UIColor *textColor = [self textColorForState:state];
  
  UIFont *font = self.titleFont;
  
  CGFloat y = roundf(YPPointToCenter(_titleSize, size).y);
  
  BOOL showIcon = (icon != nil && !_imageView.hidden);
  if (!_titleHidden) {
    CGFloat lineWidth = _titleSize.width;
    if (showIcon) lineWidth += icon.size.width + 2;
    CGFloat x = _titleEdgeInsets.left;
    
    if (_titleAlignment == UITextAlignmentCenter) x = roundf(size.width/2.0 - lineWidth/2.0);
    if (x < 0) x = 0;
    
    if (showIcon) {
      [icon drawAtPoint:CGPointMake(x, y)];
      x += icon.size.width + 2;
      showIcon = NO;
    }
    
    y += _titleEdgeInsets.top;
    
    if (_titleShadowColor && !isHighlighted && !isDisabled) {
      [_titleShadowColor setFill];
      [_title drawInRect:CGRectMake(x + _titleShadowOffset.x, y + _titleShadowOffset.y, _titleSize.width, _titleSize.height) withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:_titleAlignment];
    }
    
    [textColor setFill];
    [_title drawInRect:CGRectMake(x, y, _titleSize.width, _titleSize.height) withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:_titleAlignment];
  }
  
  if (accessoryIcon)
    [accessoryIcon drawAtPoint:YPPointToRight(accessoryIcon.size, CGSizeMake(size.width - 10, size.height))];
  
  if (showIcon) {
    [icon drawAtPoint:YPPointToCenter(icon.size, size)];
  }  
}

@end


@implementation YPUIButtonBackground

@synthesize color=_color, alternateColor=_alternateColor, strokeWidth=_strokeWidth, cornerRadius=_cornerRadius, shadingType=_shadingType, borderColor=_borderColor;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    // Default to gray shading background (For use as selected background view)
    self.color = [[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.0] retain];
    self.alternateColor = [[UIColor colorWithRed:0.675 green:0.675 blue:0.675 alpha:1.0] retain];
    self.borderColor = [UIColor blackColor];
    self.cornerRadius = 10.0;
    self.strokeWidth = 0.5;   
    self.shadingType = YPUIShadingTypeLinear;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)dealloc {
  [_color release];
  [_alternateColor release];
  [super dealloc];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext(); 
  CGRect bounds = self.bounds;
  CGSize size = bounds.size;
  YPContextAddRoundedRect(context, bounds, _strokeWidth, _cornerRadius);
  CGContextClip(context);
  YPContextDrawShadingWithHeight(context, _color.CGColor, _alternateColor.CGColor, size.height, _shadingType);
  YPContextDrawRoundedRect(context, bounds, NULL, [_borderColor CGColor], _strokeWidth, _cornerRadius);
} 

@end
