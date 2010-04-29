//
//  PBAppDelegate.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

#import "PBAppDelegate.h"

@implementation PBAppDelegate

- (void)dealloc {
	[_window release];
  [_navigationController release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application { 
  //[UIApplication sharedApplication].statusBarHidden = YES;
  
  _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];  
  
  _navigationController = [[UINavigationController alloc] init];
  _navigationController.navigationBar.tintColor = [UIColor blackColor];
  [_window addSubview:_navigationController.view];
  
  _applicationController = [[PBApplicationController alloc] init];
  [_navigationController pushViewController:_applicationController animated:NO];
    
  [_window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

@end
