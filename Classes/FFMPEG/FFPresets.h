//
//  FFPresets.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/3/10.
//  Copyright 2010. All rights reserved.
//


@interface FFPresets : NSObject {
  NSMutableDictionary *_dict;
}

@property (readonly, nonatomic) NSDictionary *dict;

- (BOOL)loadPresets:(NSString *)path error:(NSError **)error;

@end
