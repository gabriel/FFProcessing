//
//  FFProcessingQueue.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/15/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessing.h"

@class FFProcessingItem;

@interface FFProcessingQueue : NSObject {
  FFProcessing *_processing;
  NSMutableArray *_items;
  NSInteger _index;
}

- (id)initWithProcessing:(FFProcessing *)processing;

- (void)addItem:(FFProcessingItem *)item;

- (BOOL)hasNext;

- (BOOL)processNext:(NSError **)error;

@end

@interface FFProcessingItem : NSObject {
  NSURL *_URL;
  NSString *_format;
}

@property (readonly, nonatomic) NSURL *URL;
@property (readonly, nonatomic) NSString *format;

- (id)initWithURL:(NSURL *)URL format:(NSString *)format;

@end