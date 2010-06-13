//
//  FFMPPresets.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/3/10.
//  Copyright 2010. All rights reserved.
//

#import "libavcodec/avcodec.h"

@interface FFMPPresets : NSObject {
  NSMutableDictionary *_dict;
  NSString *_codecName;
}

@property (readonly, nonatomic) NSDictionary *dict;

- (id)initWithCodeName:(NSString *)codecName;

- (BOOL)loadPresets:(NSString *)path error:(NSError **)error;

- (void)apply:(AVCodecContext *)codecContext;

@end
