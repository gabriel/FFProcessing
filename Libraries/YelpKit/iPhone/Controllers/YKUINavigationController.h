//
//  YKUINavigationController.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 7/15/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIViewController.h"

@class YKUINavigationController;

@protocol YKUINavigationControllerDelegate <UINavigationControllerDelegate>
- (void)navigationController:(YKUINavigationController *)navigationController didPopViewControllers:(NSArray */*of UIViewController*/)viewControllers animated:(BOOL)animated;
- (void)navigationController:(YKUINavigationController *)navigationController willPopViewControllers:(NSArray */*of UIViewController*/)viewControllers animated:(BOOL)animated;
@end

@interface YKUINavigationController : UINavigationController {
  NSInteger _tag;
  
  YKUIViewController *_primaryViewController;
  
  BOOL _animationInProgress;
}

@property (assign, nonatomic) NSInteger tag;
@property (assign, nonatomic) id<YKUINavigationControllerDelegate> delegate;
@property (readonly, nonatomic, getter=isAnimationInProgress) BOOL animationInProgress;

// If MoreViewController is involved, viewControllers may be empty, and rootViewController nil,
// even though we may still need access to the original root view controller
@property (retain, nonatomic) UIViewController *primaryViewController; 

+ (id)navigationControllerWithRootViewController:(UIViewController *)viewController;

- (NSInteger)viewControllerCount;

- (void)pushViewController:(YKUIViewController *)viewController animated:(BOOL)animated;

- (void)setViewController:(YKUIViewController *)viewController;

/*!
 Present modal controller for view controller with delegate.
 @param viewController
 @param closeTitle Title for close button
 @param delegate Should respond to 
  - (void)presentModalViewController:(UIViewController *)viewController animated:(BOOL)animated;
  - (void)dismissModalViewController;
 @param animated
 */
+ (void)presentModalViewController:(YKUIViewController *)viewController closeTitle:(NSString *)closeTitle delegate:(id)delegate animated:(BOOL)animated;

- (void)yp_navigationControllerWillPopViewControllers:(NSArray */*of UIViewController*/)viewControllers animated:(BOOL)animated;

- (void)yp_navigationControllerDidPopViewControllers:(NSArray */*of UIViewController*/)viewControllers animated:(BOOL)animated;

@end
