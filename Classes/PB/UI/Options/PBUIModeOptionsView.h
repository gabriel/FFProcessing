//
//  PBUIModeOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/23/10.
//  Copyright 2010. All rights reserved.
//

#import "YKUIGridView.h"
#import "YKUIControl.h"

@interface PBUIModeOptionsView : YKUIGridView { }

- (void)addButtonWithTitle:(NSString *)title tag:(NSInteger)tag target:(id)target action:(SEL)action;

@end


@interface PBGridButton : YKUIControl { 
  UIFont *_font;
  CGFloat _minFontSize;
  UIColor *_textColor;
  UIColor *_selectedTextColor;
  UIColor *_shadowColor;
  UIColor *_selectedShadowColor;
  CGFloat _shadowBlur;
  CGFloat _selectedShadowBlur;
  NSString *_text;
}

@property (retain, nonatomic) NSString *text;

@end