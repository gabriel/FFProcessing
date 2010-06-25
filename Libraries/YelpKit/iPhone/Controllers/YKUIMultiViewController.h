//
//  YKUIMultiViewController.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 12/24/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUIViewController.h"
#import "YKUINavigationController.h"


@interface YKUIMultiViewController : YKUIViewController {
  YKUINavigationController *_modeController;
}

- (void)setViewController:(YKUIViewController *)viewController animated:(BOOL)animated cache:(BOOL)cache;
- (YKUIViewController *)viewController;

@end
