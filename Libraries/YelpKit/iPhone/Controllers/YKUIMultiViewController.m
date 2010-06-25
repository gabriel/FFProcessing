//
//  YPUIMultiViewController.m
//  YelpIPhone
//
//  Created by Gabriel Handford on 12/24/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIMultiViewController.h"
#import "YKUINavigationController+PopView.h"

@interface YKUIMultiViewController ()
- (YKUINavigationController *)_modeController;
@end

@implementation YKUIMultiViewController

- (void)dealloc {
  [_modeController release];
  [super dealloc];
}

- (void)loadView {
  [super loadView];
  [self setContentView:[self _modeController].view];
}

- (void)viewDidUnload {
  // TODO(gabe): Is this safe? I don't think so
  [_modeController release];
  _modeController = nil;
  [super viewDidUnload];
}

- (YKUINavigationController *)_modeController {
  if (!_modeController) {
    _modeController = [[YKUINavigationController alloc] init];
    _modeController.navigationBarHidden = YES;    
  }
  return _modeController;
}

- (void)setViewController:(YKUIViewController *)viewController animated:(BOOL)animated cache:(BOOL)cache {
  [[self _modeController] popPushViewController:viewController animated:animated cache:cache];
}

- (YKUIViewController *)viewController {
  return (YKUIViewController *)_modeController.topViewController;
}

- (BOOL)isAnimationInProgress {
  if (_modeController.isAnimationInProgress) return YES;
  return [super isAnimationInProgress];
}

// If you add a UINavigationController as a subview of a UIViewController subclass, you must explicitly call its viewWillAppear method from 
// its container; otherwise, they won’t be called. Forwarding these calls will fix this quirk.

- (void)viewWillAppear:(BOOL)animated { 
  [super viewWillAppear:animated];
  [_modeController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated { 
  [super viewWillDisappear:animated];
  [_modeController viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated { 
  [super viewDidAppear:animated];
  [_modeController viewDidAppear:animated];  
}

- (void)viewDidDisappear:(BOOL)animated { 
  [super viewDidDisappear:animated];
  [_modeController viewDidDisappear:animated];
}


@end
