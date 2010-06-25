//
//  YKUIViewContainer.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 12/20/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIView.h"
#import "YKUIStatusView.h"
#import "YKUIProgressView.h"

@interface YKUIViewContainer : YKUIView { 
  UIView *_titleView;  
  UIView *_titleContainer;
  UIView *_headerView;
  UIView *_footerView;
  UIView *_contentView;
  
  BOOL _titleViewHidden;
  CGPoint _titleViewOffset;
  
  YKUIStatusView *_statusView;
  YKUIProgressView *_progressView;
}

@property (readonly, nonatomic) UIView *titleView;
@property (readonly, nonatomic) UIView *titleViewContainer;
@property (retain, nonatomic) UIView *headerView;
@property (retain, nonatomic) UIView *footerView;
@property (retain, nonatomic) UIView *contentView;

@property (assign, nonatomic) CGPoint titleViewOffset;

@property (readonly, nonatomic) YKUIStatusView *statusView;
@property (readonly, nonatomic) YKUIProgressView *progressView;

- (void)setTitleViewHidden:(BOOL)titleViewHidden animated:(BOOL)animated;

- (void)setTitleView:(UIView *)titleView titleContainer:(UIView *)titleContainer;

@end

