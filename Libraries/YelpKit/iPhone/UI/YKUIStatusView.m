//
//  YKUIStatusView.m
//  YelpIPhone
//
//  Created by Gabriel Handford on 12/9/08.
//  Copyright 2008. All rights reserved.
//

#import "YKUIStatusView.h"

#import "YKLookAndFeel.h"
#import "YKCGUtils.h"
#import "YKUIView+Utils.h"

@implementation YKUIStatusView

- (id)init {
  return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _autoSizable = (self.frame.size.height == 0);
    
    self.backgroundColor = [UIColor whiteColor];
    
    _label = [[YKUIAttributedTextView alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
    _label.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    _label.textAlignment = UITextAlignmentCenter;
    _label.opaque = YES;
    [self addSubview:_label];
    [_label release];   
    
    _activityLabel = [[YKUIActivityLabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_activityLabel];
    [_activityLabel release];
    _activityLabel.hidden = YES;
    
    _buttonsView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_buttonsView];
    [_buttonsView release];   
  }
  return self;
}

- (void)dealloc {
  [_button release];
  [_alternateButton release];
  [_text release];
  [super dealloc];
}

- (void)layoutSubviews {    
  CGSize size = self.frame.size;
  CGSize contentSize = size;
  
  if ([[_buttonsView subviews] count] > 0) contentSize.height -= 50;
  
  _activityLabel.frame = CGRectMake(10, 0, size.width - 20, size.height);
  [_activityLabel setNeedsLayout];

  // Size to fit doesn't use width, so calculate manually

  // TODO(gabe): Only using to calculate size
  CGSize labelSize = _label.frame.size;
  if (_text) {
    labelSize = [_label sizeThatFits:labelSize];
  }
    
  _label.frame = YKCGRectToCenter(labelSize, contentSize);
  
  CGFloat y = size.height - 50; // Snap to bottom 
  _buttonsView.frame = CGRectMake(0, y, size.width, 50);
}

- (void)resetText {
  _buttonsView.hidden = NO;
  [_label setText:_text font:[UIFont systemFontOfSize:16.0] width:300 contentEdgeInsets:UIEdgeInsetsZero maxLineCount:-1];
  _activityLabel.detailLabel.text = @"";
  [self stopAnimating];
  [self setNeedsLayout];
}

- (void)startAnimating {
  _label.hidden = YES;
  _activityLabel.hidden = NO;
  [_activityLabel startAnimating];
  [self setNeedsLayout];
}

- (void)stopAnimating { 
  [_activityLabel stopAnimating]; 
  _activityLabel.hidden = YES;
  _label.hidden = NO;
  [self setNeedsLayout];
}

- (void)setLoading:(BOOL)loading {
  [self setLoading:loading message:nil];
}

- (void)setLoading:(BOOL)loading message:(NSString *)message {
  _isLoading = loading;
  if (loading) {
    _buttonsView.hidden = YES;    
    _activityLabel.detailLabel.text = message;
    [self startAnimating];
  } else {
    [self resetText];
  }
  [self setNeedsLayout];
}

- (BOOL)isLoading {
  return _isLoading;
}

- (void)setText:(NSString *)text {
  [text retain];
  [_text release];
  _text = text;
  [self resetText];
  _buttonsView.hidden = NO;
  [self setNeedsLayout];
}

- (NSString *)text {
  return _text;
}

- (void)clearButtons {
  [_buttonsView yk_removeAllSubviews];
}

- (void)setButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
  [self clearButtons];
  if (title && target) {
    [_button release];
    _button = [[[YKLookAndFeel sharedLookAndFeel] basicButtonWithFrame:CGRectMake(10, 0, 300, kButtonHeight) title:title target:target action:action] retain];
    [_buttonsView addSubview:_button];
  }
}

- (void)setAlternateButtonWithTitle:(NSString *)alternateTitle target:(id)target action:(SEL)action {
  [self clearButtons];
  if (_button) {
    [_button autorelease];
    _button = [[[YKLookAndFeel sharedLookAndFeel] basicButtonWithFrame:CGRectMake(10, 0, 145, kButtonHeight) title:_button.title target:_button.target action:_button.action] retain];
    [_buttonsView addSubview:_button];
  }
  
  [_alternateButton release];
  _alternateButton = nil;
  if (alternateTitle && target) {
    _alternateButton = [[[YKLookAndFeel sharedLookAndFeel] basicButtonWithFrame:CGRectMake(165, 0, 145, kButtonHeight) title:alternateTitle target:target action:action] retain];
    [_buttonsView addSubview:_alternateButton];
  }
}

@end
