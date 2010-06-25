//
//  YKUINavigationController+PopView.h
//  YelpKit
//
//  Created by Gabriel Handford on 4/27/09.
//  Copyright 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (YPPopView)

+ (void)patchDelegates;

- (void)yp_navigationControllerDidPopViewControllers:(NSArray */*of UIViewController*/)viewControllers animated:(BOOL)animated;

- (void)pushViewController:(UIViewController *)viewController transition:(UIViewAnimationTransition)transition cache:(BOOL)cache;
- (void)popViewControllerWithTransition:(UIViewAnimationTransition)transition cache:(BOOL)cache;
- (void)popPushViewController:(UIViewController *)viewController animated:(BOOL)animated cache:(BOOL)cache;
- (void)popPushViewController:(UIViewController *)viewController transition:(UIViewAnimationTransition)transition cache:(BOOL)cache;

- (void)navigationAnimationWillStart:(NSString *)animationID context:(void *)context;
- (void)navigationAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end

@interface UIViewController (YPPopView) 
- (void)yp_navigationControllerWillPush:(UINavigationController *)navigationController;
- (void)yp_navigationControllerDidPush:(UINavigationController *)navigationController;
- (void)yp_navigationControllerDidPop:(UINavigationController *)navigationController;
@end