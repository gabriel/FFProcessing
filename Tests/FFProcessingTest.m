//
//  FFProcessingTest.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/29/10.
//  Copyright 2010. All rights reserved.
//

#import "GHUnit.h"

#import "FFProcessing.h"

@interface FFProcessingTest : GHTestCase { }
@end

@implementation FFProcessingTest

- (void)test {
  NSURL *URL = [NSURL URLWithString:@"bundle://camping.m4v"]; 
  //NSURL *URL = [NSURL URLWithString:@"bundle://pegasus-1958-chiptune.avi"];
  FFProcessing *processing = [[FFProcessing alloc] init];
  GHAssertTrue([processing openURL:URL format:nil error:nil], nil);
  
  [processing process:nil];
  
  [processing close];
  
  [processing release];  
}

@end
