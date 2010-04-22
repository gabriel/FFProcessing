//
//  PBProcessing.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessingThread.h"
#import "FFProcessingOptions.h"

@class PBProcessing;

@protocol PBProcessingDelegate <NSObject>
- (void)processing:(PBProcessing *)processing didStartIndex:(NSInteger)index count:(NSInteger)count;
- (void)processing:(PBProcessing *)processing didProgress:(float)progress index:(NSInteger)index count:(NSInteger)count;
- (void)processing:(PBProcessing *)processing didFinishIndex:(NSInteger)index count:(NSInteger)count;
- (void)processing:(PBProcessing *)processing didError:(NSError *)error index:(NSInteger)index count:(NSInteger)count;
- (void)processingDidCancel:(PBProcessing *)processing;
@end

@interface PBProcessing : NSObject <FFProcessingThreadDelegate> {
  FFProcessingThread *_processingThread;
  NSString *_outputPath;
  
  id<PBProcessingDelegate> _delegate;
}

@property (readonly, retain, nonatomic) NSString *outputPath;
@property (assign, nonatomic) id<PBProcessingDelegate> delegate;

- (void)startWithItems:(NSArray *)items;

- (void)cancel;

- (void)close;

- (BOOL)isExecuting;

- (NSString *)outputPath;

@end
