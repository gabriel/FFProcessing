//
//  FFProcessingThread.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/15/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessingThread.h"
#import "FFUtils.h"

@implementation FFProcessingThread

@synthesize delegate=_delegate;

- (id)initWithDecoder:(id<FFDecoder>)decoder processor:(id<FFProcessor>)processor filter:(id<FFFilter>)filter items:(NSArray *)items {
  if ((self = [self init])) {
    _processingQueue = [(FFProcessingQueue *)[FFProcessingQueue alloc] initWithDecoder:decoder processor:processor filter:filter];
    _processingQueue.delegate = self;
    [_processingQueue addItems:items];
  }
  return self;
}

- (void)dealloc {
  [_processingQueue release];
  [super dealloc];
}

- (void)cancel {
  [super cancel];
  [_processingQueue cancel];
}

- (void)main {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  FFDebug(@"Starting processing thread");
  while ([_processingQueue hasNext]) {
    [_processingQueue processNext];
    FFDebug(@"Processed");
  }
  [_processingQueue close];
  
  FFDebug(@"Ending processing thread");
  [pool release];
}

#pragma mark FFProcessingQueueDelegate

- (void)processingQueue:(FFProcessingQueue *)processingQueue didStartIndex:(NSInteger)index count:(NSInteger)count {
  [[(id)_delegate gh_proxyOnMainThread] processingThread:self didStartIndex:index count:count];
}

- (void)processingQueue:(FFProcessingQueue *)processingQueue didReadFramePTS:(int64_t)framePTS duration:(int64_t)duration 
                  index:(NSInteger)index count:(NSInteger)count {
  [[(id)_delegate gh_proxyOnMainThread] processingThread:self didReadFramePTS:framePTS duration:duration index:index count:count];
}

- (void)processingQueue:(FFProcessingQueue *)processingQueue didFinishIndex:(NSInteger)index count:(NSInteger)count {
  [[(id)_delegate gh_proxyOnMainThread] processingThread:self didFinishIndex:index count:count];
}

- (void)processingQueue:(FFProcessingQueue *)processingQueue didError:(NSError *)error index:(NSInteger)index count:(NSInteger)count {
  [[(id)_delegate gh_proxyOnMainThread] processingThread:self didError:error index:index count:count];
}

- (void)processingQueueDidCancel:(FFProcessingQueue *)processingQueue {
  [[(id)_delegate gh_proxyOnMainThread] processingThreadDidCancel:self];
}

@end
