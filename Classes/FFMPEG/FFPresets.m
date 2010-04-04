//
//  FFPresets.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/3/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPresets.h"
#import "FFUtils.h"

@implementation FFPresets

@synthesize dict=_dict;

- (id)init {
  if ((self = [super init])) {
    _dict = [[NSMutableDictionary alloc] initWithCapacity:100];
  }
  return self;
}

- (void)dealloc {
  [_dict release];
  [super dealloc];
}

- (BOOL)loadPresets:(NSString *)path error:(NSError **)error {
  // This is very slow; Use NSScanner or something
  NSString *stringFromFileAtPath = [[NSString alloc]
                                    initWithContentsOfFile:path
                                    encoding:NSUTF8StringEncoding
                                    error:error];
  
  if (!stringFromFileAtPath && *error) return NO;
  
  for (NSString *line in [stringFromFileAtPath componentsSeparatedByString:@"\n"]) {
    NSArray *pair = [line componentsSeparatedByString:@"="];
    if ([pair count] == 2) {
      NSString *key = [pair objectAtIndex:0];
      NSString *value = [pair objectAtIndex:1];
      [_dict setObject:value forKey:key];
    } else {
      FFWarn(@"Couldn't parse line: %@", line);
    }
  }  
  return YES;
}

- (void)apply:(AVCodecContext *)codecContext {
  // Defaults (x264)
  codecContext->me_range = 16;
  codecContext->max_qdiff = 4;
  codecContext->qmin = 10;
  codecContext->qmax = 51;
  codecContext->qcompress = 0.6;
  
  // Presets ipod (x264)
  codecContext->flags2 |= CODEC_FLAG2_WPRED;
  codecContext->flags2 |= CODEC_FLAG2_8X8DCT;
  codecContext->flags2 |= CODEC_FLAG2_MBTREE;  
  codecContext->coder_type = 0;
  codecContext->max_b_frames = 0;
  codecContext->level = 13;
  codecContext->rc_max_rate = 768*1000;
  codecContext->rc_buffer_size = 3000000;
  codecContext->weighted_p_pred = 0;
  
  // Options for ipod 320
  codecContext->bit_rate = 200*1000;
  codecContext->bit_rate_tolerance = 240*1000;
  
  codecContext->time_base = (AVRational){1001, 30000};
}

@end
