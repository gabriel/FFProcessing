//
//  YKUIProgressView.m
//  YelpKit
//
//  Created by Gabriel Handford on 3/18/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIProgressView.h"
#import "YKCGUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "YKLocalized.h"

@interface YKUIProgressView ()
- (void)_loadView;
- (void)_setMode:(YKUIProgressViewMode)mode;
@end

@implementation YKUIProgressView

@synthesize contentFrame=_contentFrame, label=_label, contentInsets=_contentInsets, inProgress=_inProgress, progressTouchesEnabled=_progressTouchesEnabled;

- (id)initWithFrame:(CGRect)frame {
  return [self initWithFrame:frame contentFrame:CGRectNull];
}

- (id)initWithFrame:(CGRect)frame contentFrame:(CGRect)contentFrame {
  if ((self = [super initWithFrame:frame])) {
    _contentFrame = contentFrame;
    _contentInsets = UIEdgeInsetsZero;
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    [self _loadView];
    [self _setMode:YKUIProgressViewModeOverlay];
  }
  return self;
}

- (void)setContentFrame:(CGRect)contentFrame {
  _contentFrame = contentFrame;
  [self setNeedsLayout];
}

- (void)layoutSubviews {
  CGRect frame = self.frame;
    
  // Update for insets
  frame.size.width -= _contentInsets.left + _contentInsets.right;
  frame.size.height -= _contentInsets.top + _contentInsets.bottom;
  
  CGRect contentFrame;
  if (CGRectIsNull(_contentFrame)) {
    _contentView.frame = YKCGRectToCenterInRect(CGSizeMake(157, 49), frame);
    contentFrame = _contentView.frame;
  } else {
    _contentView.frame = _contentFrame;   
    contentFrame = _contentFrame;       
  } 
  
  contentFrame.origin.x += _contentInsets.left;
  contentFrame.origin.y += _contentInsets.top;
  
  CGSize labelSize = [_label sizeThatFits:contentFrame.size];
  CGFloat x = 0;
  CGFloat y = 0;
  
  CGFloat backgroundWidth = labelSize.width + 46;
  if (backgroundWidth < contentFrame.size.width) backgroundWidth = contentFrame.size.width;
  
  _backgroundView.frame = CGRectMake((contentFrame.size.width - backgroundWidth)/2.0, 0, backgroundWidth, contentFrame.size.height);
  
  if (_mode == YKUIProgressViewModeProgress) {
    x = roundf((contentFrame.size.width / 2.0) - (labelSize.width / 2.0));
    y = roundf((contentFrame.size.height / 2.0) - (labelSize.height / 2.0) - 9);
  } else {
    x = roundf((contentFrame.size.width / 2.0) - ((labelSize.width - 20) / 2.0));
    y = roundf((contentFrame.size.height / 2.0) - (labelSize.height / 2.0));
  }
  
  // Snap to pixels to avoid ugly antialiasing
  _label.frame = CGRectMake(x, y, labelSize.width, labelSize.height); 
  
  if (_mode == YKUIProgressViewModeProgress) {
    y += 20;  
    _progressView.frame = CGRectMake(4, y, frame.size.width - 8, frame.size.height);
  }
  
  y =  roundf(contentFrame.size.height / 2.0) - (20 / 2.0);
  _activityIndicator.frame = CGRectMake(x - 24, y, 20, 20);

}

- (void)_loadView {
  _contentView = [[UIView alloc] initWithFrame:CGRectZero];
  _contentView.backgroundColor = [UIColor clearColor];  
  
  _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
  _backgroundView.layer.cornerRadius = 10.0;
  [_contentView addSubview:_backgroundView];
  [_backgroundView release]; // Retained by superview
  
  _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  _activityIndicator.contentMode = UIViewContentModeCenter;
  [_contentView addSubview:_activityIndicator];
  [_activityIndicator release]; // Retained by superview
  
  _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
  _progressView.hidden = YES;
  [_contentView addSubview:_progressView];
  [_progressView release]; // Retained by superview
  
  _label = [[UILabel alloc] initWithFrame:CGRectZero];
  _label.textColor = [UIColor whiteColor];
  _label.text = YKLocalizedString(@"Loading...");
  _label.backgroundColor = [UIColor clearColor];
  _label.font = [UIFont boldSystemFontOfSize:18];
  _label.shadowColor = [UIColor blackColor];
  _label.shadowOffset = CGSizeMake(0, 1);
  [_contentView addSubview:_label]; // Retained by superview
  
  [self addSubview:_contentView];
  [_contentView release]; // Retained by superview
}

- (void)setInProgress:(BOOL)inProgress {
  switch(_mode) {
    case YKUIProgressViewModeOverlay:
      [self setOverlay:inProgress];
      break;
    case YKUIProgressViewModeActivity:
      [NSException raise:NSObjectNotAvailableException format:@"Use setActiveWithText:"];
      break;
    case YKUIProgressViewModeProgress:
      [NSException raise:NSObjectNotAvailableException format:@"Use setProgress:text:"];
      break;
  }
  _inProgress = inProgress;
}

- (void)setOverlay:(BOOL)inProgress {
  _inProgress = inProgress;
  if (inProgress) {
    [_activityIndicator startAnimating];
    self.hidden = NO;
    if (!_progressTouchesEnabled) self.touchDisabled = YES;
  } else {    
    [_activityIndicator stopAnimating];
    self.hidden = YES;
    self.touchDisabled = NO;
  }
}

- (void)setActiveWithText:(NSString *)text {
  _inProgress = YES;
  [self _setMode:YKUIProgressViewModeActivity];
  [_activityIndicator startAnimating];
  self.text = text; 
}

- (void)setProgress:(float)progress text:(NSString *)text {
  _inProgress = YES;
  [self _setMode:YKUIProgressViewModeProgress];
  self.text = text; 
  _progressView.progress = progress;
}

- (void)setText:(NSString *)text {
  _label.text = text;
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (NSString *)text {
  return _label.text;
}

- (void)_setMode:(YKUIProgressViewMode)mode {
  if (_mode == mode) return;

  _mode = mode;
  
  switch(_mode) {
    case YKUIProgressViewModeOverlay:     
      _progressView.hidden = YES;
      [_activityIndicator startAnimating];
      _activityIndicator.hidden = NO;
      _backgroundView.hidden = NO;  
      self.hidden = YES;
      break;
    case YKUIProgressViewModeProgress:
      self.hidden = NO;
      _progressView.hidden = NO;      
      [_activityIndicator stopAnimating];
      _activityIndicator.hidden = YES;
      _backgroundView.hidden = YES;
      break;
    case YKUIProgressViewModeActivity:
      self.hidden = NO;
      _progressView.hidden = YES;
      [_activityIndicator startAnimating];
      _activityIndicator.hidden = NO;
      _backgroundView.hidden = YES;
      break;
  }
  
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

@end


@implementation YPUIProgressTitleView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame contentFrame:frame])) {
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
  }
  return self;
}

@end