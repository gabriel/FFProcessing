//
//  YKUIProgressView.h
//  YelpKit
//
//  Created by Gabriel Handford on 3/18/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIView.h"

typedef enum {
  YKUIProgressViewModeOverlay = 1,
  YKUIProgressViewModeProgress = 2,
  YKUIProgressViewModeActivity = 3
} YKUIProgressViewMode;

@interface YKUIProgressView : YKUIView {

  // The content view allows us to expand a non-interactive region to block user interaction
  UIView *_contentView;
  CGRect _contentFrame;
  
  UILabel *_backgroundView;
  UIActivityIndicatorView *_activityIndicator;
  UIProgressView *_progressView;
  UILabel *_label;
  
  UIEdgeInsets _contentInsets;
  
  YKUIProgressViewMode _mode; // Defaults to YKUIProgressViewModeOverlay
  BOOL _inProgress;
  
  BOOL _progressTouchesEnabled; // Defaults to NO
}

@property (copy, nonatomic) NSString *text;

@property (readonly, nonatomic) UILabel *label;

@property (assign, nonatomic, getter=isInProgress) BOOL inProgress;

@property (assign, nonatomic) UIEdgeInsets contentInsets;

@property (assign, nonatomic, getter=isProgressTouchesEnabled) BOOL progressTouchesEnabled;

//! The frame of the progress view widget itself, inside this frame
@property (assign, nonatomic) CGRect contentFrame;

/*!
 Create progress view; Activity indicator with text to be visible above another view.
 @param frame
 @param contentFrame For overlay view the frame of the displayable area, if different from the frame.
    This is so we can show the progress overlay in a different position (than centered).
 */
- (id)initWithFrame:(CGRect)frame contentFrame:(CGRect)contentFrame;

/*!
 Show progress overlay.
 @param inProgress
 */
- (void)setOverlay:(BOOL)inProgress;

/*!
 Show progress view with text.
 @param progress Progress from 0.0 to 1.0
 @param text Label
 */
- (void)setProgress:(float)progress text:(NSString *)text;

/*!
 Show activity indicator with text.
 @param text Label
 */
- (void)setActiveWithText:(NSString *)text;

@end


@interface YPUIProgressTitleView : YKUIProgressView {

}

@end