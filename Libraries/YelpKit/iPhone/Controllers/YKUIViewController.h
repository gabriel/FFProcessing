//
//  YKUIViewController.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 5/28/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIViewContainer.h"

@interface YKUIViewController : UIViewController {
  
  BOOL _visible;
  BOOL _becomingVisible;
  BOOL _didLoadViewWithProgress; // YES if loadViewWithProgress was called
    
  NSInteger _enableLoadingCount; // Number of times enable loading was called; Handles nested enableLoading/disableLoading calls
  BOOL _needsRefresh;
  BOOL _animationInProgress;
  
  UINavigationController *_navigationController;

  YKUIViewContainer *_containerView;
  
  id _closeTarget; // weak
  SEL _closeAction;
  
  NSInteger _tag;
  
  YKUIViewController *_contentViewController; //! Experimental
  
  BOOL _navigationBarHidden; // Defaults to NO
  
  BOOL _refreshing;
}

@property (readonly, nonatomic, getter=isVisible) BOOL visible;
@property (readonly, nonatomic, assign, getter=isAnimationInProgress) BOOL animationInProgress;

@property (assign, nonatomic) BOOL needsRefresh;

@property (retain, nonatomic) UINavigationController *navigationController;

@property (assign, nonatomic) NSInteger tag;

@property (assign, nonatomic) BOOL navigationBarHidden;
@property (assign, nonatomic, getter=isRefreshing) BOOL refreshing;

- (YKUIStatusView *)statusView;
- (YKUIProgressView *)progressView;

- (void)setContentView:(UIView *)view;
- (UIView *)contentView;

- (YKUIViewContainer *)containerView;

- (void)setFooterView:(UIView *)footerView;
- (UIView *)footerView;

/*!
 Switch to view.
 @param view The view to set
 @param transition Type of transition to perform
 @param forView View to animate; generally a parent of view
 @param cache
 */
- (void)switchToView:(UIView *)view transition:(UIViewAnimationTransition)transition forView:(UIView *)forView cache:(BOOL)cache;
- (void)switchToView:(UIView *)view animated:(BOOL)animated forView:(UIView *)forView cache:(BOOL)cache;

/*!
 Scroll to top.
 @param animated
 */
- (void)scrollToTop:(BOOL)animated;

//! Experimental
- (void)setContentViewController:(YKUIViewController *)contentViewController;

- (void)setInProgress:(BOOL)inProgress text:(NSString *)text;

- (void)setInProgress:(BOOL)inProgress;

- (BOOL)inProgress;

//! Show error (from progess).
- (void)setProgressError:(NSError *)error refreshTarget:(id)refreshTarget refreshAction:(SEL)refreshAction cancelTarget:(id)cancelTarget cancelAction:(SEL)cancelAction;

//! Show error (from progess).
- (void)setProgressError:(NSError *)error;

/*!
 Show error.
 @param error
 @param refreshTarget
 @param refreshAction
 @param cancelTarget
 @param cancelAction
 */
- (void)setError:(NSError *)error refreshTarget:(id)refreshTarget refreshAction:(SEL)refreshAction cancelTarget:(id)cancelTarget 
    cancelAction:(SEL)cancelAction;

//! Set the back button on the next view (not this views back button)
- (void)setBackButtonTitle:(NSString *)title;

#pragma mark Status

/*!
 Show loading with secondary message.
 @param Secondary message, like "Finding your location..."
 */
- (void)enableLoadingWithMessage:(NSString *)message;

//! Disable loading
- (void)disableLoading;

//! Check if loading
- (BOOL)isLoading;

//! Shows a message with button, if target is set
- (void)setMessage:(NSString *)message title:(NSString *)title target:(id)target action:(SEL)action ;

//! Shows a message
- (void)setMessage:(NSString *)message;

//! Show loading
- (void)enableLoading;

#pragma mark Refresh Handling

/*!
 Set needs refresh. Does not trigger refresh even if visible.
 */
- (void)setNeedsRefresh;

/*!
 Refreshed only if needed.
 */
- (void)refreshIfNeeded;

/*!
 Will refresh if visible, otherwise set needs refresh.
 */
- (void)refreshIfVisible;

/*!
 Subclasses may implement and will be called on viewWillAppear: if refresh needed.
 */
- (void)refresh;

- (BOOL)isRefreshing;

#pragma mark -

- (void)close;

- (void)setCloseTarget:(id)closeTarget closeAction:(SEL)closeAction;

@end


/*!
 Subclasses can place heavier view operations in loadViewWithProgress: method which will be called once,
 after viewWillAppear:, and will show a loading progress view.
 */
@interface YKUIViewController (LoadViewWithProgress)
- (void)loadViewWithProgress;

/*!
 Called after loadViewWithProgress completes.
 */
- (void)didLoadViewWithProgress;

@end

@interface UIViewController (YPEmptyTag)

- (NSInteger)tag;

@end