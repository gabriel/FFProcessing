//
//  FFPresets.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/3/10.
//  Copyright 2010. All rights reserved.
//

#import "libavcodec/avcodec.h"

@interface FFPresets : NSObject {
  NSMutableDictionary *_dict;
}

@property (readonly, nonatomic) NSDictionary *dict;

- (BOOL)loadPresets:(NSString *)path error:(NSError **)error;

- (void)apply:(AVCodecContext *)codecContext;

@end
