//
//  YKUIViewContainer.m
//  YelpIPhone
//
//  Created by Gabriel Handford on 12/20/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIViewContainer.h"

@implementation YKUIViewContainer 

@synthesize contentView=_contentView, titleView=_titleView, titleViewContainer=_titleViewContainer, headerView=_headerView, 
titleViewOffset=_titleViewOffset, footerView=_footerView;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
  }
  return self;
}

- (void)dealloc {
  [_titleContainer release];
  [_titleView release];
  [_headerView release];
  [_titleContainer release];
  [_contentView release];
  [_statusView release];
  [_progressView release];
  [super dealloc];
}

- (void)layoutSubviews {
  CGFloat y = 0;
  CGSize size = self.frame.size;
  if (!_titleViewHidden && _titleContainer && _titleView) {
    _titleView.frame = CGRectMake(5, 0, size.width - 10, 44);

    _titleContainer.frame = CGRectMake(_titleViewOffset.x, _titleViewOffset.y, size.width, 44);
    CGFloat titleContainerHeight = _titleContainer.frame.origin.y + _titleContainer.frame.size.height;
    y += titleContainerHeight;
    size.height -= titleContainerHeight;    
  } else {
    _titleContainer.frame = CGRectMake(0, -44, 320, 44);
  } 
  [_titleView setNeedsLayout];
  
  if (_headerView) {    
    _headerView.frame = CGRectMake(0, y, _headerView.frame.size.width, _headerView.frame.size.height);
    y += _headerView.frame.size.height;
    size.height -= _headerView.frame.size.height;
    [_headerView setNeedsLayout];
  }
   
  if (_footerView) {    
    _footerView.frame = CGRectMake(0, self.frame.size.height - _footerView.frame.size.height, _footerView.frame.size.width, _footerView.frame.size.height);
    size.height -= _footerView.frame.size.height;
    [_footerView setNeedsLayout];
  }
  
  CGRect contentFrame = CGRectMake(0, y, size.width, size.height);

  // This prevents UIScrollViews from causing a layoutSubviews call after setFrame
  if (!YKCGRectIsEqual(contentFrame, _contentView.frame)) {
    _contentView.frame = contentFrame;
    [_contentView setNeedsLayout];
  }

  _statusView.frame = contentFrame;
  [_statusView setNeedsLayout];
  _progressView.frame = contentFrame;  
  [_progressView setNeedsLayout];
}

- (void)setTitleViewOffset:(CGPoint)offset {
  if (YKCGPointIsEqual(_titleViewOffset, offset)) return;
  _titleViewOffset = offset;
  [self setNeedsLayout];
}

- (void)setTitleViewHidden:(BOOL)titleViewHidden animated:(BOOL)animated {
  if (_titleViewHidden == titleViewHidden) return;
  _titleViewHidden = titleViewHidden;
  if (animated) {
    [UIView beginAnimations:NULL context:nil];
    [UIView setAnimationDuration:0.25];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [UIView commitAnimations];    
  } else {
    [self setNeedsDisplay];
    [self setNeedsLayout];
  }  
}

- (void)setTitleView:(UIView *)titleView titleContainer:(UIView *)titleContainer {
  [_titleView removeFromSuperview];
  [titleView removeFromSuperview]; // In case coming from another superview
  [titleView retain];
  [_titleView release];  
  _titleView = titleView;
  
  [titleContainer retain];
  [_titleContainer release];
  _titleContainer = titleContainer;
  
  if (_titleContainer && ![_titleContainer superview]) {
    [self addSubview:_titleContainer];  
    [_titleContainer addSubview:_titleView];
  } else {
    [self addSubview:_titleView];  
  }
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setHeaderView:(UIView *)headerView {
  [_headerView removeFromSuperview];
  [headerView retain];
  [_headerView release];  
  _headerView = headerView;
  [self addSubview:_headerView];
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setFooterView:(UIView *)footerView {
  [_footerView removeFromSuperview];
  [footerView retain];
  [_footerView release];  
  _footerView = footerView;
  [self addSubview:_footerView];
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setContentView:(UIView *)contentView {
  [_contentView removeFromSuperview];
  [contentView retain];
  [_contentView release];  
  _contentView = contentView;
  _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight |  UIViewAutoresizingFlexibleWidth;
  [self addSubview:_contentView];
  [self setNeedsLayout];
  [self setNeedsDisplay];
}  

- (YKUIStatusView *)statusView {
  if (!_statusView) {
    _statusView = [[YKUIStatusView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
    _statusView.hidden = YES;
    [self addSubview:_statusView];
  }
  return _statusView;
}

- (YKUIProgressView *)progressView {
  if (!_progressView) {
    // Progress fills entire view (to prevent user interaction)
    _progressView = [[YKUIProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
    [self addSubview:_progressView];
  }
  return _progressView;
}

@end
