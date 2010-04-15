//
//  PBUIStatusView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/14/10.
//  Copyright 2010. All rights reserved.
//

@interface PBUIStatusView : UIView {
  UIView *_contentView;
  UIView *_backgroundView;
  UIActivityIndicatorView *_activityIndicator;
  UIProgressView *_progressView;
  UILabel *_label;
}

@property (readonly, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (readonly, nonatomic) UIProgressView *progressView;
@property (readonly, nonatomic) UILabel *label;

@end
