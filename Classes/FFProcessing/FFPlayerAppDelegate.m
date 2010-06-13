//
//  FFProcessingAppDelegate.m
//  FFMP
//
//  Created by Gabriel Handford on 3/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayerAppDelegate.h"

#import "FFUtils.h"
#import "FFProcessing.h"
#import "FFGLDrawable.h"
#import "FFMPUtils.h"
#import "FFMPReadThread.h"

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
  
  FFMPInitialize();

  FFMPReadThread *readThread = [[FFMPReadThread alloc] initWithURL:[NSURL URLWithString:@"bundle://test.mp4"] formatName:nil];
  FFReader *reader = [[FFReader alloc] initWithReading:readThread];      
  FFGLDrawable *drawable = [[FFGLDrawable alloc] initWithReader:reader filter:nil];
  _playerView = [[FFPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  _playerView.drawable = drawable;
  [drawable release];
  [reader release];
  [readThread release];
  
  //@"bundle://pegasus-1958-chiptune.avi";  
  // @"http://c-cam.uchicago.edu/mjpg/video.mjpg";
  // @"mjpeg"; 
  
  [_playerView startAnimation];
  
  [_window addSubview:_playerView];  
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
