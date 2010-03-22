//
//  FFPlayerAppDelegate.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayerAppDelegate.h"

#import "FFGLDrawable.h"

@implementation FFPlayerAppDelegate

- (void)dealloc {
	[_window release];
  [_playerView release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application { 
  [UIApplication sharedApplication].statusBarHidden = YES;
  
  _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  _playerView = [[FFPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  
  _playerView.URLString = @"bundle://pegasus-1958-chiptune.avi";
  
  //_playerView.URLString = @"http://c-cam.uchicago.edu/mjpg/video.mjpg";
  //_playerView.format = @"mjpeg"; 
  
  [_playerView play];
  
  [_window addSubview:_playerView];
  [_window makeKeyAndVisible];
}  

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
