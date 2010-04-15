//
//  FFProcessingQueue.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/15/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessingQueue.h"


@implementation FFProcessingQueue

- (id)init {
  if ((self = [super init])) {
    _items = [[NSMutableArray alloc] init];
  }
  return self;
}

- (id)initWithProcessing:(FFProcessing *)processing {
  if ((self = [self init])) {
    _processing = [processing retain];    
  }
  return self;
}

- (void)dealloc {
  [_items release];
  [_processing release];
  [super dealloc];
}

- (void)addItem:(FFProcessingItem *)item {
  [_items addObject:item];
}

- (BOOL)hasNext {
  return (_index < ([_items count] - 1));
}

- (BOOL)processNext:(NSError **)error {
  FFProcessingItem *item = [_items objectAtIndex:_index];
  BOOL processed = [_processing processURL:item.URL format:item.format index:_index count:[_items count] error:error];
  _index++;
  return processed;
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
