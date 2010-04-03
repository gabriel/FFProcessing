//
//  FFPresets.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/3/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPresets.h"
#import "FFDefines.h"

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

@end
