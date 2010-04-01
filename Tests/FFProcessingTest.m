//
//  FFProcessingTest.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/29/10.
//  Copyright 2010. All rights reserved.
//

#import "GHUnit.h"

#import "FFProcessing.h"
#import "FFUtils.h"

@interface FFProcessingTest : GHTestCase { }
@end

@implementation FFProcessingTest

- (void)test {
  //NSURL *URL = [NSURL URLWithString:@"bundle://test.mp4"]; 
  NSURL *URL = [NSURL URLWithString:@"bundle://pegasus-1958-chiptune.avi"];
  NSString *path = [[FFUtils documentsDirectory] stringByAppendingPathComponent:@"test-processing.mp4"];
  FFProcessing *processing = [[FFProcessing alloc] init];
  GHAssertTrue([processing openSourceURL:URL path:path format:nil error:nil], nil);
  
  [processing process:nil];
  
  [processing close];
  
  [processing release];  
}

- (void)testCameraVideo {
  NSURL *URL = [NSURL URLWithString:@"bundle://IMG_0306.MOV"];
  NSString *path = [[FFUtils documentsDirectory] stringByAppendingPathComponent:@"test-mov.mp4"];
  FFProcessing *processing = [[FFProcessing alloc] init];
  GHAssertTrue([processing openSourceURL:URL path:path format:nil error:nil], nil);
  
  [processing process:nil];
  
  [processing close];
  
  [processing release];  
}

@end
