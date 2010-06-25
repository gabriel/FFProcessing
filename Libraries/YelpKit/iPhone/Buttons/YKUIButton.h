//
//  YKUIButton.h
//  YelpKit
//
//  Created by Gabriel Handford on 12/17/08.
//  Copyright 2008. All rights reserved.
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

#import "YKUIControl.h"
#import "YKCGUtils.h"

#define kButtonHeight 37

/*!
 Pre-canned button styles  
 */
typedef enum {
  YKUIButtonStyleBasic,
  YKUIButtonStyleBlue, //! Button with white text on blue linear shaded background
  YKUIButtonStyleDarkBlue, //! Button with white (etched) text on dark blue linear shaded background
  YKUIButtonStyleGray, //! Gray background with linear shaded background and etched text
  YKUIButtonStyleBlack,
  YKUIButtonStyleLink, //! Button with blue text on clear background
  YKUIButtonStyleBlackToolbar, //! Black translucent button with white text
  YKUIButtonStyleToggleBlue, //! Blueish toggle button
} YKUIButtonStyle;


/*!
 Custom button control.
 */
@interface YKUIButton : YKUIControl {

  NSString *_title;
  
  UIColor *_titleColor;
  UIFont *_titleFont;
  UITextAlignment _titleAlignment; // Defaults to center
  CGSize _titleSize;
  UIEdgeInsets _titleEdgeInsets;
  
  UIColor *_color;
  UIColor *_alternateColor;
  
  YPUIShadingType _shadingType;
  
  UIColor *_highlightedTitleColor;
  UIColor *_highlightedColor;
  UIColor *_highlightedAlternateColor;
  YPUIShadingType _highlightedShadingType;
  
  UIColor *_disabledTitleColor;
  UIColor *_disabledColor;
  UIColor *_disabledAlternateColor; 
  YPUIShadingType _disabledShadingType;
  
  UIColor *_selectedTitleColor;
  UIColor *_selectedColor;
  UIColor *_selectedAlternateColor;
  YPUIShadingType _selectedShadingType;  
  
  UIColor *_borderColor;
  
  YKUIBorderStyle _borderStyle; // Defaults to YKUIBorderStyleRounded
  
  CGFloat _strokeWidth;
  CGFloat _alternateStrokeWidth; // Defaults to 1; Used with borderStyle
  CGFloat _cornerRadius;
  
  UIColor *_titleShadowColor;
  CGPoint _titleShadowOffset;
  
  UIImageView *_imageView;
  UIImageView *_accessoryImageView;
  
  BOOL _titleHidden;
  
}

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) UIFont *titleFont;
@property (assign, nonatomic) UITextAlignment titleAlignment;

@property (retain, nonatomic) UIColor *titleColor;
@property (retain, nonatomic) UIColor *color;
@property (retain, nonatomic) UIColor *alternateColor;
@property (assign, nonatomic) YPUIShadingType shadingType;

@property (retain, nonatomic) UIColor *highlightedTitleColor;
@property (retain, nonatomic) UIColor *highlightedColor;
@property (retain, nonatomic) UIColor *highlightedAlternateColor;
@property (assign, nonatomic) YPUIShadingType highlightedShadingType;

@property (retain, nonatomic) UIColor *selectedTitleColor;
@property (retain, nonatomic) UIColor *selectedColor;
@property (retain, nonatomic) UIColor *selectedAlternateColor;
@property (assign, nonatomic) YPUIShadingType selectedShadingType;

@property (retain, nonatomic) UIColor *disabledTitleColor;
@property (retain, nonatomic) UIColor *disabledColor;
@property (retain, nonatomic) UIColor *disabledAlternateColor;
@property (assign, nonatomic) YPUIShadingType disabledShadingType;

@property (retain, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) YKUIBorderStyle borderStyle;

@property (assign, nonatomic) CGFloat strokeWidth;
@property (assign, nonatomic) CGFloat alternateStrokeWidth;
@property (assign, nonatomic) CGFloat cornerRadius;

@property (retain, nonatomic) UIColor *titleShadowColor;
@property (assign, nonatomic) CGPoint titleShadowOffset;

@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UIImageView *accessoryImageView;
@property (assign, nonatomic) UIEdgeInsets titleEdgeInsets;

@property (assign, nonatomic, getter=isTitleHidden) BOOL titleHidden;

/*!
 Create button.
 @param frame
 @param title
 @param target
 @param action
 */
- (id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

/*!
 Basic button with white background and blueish bold text
 */
+ (YKUIButton *)button;

/*!
 Button with style.
 @param frame Frame
 @param style Button style
 @param title Title
 */
+ (YKUIButton *)buttonWithFrame:(CGRect)frame style:(YKUIButtonStyle)style title:(NSString *)title;


/*!
 Set button to built-in style.
 */
- (void)setStyle:(YKUIButtonStyle)style;

@end

@interface YKUIButtonBackground : UIView { 
  UIColor *_color;
  UIColor *_alternateColor;
  CGFloat _strokeWidth;
  CGFloat _cornerRadius;
  UIColor *_borderColor;
  YPUIShadingType _shadingType;
}

@property (assign, nonatomic) YPUIShadingType shadingType;
@property (retain, nonatomic) UIColor *color;
@property (retain, nonatomic) UIColor *alternateColor;
@property (assign, nonatomic) CGFloat strokeWidth;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (retain, nonatomic) UIColor *borderColor;

@end
