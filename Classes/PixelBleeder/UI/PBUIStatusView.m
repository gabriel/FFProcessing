//
//  PBUIStatusView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/14/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIStatusView.h"


@implementation PBUIStatusView

@synthesize label=_label, progressView=_progressView, activityIndicator=_activityIndicator, button=_button;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor clearColor];  

    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    _backgroundView.layer.cornerRadius = 10.0;
    [_contentView addSubview:_backgroundView];
    [_backgroundView release];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.contentMode = UIViewContentModeCenter;
    _activityIndicator.hidesWhenStopped = YES;
    [_contentView addSubview:_activityIndicator];
    [_activityIndicator release];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    _progressView.hidden = YES;
    [_contentView addSubview:_progressView];
    [_progressView release];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.textColor = [UIColor whiteColor];
    _label.text = @"Processing...";
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont boldSystemFontOfSize:18];
    _label.shadowColor = [UIColor blackColor];
    _label.shadowOffset = CGSizeMake(0, 1);
    [_contentView addSubview:_label];    
    
    _button = [[YPUIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 37)];
    _button.hidden = YES;
    _button.titleColor = [UIColor whiteColor];     
    _button.titleFont = [UIFont boldSystemFontOfSize:16];
    _button.titleShadowColor = nil;    
    _button.color = [UIColor colorWithWhite:0 alpha:0.25];
    _button.shadingType = YPUIShadingTypeLinear;
    _button.cornerRadius = 10.0;
    _button.strokeWidth = 0.5; 
    
    [_contentView addSubview:_button];
    
    [self addSubview:_contentView];
    [_contentView release];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize size = self.frame.size;
  _contentView.frame = CGRectMake(0, 0, size.width, size.height);
  
  CGFloat minStatusWidth = size.width - 100;
  CGFloat maxStatusWidth = (size.width - 60);
  CGFloat indicatorWidth = 24;
  
  CGSize labelFitsSize = [_label sizeThatFits:size];
  CGSize topSize = labelFitsSize;
  if (!_activityIndicator.hidden) 
    topSize.width += indicatorWidth;
  
  if (topSize.width > maxStatusWidth) topSize.width = maxStatusWidth;
  if (topSize.width < minStatusWidth) topSize.width = minStatusWidth;
  
  CGFloat statusHeight = 56;
  if (!_button.hidden) statusHeight += 52;
  if (!_progressView.hidden) statusHeight += 24; 
  
  CGSize statusSize = CGSizeMake(topSize.width + 40, statusHeight);
  
  CGFloat x = roundf((size.width / 2.0) - (statusSize.width / 2.0));
  CGFloat y = roundf((size.height / 2.0) - (statusSize.height / 2.0));
  
  _backgroundView.frame = CGRectMake(x, y, statusSize.width, statusSize.height);
  
  x += roundf((statusSize.width / 2.0) - (topSize.width / 2.0));
  y += 18;
  
  CGFloat labelCenter = roundf((topSize.width / 2.0) - (labelFitsSize.width / 2.0));
  if (!_activityIndicator.hidden) {
    labelCenter -= indicatorWidth;
  }
  if (labelCenter < 0) labelCenter = 0;  
  
  CGRect labelFrame = CGRectMake(x + labelCenter, y, topSize.width - labelCenter, topSize.height);
  _activityIndicator.frame = CGRectMake(x + labelCenter, y, 20, 20);  
  if (!_activityIndicator.hidden) {
    labelFrame.origin.x += indicatorWidth;
    labelFrame.size.width -= indicatorWidth;
  }
  _label.frame = labelFrame;  
  y += 30;
  
  if (!_progressView.hidden) {
    _progressView.frame = CGRectMake(x, y, topSize.width, 22);  
    y += 24;
  }
  
  _button.frame = CGRectMake(x, y, topSize.width, 37);
  y += 57;
}

- (void)setButtonTitle:(NSString *)title target:(id)target action:(SEL)action {
  if (!title) {
    _button.hidden = YES;
  } else {
    _button.hidden = NO;
    _button.title = title;
    [_button setTarget:target action:action];
  }
  [self setNeedsLayout];
}

@end
