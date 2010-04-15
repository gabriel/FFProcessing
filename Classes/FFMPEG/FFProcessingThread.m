//
//  FFProcessingThread.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/15/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessingThread.h"


@implementation FFProcessingThread

- (id)initWithProcessingQueue:(FFProcessingQueue *)processingQueue {
  if ((self = [self init])) {
    _processingQueue = [processingQueue retain];
  }
  return self;
}

- (void)dealloc {
  [_processingQueue release];
  [super dealloc];
}

- (void)main {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSError *error = nil;
  while ([_processingQueue hasNext]) {
    [_processingQueue processNext:&error];
  }
  
  [pool release];
}

@end
