//
//  YKUINavigationController+PopView.m
//  YelpKit
//
//  Created by Gabriel Handford on 4/27/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUINavigationController+PopView.h"
#import "GHNSObject+Swizzle.h"
#import "GHNSObject+Invocation.h"

@implementation UINavigationController (YPPopView)

- (NSArray *)yp_popToRootViewControllerAnimated:(BOOL)animated {  
  NSArray *didPopViewControllers = [self yp_popToRootViewControllerAnimated:animated];
  for (UIViewController *didPopViewController in didPopViewControllers) {
    if ([didPopViewController respondsToSelector:@selector(yp_navigationControllerDidPop:)]) {
      [didPopViewController yp_navigationControllerDidPop:self];
    }
  }
  [self yp_navigationControllerDidPopViewControllers:didPopViewControllers animated:animated];
    
  return didPopViewControllers;
}

- (NSArray *)yp_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
  
  NSArray *didPopViewControllers = [self yp_popToViewController:viewController animated:animated];
  for (UIViewController *didPopViewController in didPopViewControllers) {
    if ([didPopViewController respondsToSelector:@selector(yp_navigationControllerDidPop:)]) {
      [didPopViewController yp_navigationControllerDidPop:self];
    }   
  }
  [self yp_navigationControllerDidPopViewControllers:didPopViewControllers animated:animated];
  return didPopViewControllers;
}

- (UIViewController *)yp_popViewControllerAnimated:(BOOL)animated {
  UIViewController *didPopViewController = [self yp_popViewControllerAnimated:animated];
  if ([didPopViewController respondsToSelector:@selector(yp_navigationControllerDidPop:)]) {
    [didPopViewController yp_navigationControllerDidPop:self];    
  }
  if (didPopViewController) 
    [self yp_navigationControllerDidPopViewControllers:[NSArray arrayWithObject:didPopViewController] animated:animated];
  
  return didPopViewController;
}

- (void)yp_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  [viewController gh_performIfRespondsToSelector:@selector(yp_navigationControllerWillPush:) withObjects:self, nil];
  [self yp_pushViewController:viewController animated:animated];
  [viewController gh_performIfRespondsToSelector:@selector(yp_navigationControllerDidPush:) withObjects:self, nil];
}

- (void)yp_navigationControllerDidPopViewControllers:(NSArray */*of UIViewController*/)viewControllers animated:(BOOL)animated {
  // Subclasses may override
}

+ (void)patchDelegates {
  [UINavigationController gh_swizzleMethod:@selector(popToRootViewControllerAnimated:) withMethod:@selector(yp_popToRootViewControllerAnimated:)];
  [UINavigationController gh_swizzleMethod:@selector(popToViewController:animated:) withMethod:@selector(yp_popToViewController:animated:)];
  [UINavigationController gh_swizzleMethod:@selector(popViewControllerAnimated:) withMethod:@selector(yp_popViewControllerAnimated:)];  
  [UINavigationController gh_swizzleMethod:@selector(pushViewController:animated:) withMethod:@selector(yp_pushViewController:animated:)];  
}

#pragma mark -

- (void)pushViewController:(UIViewController *)viewController transition:(UIViewAnimationTransition)transition cache:(BOOL)cache {
  if (transition != UIViewAnimationTransitionNone) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];    
    [UIView setAnimationTransition:transition forView:self.view cache:cache];
  }
  [self pushViewController:viewController animated:NO];  
  if (transition != UIViewAnimationTransitionNone) {
    [UIView commitAnimations];
  }
}

- (void)popViewControllerWithTransition:(UIViewAnimationTransition)transition cache:(BOOL)cache {
  if (transition != UIViewAnimationTransitionNone) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];    
    [UIView setAnimationTransition:transition forView:self.view cache:cache];
  }
  [self popViewControllerAnimated:NO];  
  if (transition != UIViewAnimationTransitionNone) {
    [UIView commitAnimations];
  }
}

- (void)popPushViewController:(UIViewController *)viewController animated:(BOOL)animated cache:(BOOL)cache {
  [self popPushViewController:viewController transition:(animated ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionNone) cache:cache];
}

- (void)popPushViewController:(UIViewController *)viewController transition:(UIViewAnimationTransition)transition cache:(BOOL)cache {
  if (transition != UIViewAnimationTransitionNone) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(navigationAnimationWillStart:context:)];
    [UIView setAnimationDidStopSelector:@selector(navigationAnimationDidStop:finished:context:)];
    [UIView setAnimationTransition:transition forView:self.view cache:cache];
  }
  
  [self popViewControllerAnimated:NO];
  [self pushViewController:viewController animated:NO];
  
  if (transition != UIViewAnimationTransitionNone) [UIView commitAnimations];
}

- (void)navigationAnimationWillStart:(NSString *)animationID context:(void *)context { }

- (void)navigationAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context { }

@end
