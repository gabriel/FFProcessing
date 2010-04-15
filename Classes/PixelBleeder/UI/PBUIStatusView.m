//
//  PBUIStatusView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/14/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIStatusView.h"


@implementation PBUIStatusView

@synthesize label=_label, progressView=_progressView, activityIndicator=_activityIndicator;

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
    _activityIndicator.hidden = YES;
    [_contentView addSubview:_activityIndicator];
    [_activityIndicator release];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
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
    
    [self addSubview:_contentView];
    [_contentView release];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize size = self.frame.size;
  
  CGFloat minStatusWidth = size.width - 100;
  CGFloat maxStatusWidth = (size.width - 60);
  CGFloat indicatorWidth = 24;
  
  CGSize topSize = [_label sizeThatFits:size];  
  if (!_activityIndicator.hidden) 
    topSize.width += indicatorWidth;
  
  if (topSize.width > maxStatusWidth) topSize.width = maxStatusWidth;
  if (topSize.width < minStatusWidth) topSize.width = minStatusWidth;
  
  CGSize statusSize = CGSizeMake(topSize.width + 40, 80);
  
  CGFloat x = roundf((size.width / 2.0) - (statusSize.width / 2.0));
  CGFloat y = roundf((size.height / 2.0) - (statusSize.height / 2.0));
  
  _backgroundView.frame = CGRectMake(x, y, statusSize.width, statusSize.height);
  
  x += roundf((statusSize.width / 2.0) - (topSize.width / 2.0));
  y += roundf((statusSize.height / 2.0) - (topSize.height / 2.0) - 9);
  
  CGRect labelFrame = CGRectMake(x, y, topSize.width, topSize.height);
  _activityIndicator.frame = CGRectMake(x, y, 20, 20);  
  if (!_activityIndicator.hidden) {
    labelFrame.origin.x += indicatorWidth;
    labelFrame.size.width -= indicatorWidth;
  }
  _label.frame = labelFrame;  
  y += 30;
  
  _progressView.frame = CGRectMake(x, y, topSize.width, 22);  
}
  


@end
