//
//  FFProcessing.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoder.h"
#import "FFFilter.h"
#import "FFProcessor.h"

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
  
  id<FFFilter>_filter;
  id<FFProcessor> _processor;
  
  BOOL _open;
  
  FFDecoder *_decoder;
  AVFrame *_decoderFrame;
  FFAVFrame _decodedFrame;
  
  id<FFProcessingDelegate> _delegate; // Weak
  
  int64_t _previousEndPTS;
  
  BOOL _cancelled;
}

@property (readonly, nonatomic, getter=isCancelled) BOOL cancelled;

@property (assign, nonatomic) id<FFProcessingDelegate> delegate;

- (id)initWithProcessor:(id<FFProcessor>)processor filter:(id<FFFilter>)filter;

- (BOOL)processURL:(NSURL *)URL format:(NSString *)format index:(NSInteger)index count:(NSInteger)count error:(NSError **)error;

- (void)cancel;

- (BOOL)close:(NSError **)error;

@end
