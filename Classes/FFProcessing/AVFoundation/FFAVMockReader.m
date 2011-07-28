//
//  FFAVMockReader.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFAVMockReader.h"


@implementation FFAVMockReader

- (BOOL)start:(NSError **)error {
  return YES;
}

- (FFVFrameRef)nextFrame:(NSError **)error {
  return NULL;
}

- (void)close { }

@end
