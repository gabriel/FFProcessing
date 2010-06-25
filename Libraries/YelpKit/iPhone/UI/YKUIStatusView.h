//
//  YKUIStatusView.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 12/9/08.
//  Copyright 2008. All rights reserved.
//

#import "YKUIAttributedTextView.h"
#import "YKUIButton.h"
#import "YKUIActivityLabel.h"

@interface YKUIStatusView : UIView {
  
  YKUIAttributedTextView *_label;
    
  UIView *_buttonsView;
  YKUIButton *_button;
  YKUIButton *_alternateButton;
  
  BOOL _isLoading;
  YKUIActivityLabel *_activityLabel;

  NSString *_text;  
  
  BOOL _autoSizable;
  CGSize _autoSize;
}

@property (retain, nonatomic) NSString *text; // Forwarded to UILabel
@property (assign, nonatomic, getter=isLoading) BOOL loading;

- (void)startAnimating;
- (void)stopAnimating;

- (void)clearButtons;
- (void)setButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setAlternateButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
  
- (void)setLoading:(BOOL)loading message:(NSString *)message;

@end