//
//  FFPlayerAppDelegate.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayerAppDelegate.h"

#import "FFCommon.h"
#import "FFProcessing.h"
#import "FFEncoder.h"

@interface FFPlayerAppDelegate ()
- (void)_loadPlayerView;
- (void)_encodeTest;
@end

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
  
  [self _encodeTest];

  /*!
  //NSURL *URL = [NSURL URLWithString:@"bundle://camping.m4v"]; 
  NSURL *URL = [NSURL URLWithString:@"bundle://pegasus-1958-chiptune.avi"];
  FFProcessing *processing = [[FFProcessing alloc] init];
  [processing decodeURL:URL format:nil];
  [processing release];
   */

  //[self _loadPlayerView];
}  

- (void)_loadPlayerView {
  _playerView = [[FFPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  
  _playerView.URLString = @"bundle://pegasus-1958-chiptune.avi";
  
  //_playerView.URLString = @"http://c-cam.uchicago.edu/mjpg/video.mjpg";
  //_playerView.format = @"mjpeg"; 
  
  [_playerView play];
  
  [_window addSubview:_playerView];  
}

- (void)_encodeTest {
  NSString *path = [[FFCommon documentsDirectory] stringByAppendingPathComponent:@"test.mpeg"];
  FFEncoder *encoder = [[FFEncoder alloc] init];
  NSError *error = nil;
  if ([encoder open:path error:&error]) {
    [encoder writeFrames:&error];
    [encoder close];
  }
}  

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
