//
//  PBUIContainer.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/14/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIContainer.h"


@implementation PBUIContainer

- (void)layoutSubviews {
  [super layoutSubviews];

  CGSize contentSize = self.frame.size;  
  contentSize.height -= _footerView.frame.size.height;
  contentSize.height -= _headerView.frame.size.height;
  
  CGFloat y = 0;
  
  _headerView.frame = CGRectMake(0, 0, contentSize.width, _headerView.frame.size.height);  
  y += _headerView.frame.size.height;
  
  _contentView.frame = CGRectMake(0, y, contentSize.width, contentSize.height);
  _statusView.frame = _contentView.frame;
  y += contentSize.height;
  
  _footerView.frame = CGRectMake(0, y, contentSize.width, _footerView.frame.size.height);
}

- (void)setHeaderView:(UIView *)headerView {
  [headerView retain];
  [_headerView removeFromSuperview];
  [_headerView release];
  _headerView = headerView;
  [self addSubview:_headerView];
  [self setNeedsLayout];
}

- (void)setFooterView:(UIView *)footerView {
  [footerView retain];
  [_footerView removeFromSuperview];
  [_footerView release];
  _footerView = footerView;
  [self addSubview:_footerView];
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setContentView:(UIView *)contentView {
  [contentView retain];
  [_contentView removeFromSuperview];
  [_contentView release];
  _contentView = contentView;
  [self addSubview:_contentView];
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setStatusWithText:(NSString *)text progress:(float)progress {
  if (!_statusView) _statusView = [[PBUIStatusView alloc] init];
  //[_statusView.activityIndicator startAnimating];
  _statusView.label.text = text;
  _statusView.progressView.progress = progress;
  if (![_statusView superview]) {
    [self addSubview:_statusView];
    [self setNeedsLayout];
    [self setNeedsDisplay];
  }
}

- (void)clearStatus {
  [_statusView removeFromSuperview];
}

@end