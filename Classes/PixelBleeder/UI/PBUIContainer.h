//
//  PBUIContainer.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/14/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIStatusView.h"

@interface PBUIContainer : UIView {
  UIView *_headerView;
  UIView *_contentView;
  UIView *_footerView;
    
  PBUIStatusView *_statusView;
}

@property (readonly, nonatomic) PBUIStatusView *statusView;

- (void)setHeaderView:(UIView *)headerView;
- (void)setFooterView:(UIView *)footerView;
- (void)setContentView:(UIView *)contentView;

- (void)setStatusWithText:(NSString *)text progress:(float)progress;
- (void)setStatusProgress:(float)progress;
- (void)clearStatus;

@end
