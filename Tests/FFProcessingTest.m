//
//  FFProcessingTest.m
//  FFProcessing
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
  FFProcessing *processing = [[FFProcessing alloc] initWithProcessor:nil filter:nil];
  GHAssertTrue([processing processURL:URL format:nil index:0 count:1 error:nil], nil);  
  [processing release];  
}

- (void)testCameraVideo {
  NSURL *URL = [NSURL URLWithString:@"bundle://IMG_0306.MOV"];  
  FFProcessing *processing = [[FFProcessing alloc] initWithProcessor:nil filter:nil];
  GHAssertTrue([processing processURL:URL format:nil index:0 count:1 error:nil], nil);  
  [processing release];  
}

@end
