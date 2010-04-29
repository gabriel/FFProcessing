//
//  FFProcessingAppDelegate.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayerAppDelegate.h"

#import "FFUtils.h"
#import "FFProcessing.h"
#import "FFEncoder.h"

@implementation FFPlayerAppDelegate

- (void)dealloc {
	[_window release];
  [_playerView release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application { 
  [UIApplication sharedApplication].statusBarHidden = YES;
  
  _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];  
  [_window makeKeyAndVisible];
  
  FFInitialize();

  _playerView = [[FFPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  
  _playerView.URLString = @"bundle://test.mp4"; //@"bundle://pegasus-1958-chiptune.avi";
  
  //_playerView.URLString = @"http://c-cam.uchicago.edu/mjpg/video.mjpg";
  //_playerView.format = @"mjpeg"; 
  
  [_playerView play];
  
  [_window addSubview:_playerView];  
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
