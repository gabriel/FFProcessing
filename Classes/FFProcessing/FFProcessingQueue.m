//
//  FFProcessingQueue.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/15/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessingQueue.h"


@implementation FFProcessingQueue

@synthesize delegate=_delegate;

- (id)init {
  if ((self = [super init])) {
    _items = [[NSMutableArray alloc] init];
  }
  return self;
}

- (id)initWithDecoder:(id<FFDecoder>)decoder processor:(id<FFProcessor>)processor filter:(id<FFFilter>)filter {
  if ((self = [self init])) {
    _decoder = [decoder retain];
    _processor = [processor retain];    
    _filter = [filter retain];
  }
  return self;
}

- (void)dealloc {
  [self close];
  [_items release];
  [_decoder release];
  [_processor release];
  [_filter release];
  [_processing release];
  [super dealloc];
}

- (void)addItem:(FFProcessingItem *)item {
  [_items addObject:item];
}

- (void)addItems:(NSArray */*of FFProcessingItem*/)items {
  [_items addObjectsFromArray:items];
}

- (BOOL)hasNext {
  return (![_processing isCancelled] && _index < [_items count]);
}

- (void)close {
  _index = 0;
  [_processing release];
  _processing = nil;
}

- (void)cancel {
  [_processing cancel];
}

- (BOOL)processNext {  
  if (![self hasNext]) {
    return NO;
  }
  
  if (!_processing) {
    _processing = [(FFProcessing *)[FFProcessing alloc] initWithDecoder:_decoder processor:_processor filter:_filter];
    _processing.delegate = self;
  }

  FFProcessingItem *item = [_items objectAtIndex:_index];
  BOOL processed = [_processing processURL:item.URL format:item.format index:_index count:[_items count] error:nil];
  _index++;
  return processed;
}

#pragma mark FFProcessingDelegate

- (void)processing:(FFProcessing *)processing didStartIndex:(NSInteger)index count:(NSInteger)count {
  [_delegate processingQueue:self didStartIndex:index count:count];
}

- (void)processing:(FFProcessing *)processing didReadFramePTS:(int64_t)framePTS duration:(int64_t)duration 
             index:(NSInteger)index count:(NSInteger)count {
  [_delegate processingQueue:self didReadFramePTS:framePTS duration:duration index:index count:count];
}

- (void)processing:(FFProcessing *)processing didFinishIndex:(NSInteger)index count:(NSInteger)count {
  [_delegate processingQueue:self didFinishIndex:index count:count];
}

- (void)processing:(FFProcessing *)processing didError:(NSError *)error index:(NSInteger)index count:(NSInteger)count {
  [_delegate processingQueue:self didError:error index:index count:count];
}

- (void)processingDidCancel:(FFProcessing *)processing {
  [_delegate processingQueueDidCancel:self];
}

@end

@implementation FFProcessingItem

@synthesize URL=_URL, format=_format;

- (id)initWithURL:(NSURL *)URL format:(NSString *)format {
  if ((self = [self init])) {
    _URL = [URL retain];
    _format = [format retain];
  }
  return self;
}

- (void)dealloc {
  [_URL release];
  [_format release];
  [super dealloc];
}

@end
