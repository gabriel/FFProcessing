//
//  YKUIViewController.m
//  YelpIPhone
//
//  Created by Gabriel Handford on 5/28/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIViewController.h"

#import "GHNSObject+Invocation.h"

@interface YKUIViewController ()
// Private properties
@property (nonatomic, assign) BOOL animationInProgress;
- (BOOL)_loadViewWithProgress;
- (void)_performLoadViewWithProgress;
- (void)_enableLoadingWithMessage:(NSString *)message clear:(BOOL)clear;
@end


@implementation YKUIViewController

@synthesize visible=_visible, needsRefresh=_needsRefresh, navigationController=_navigationController, 
animationInProgress=_animationInProgress, navigationBarHidden=_navigationBarHidden,
refreshing=_refreshing, tag=_tag;

- (void)dealloc {
  [_navigationController release];
  [_containerView release];  
  [_contentViewController release];
  [super dealloc];
}

- (YKUIViewContainer *)containerView {
  if (!_containerView) {
    _containerView = [[YKUIViewContainer alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
  }
  return _containerView;
}  

- (void)loadView {
  self.view = self.containerView;
}

- (void)viewDidUnload {
  [_containerView release];
  _containerView = nil;
  [super viewDidUnload];
}

- (void)setContentView:(UIView *)view {
  self.view;
  self.containerView.contentView = view;
}

- (UIView *)contentView {
  self.view;
  return self.containerView.contentView;
}

- (void)setFooterView:(UIView *)footerView {
  [self.containerView setFooterView:footerView];
}

- (UIView *)footerView {
  return _containerView.footerView;
}

- (UINavigationController *)navigationController {
  return _navigationController ? _navigationController : [super navigationController];
}

- (YKUIStatusView *)statusView {
#ifdef YP_DEBUG
  NSAssert(_containerView, @"To use status view you must have setup a view; Use setContentView: instead of loadView");
#endif
  return self.containerView.statusView;
}

- (YKUIProgressView *)progressView {
#ifdef YP_DEBUG
  NSAssert(_containerView, @"To use status view you must have setup a view; Use setContentView: instead of loadView");
#endif  
  return self.containerView.progressView;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (_navigationBarHidden) [self.navigationController setNavigationBarHidden:YES animated:YES];
  [_contentViewController viewWillAppear:animated];  
  _becomingVisible = YES;
  
  if (![self _loadViewWithProgress]) {    
    [self refreshIfNeeded];
  } // Otherwise refreshIfNeeded will be called after loadViewWithProgress (via didLoadViewWithProgress)
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];  
  [_contentViewController viewDidAppear:animated];  
  _becomingVisible = NO;
  _visible = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [_contentViewController viewDidDisappear:animated];
}

- (void)scrollToTop:(BOOL)animated {
  if ([self.contentView isKindOfClass:[UIScrollView class]]) {
    [(UIScrollView *)self.contentView setContentOffset:CGPointMake(0, 0)];
  } else if ([self.contentView respondsToSelector:@selector(scrollToTop:)]) {
    [(id)self.contentView scrollToTop:animated];
  }
}

- (void)setContentViewController:(YKUIViewController *)contentViewController {
  self.view;
  contentViewController.view;

  // Clear content
  if (_contentViewController) {
    [_contentViewController viewWillDisappear:NO];
    [self setContentView:nil];  
    [_contentViewController viewDidDisappear:NO];
  }
  
  [contentViewController retain];
  [_contentViewController release];
  _contentViewController = contentViewController;
  
  // Set content from controller
  if (_contentViewController) {
    _contentViewController.navigationController = self.navigationController;
    [_contentViewController viewWillAppear:NO];
    [self setContentView:_contentViewController.view];  
    [_contentViewController viewDidAppear:NO];
  }
}

- (void)switchToView:(UIView *)view transition:(UIViewAnimationTransition)transition forView:(UIView *)forView cache:(BOOL)cache {
  view.frame = self.view.bounds;
  if (transition != UIViewAnimationTransitionNone) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(_animationDidStop:finished:context:)];
    [UIView setAnimationTransition:transition forView:forView cache:cache];
    self.animationInProgress = YES;
  }
  self.view = view;
  if (transition != UIViewAnimationTransitionNone) [UIView commitAnimations];
}

- (void)switchToView:(UIView *)view animated:(BOOL)animated forView:(UIView *)forView cache:(BOOL)cache {
  [self switchToView:view transition:(animated ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionNone) forView:forView cache:cache];
}

- (void)_animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
  self.animationInProgress = NO;
}

- (void)setBackButtonTitle:(NSString *)title {
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  [backButton release];
}

// Override in subclass
- (void)refresh { }

#pragma mark LoadViewWithProgress

- (BOOL)_loadViewWithProgress {
  if (_didLoadViewWithProgress) return NO;
  _didLoadViewWithProgress = YES;
  if ([self respondsToSelector:@selector(loadViewWithProgress)]) {
    [self _enableLoadingWithMessage:nil clear:NO];
    [[self gh_proxyAfterDelay:0] _performLoadViewWithProgress];
    return YES;
  }
  return NO;
}

- (void)_performLoadViewWithProgress {
  [self loadViewWithProgress];
  [self disableLoading];  
  [self didLoadViewWithProgress];
}

- (void)didLoadViewWithProgress {
  [self refreshIfNeeded];
}

#pragma mark Progress

- (void)setInProgress:(BOOL)inProgress text:(NSString *)text {
  self.view;
  self.progressView.text = text;
  [self setInProgress:inProgress];
}

- (void)setInProgress:(BOOL)inProgress {
  self.view;
  [self.view bringSubviewToFront:self.progressView];
  self.progressView.inProgress = inProgress;
}

- (BOOL)inProgress {
  return self.progressView.inProgress;
}

- (void)setProgressError:(NSError *)error {
  [self setProgressError:error refreshTarget:nil refreshAction:NULL cancelTarget:nil cancelAction:NULL];
}

- (void)setProgressError:(NSError *)error refreshTarget:(id)refreshTarget refreshAction:(SEL)refreshAction cancelTarget:(id)cancelTarget cancelAction:(SEL)cancelAction {
  [self setError:error refreshTarget:refreshTarget refreshAction:refreshAction cancelTarget:cancelTarget cancelAction:cancelAction];
}

- (void)setError:(NSError *)error refreshTarget:(id)refreshTarget refreshAction:(SEL)refreshAction cancelTarget:(id)cancelTarget cancelAction:(SEL)cancelAction {
  // TODO(gabe): Default impl show alert
}

#pragma mark Status

- (void)_setStatusViewHidden:(BOOL)hidden {
  self.statusView.hidden = hidden;
  [self.view bringSubviewToFront:self.statusView];
  [self.view setNeedsLayout]; // Note(gabe): This call needed otherwise status view may not be sized properly; Need to find underlying cause
}

- (void)enableLoading {  
  [self enableLoadingWithMessage:nil];
}

// Canonical form for all enableLoading methods; May be overriden by subclasses; Do not change signature
- (void)enableLoadingWithMessage:(NSString *)message {
  _enableLoadingCount = 0;
  self.view;
  [self.statusView setLoading:YES message:message];
  [self _setStatusViewHidden:NO];
}

- (void)_enableLoadingWithMessage:(NSString *)message clear:(BOOL)clear {  
  if (clear) _enableLoadingCount = 0;
  self.view;
  [self.statusView setLoading:YES message:message];
  [self _setStatusViewHidden:NO];
}

// May be overriden by subclasses; Do not change signature
- (BOOL)isLoading {
  if (!_containerView) return NO;
  return [self.statusView isLoading];
}

// May be overriden by subclasses; Do not change signature
- (void)disableLoading {
  _enableLoadingCount--;
  if (_enableLoadingCount < 0)
    _enableLoadingCount = 0;
  if (_enableLoadingCount == 0) {
    // TODO(johnb): Fix this to be less wierd
    if (_containerView) {
      [self.statusView setLoading:NO];
      [self _setStatusViewHidden:YES];
    }
  }
}

- (void)setMessage:(NSString *)message {
  [self setMessage:message title:nil target:nil action:NULL];  
}

// Canonical form for all setMessage methods; May be overriden by subclasses; Do not change signature
- (void)setMessage:(NSString *)message title:(NSString *)title target:(id)target action:(SEL)action {
  self.view;
  // Setting a message disables any loading
  _enableLoadingCount = 0;
  [self disableLoading];
  
  if (message) {  
    [self _setStatusViewHidden:NO];
    self.statusView.text = message;
    [self.statusView clearButtons];
    if (target)
      [self.statusView setButtonWithTitle:title target:target action:action];
  }
}

#pragma mark Refresh Handling

- (void)setNeedsRefresh {
  self.needsRefresh = YES;
}

- (void)refreshIfNeeded {
  if (self.needsRefresh) {
    [self refresh];
  }
}

- (void)refreshIfVisible {
  [self setNeedsRefresh];
  if (_visible || _becomingVisible) {
    [self scrollToTop:NO];
    [self refresh];
  }
}

#pragma mark Cancel/Close Helpers

- (void)close {
  [_closeTarget performSelector:_closeAction];
}

- (void)setCloseTarget:(id)closeTarget closeAction:(SEL)closeAction {
  _closeTarget = closeTarget;
  _closeAction = closeAction;
}

@end

@implementation UIViewController (YPEmptyTag)

- (NSInteger)tag { return 0; }

@end