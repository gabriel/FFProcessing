//
//  FFProcessing.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoder.h"
#import "FFEncoder.h"
#import "FFProcessingOptions.h"

@class FFProcessing;

@protocol FFProcessingDelegate <NSObject>
- (void)processing:(FFProcessing *)processing didStartIndex:(NSInteger)index count:(NSInteger)count;
- (void)processing:(FFProcessing *)processing didReadFramePTS:(int64_t)framePTS duration:(int64_t)duration 
             index:(NSInteger)index count:(NSInteger)count;
- (void)processing:(FFProcessing *)processing didFinishIndex:(NSInteger)index count:(NSInteger)count;
- (void)processing:(FFProcessing *)processing didError:(NSError *)error index:(NSInteger)index count:(NSInteger)count;
- (void)processingDidCancel:(FFProcessing *)processing;
@end

@interface FFProcessing : NSObject {
  
  FFProcessingOptions *_options;
  
  FFDecoder *_decoder;
  AVFrame *_decoderFrame;
  
  FFEncoder *_encoder;
  
  id<FFProcessingDelegate> _delegate; // Weak
  
  int64_t _previousPTS;
  int64_t _previousEndPTS;

  NSInteger _IFrameIndex;
  NSInteger _PFrameIndex;
  NSInteger _GOPIndex;

  NSInteger _frameIndex;
  NSInteger _frameCount;
  
  BOOL _cancelled;
}

@property (readonly, retain, nonatomic) FFProcessingOptions *options;
@property (readonly, nonatomic, getter=isCancelled) BOOL cancelled;

@property (assign, nonatomic) id<FFProcessingDelegate> delegate;

- (id)initWithOptions:(FFProcessingOptions *)options;

- (BOOL)processURL:(NSURL *)URL format:(NSString *)format index:(NSInteger)index count:(NSInteger)count error:(NSError **)error;

- (void)cancel;

- (void)close;

@end
