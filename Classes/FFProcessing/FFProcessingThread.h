//
//  FFProcessingThread.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/15/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessingQueue.h"

@class FFProcessingThread;

@protocol FFProcessingThreadDelegate <NSObject>
- (void)processingThread:(FFProcessingThread *)processingThread didStartIndex:(NSInteger)index count:(NSInteger)count;
- (void)processingThread:(FFProcessingThread *)processingThread didReadFramePTS:(int64_t)framePTS duration:(int64_t)duration 
                  index:(NSInteger)index count:(NSInteger)count;
- (void)processingThread:(FFProcessingThread *)processingThread didFinishIndex:(NSInteger)index count:(NSInteger)count;
- (void)processingThread:(FFProcessingThread *)processingThread didError:(NSError *)error index:(NSInteger)index count:(NSInteger)count;
- (void)processingThreadDidCancel:(FFProcessingThread *)processingThread;
@end


@interface FFProcessingThread : NSThread <FFProcessingQueueDelegate> {
  FFProcessingQueue *_processingQueue;
  
  id<FFProcessingThreadDelegate> _delegate;
}

@property (assign, nonatomic) id<FFProcessingThreadDelegate> delegate;

- (id)initWithProcessor:(id<FFProcessor>)processor filter:(id<FFFilter>)filter items:(NSArray *)items;

@end
