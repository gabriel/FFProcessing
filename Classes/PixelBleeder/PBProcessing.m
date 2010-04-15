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


@implementation PBProcessing

@synthesize outputPath=_outputPath;

- (id)init {
  if ((self = [super init])) {    
    NSString *outputFormat = @"mp4";
    NSString *outputCodecName = @"mpeg4";
    NSString *outputPath = [[FFUtils documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"mosh.mp4", outputFormat]];
    
    _processing = [[FFProcessing alloc] initWithOutputPath:outputPath outputFormat:outputFormat 
                                           outputCodecName:outputCodecName];
    
    _processing.delegate = self;
    
    _processing.skipEveryIFrameInterval = 1;
    _processing.smoothFrameInterval = 2;
    _processing.smoothFrameRepeat = 2;
  }
  return self;
}

- (void)dealloc {
  [_outputPath release];
  _processing.delegate = nil;
  [_processing release];
  [super dealloc];
}

- (void)processURLs:(NSArray *)URLs {
  
  FFDebug(@"Process: %@ to %@", URLs, self.outputPath);  
  
  NSError *error = nil;
  NSInteger index = 0;
  for (NSURL *URL in URLs) {
    if (![_processing processURL:URL format:nil index:index count:[URLs count] error:&error]) {
      FFDebug(@"Error processing: %@", error);
      break;
    }
    index++;
  }
 
  self.outputPath = _processing.outputPath;
  FFDebug(@"Output path: %@", self.outputPath);
  
  [_processing close];  
}

- (void)processing:(FFProcessing *)processing didStartIndex:(NSInteger)index count:(NSInteger)count {
}

- (void)processing:(FFProcessing *)processing didReadFramePTS:(int64_t)framePTS duration:(int64_t)duration 
             index:(NSInteger)index count:(NSInteger)count {
  FFDebug(@" - (%lld/%lld) (%d/%d)", framePTS, duration, index, count);
}

- (void)processing:(FFProcessing *)processing didFinishIndex:(NSInteger)index count:(NSInteger)count {
}

@end
