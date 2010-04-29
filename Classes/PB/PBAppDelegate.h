//
//  PBAppDelegate.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

#import "PBApplicationController.h"

@interface PBAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *_window;
  
  UINavigationController *_navigationController;
  PBApplicationController *_applicationController;
}

@end
