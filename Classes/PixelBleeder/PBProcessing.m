//
//  PBProcessing.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "PBProcessing.h"

#import "FFUtils.h"
#import "FFProcessing.h"

@interface PBProcessing ()
@property (retain, nonatomic) NSString *outputPath;
@end

@implementation PBProcessing

@synthesize outputPath=_outputPath, delegate=_delegate;

- (void)dealloc {
  [self close];
  [_outputPath release];
  [super dealloc];
}

- (void)close {
  _processingThread.delegate = nil;
  [_processingThread cancel];
  [_processingThread release];
}  

- (void)startWithItems:(NSArray *)items {
  if ([_processingThread isExecuting]) return;
  
  [self close];
  
  NSString *outputFormat = @"mp4";
  NSString *outputCodecName = @"mpeg4";
  NSString *outputPath = [[FFUtils documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"mosh.mp4", outputFormat]];
  
  FFProcessingOptions *options = [[[FFProcessingOptions alloc] init] autorelease];
  options.encoderOptions = [[[FFEncoderOptions alloc] initWithPath:outputPath format:outputFormat codecName:outputCodecName
                                                             width:0 height:0 pixelFormat:PIX_FMT_NONE videoTimeBase:(AVRational){0,0}] autorelease];
  options.skipEveryIFrameInterval = 1;
  options.smoothFrameInterval = 2;
  options.smoothFrameRepeat = 2;  
  
  [outputPath retain];
  [_outputPath release];
  _outputPath = outputPath;
  
  _processingThread = [[FFProcessingThread alloc] initWithOptions:options items:items];
  _processingThread.delegate = self;  
  
  [_processingThread start];
}

- (void)cancel {
  [_processingThread cancel];
}

- (BOOL)isExecuting {
  return [_processingThread isExecuting];
}

#pragma mark FFProcessingThreadDelegate

- (void)processingThread:(FFProcessingThread *)processingThread didStartIndex:(NSInteger)index count:(NSInteger)count {
  FFDebug(@"Started %d/%d", index, count);
  [_delegate processing:self didStartIndex:index count:count];
}

- (void)processingThread:(FFProcessingThread *)processingThread didReadFramePTS:(int64_t)framePTS duration:(int64_t)duration 
                   index:(NSInteger)index count:(NSInteger)count {
  //FFDebug(@" - (%lld/%lld) (%d/%d)", framePTS, duration, index, count);
  [_delegate processing:self didProgress:((double)framePTS/duration) index:index count:count];
}

- (void)processingThread:(FFProcessingThread *)processingThread didFinishIndex:(NSInteger)index count:(NSInteger)count {
  FFDebug(@"Finished %d/%d", (index + 1), count);
  [_delegate processing:self didFinishIndex:index count:count];
}

- (void)processingThread:(FFProcessingThread *)processingThread didError:(NSError *)error index:(NSInteger)index count:(NSInteger)count {
  FFDebug(@"Error: %@ (%d/%d)", error, index, count);
  [_delegate processing:self didError:error index:index count:count];
}

- (void)processingThreadDidCancel:(FFProcessingThread *)processingThread {
  [_delegate processingDidCancel:self];
}

@end
