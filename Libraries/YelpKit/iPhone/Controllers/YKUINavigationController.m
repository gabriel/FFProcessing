//
//  YKUINavigationController.m
//  YelpIPhone
//
//  Created by Gabriel Handford on 7/15/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUINavigationController.h"

@implementation YKUINavigationController
 
@synthesize tag=_tag, primaryViewController=_primaryViewController, animationInProgress=_animationInProgress;

@dynamic delegate;

+ (id)navigationControllerWithRootViewController:(UIViewController *)viewController {
  return [[[self alloc] initWithRootViewController:viewController] autorelease];
}

- (void)dealloc {
  [_primaryViewController release];
  [super dealloc];
}

- (NSInteger)viewControllerCount {
  return [self.viewControllers count];
}

// Override
- (void)pushViewController:(YKUIViewController *)viewController animated:(BOOL)animated {
  if ([self.viewControllers containsObject:viewController]) {
    [self popToViewController:viewController animated:animated];
    return;
  }
  
  [super pushViewController:viewController animated:animated];
}

- (void)setViewController:(YKUIViewController *)viewController {
  self.viewControllers = [NSArray arrayWithObject:viewController];
}

+ (void)presentModalViewController:(YKUIViewController *)viewController closeTitle:(NSString *)closeTitle delegate:(id)delegate animated:(BOOL)animated {  
  YKUINavigationController *navigationController = [[YKUINavigationController alloc] initWithRootViewController:viewController];
  
  viewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:closeTitle style:UIBarButtonItemStylePlain 
                                                                                     target:viewController action:@selector(close)] autorelease];

  [viewController setCloseTarget:delegate closeAction:@selector(dismissModalViewController)];
  [delegate presentModalViewController:navigationController animated:animated];
  
  [navigationController release];
}

#pragma mark YKUINavigationController+PopView

- (void)yp_navigationControllerWillPopViewControllers:(NSArray */*of UIViewController*/)viewControllers animated:(BOOL)animated {
  [self.delegate navigationController:self willPopViewControllers:viewControllers animated:animated];
}

- (void)yp_navigationControllerDidPopViewControllers:(NSArray */*of UIViewController*/)viewControllers animated:(BOOL)animated { 
  [self.delegate navigationController:self didPopViewControllers:viewControllers animated:animated];
}

- (void)navigationAnimationWillStart:(NSString *)animationID context:(void *)context { 
  _animationInProgress = YES;
}

- (void)navigationAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context { 
  _animationInProgress = NO;
}
  
@end