//
//  FFPresetsTest.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/3/10.
//  Copyright 2010. All rights reserved.
//


#import "GHUnit.h"

#import "FFPresets.h"
#import "FFUtils.h"

@interface FFPresetsTest : GHTestCase { }
@end

@implementation FFPresetsTest

- (void)testLoad {
  NSError *error = nil;
  FFPresets *presets = [[FFPresets alloc] init];
  NSString *path = [FFUtils resolvedPathForURL:[NSURL URLWithString:@"bundle://libx264-ipod320.ffpreset"]];
  GHAssertTrue([presets loadPresets:path error:&error], nil);
  GHAssertNil(error, nil);  
  
  GHAssertEqualStrings(@"0", [presets.dict objectForKey:@"coder"], nil);
  GHAssertEqualStrings(@"0", [presets.dict objectForKey:@"bf"], nil);
  GHAssertEqualStrings(@"-wpred-dct8x8+mbtree", [presets.dict objectForKey:@"flags2"], nil);
  GHAssertEqualStrings(@"13", [presets.dict objectForKey:@"level"], nil);
  GHAssertEqualStrings(@"768000", [presets.dict objectForKey:@"maxrate"], nil);
  GHAssertEqualStrings(@"3000000", [presets.dict objectForKey:@"bufsize"], nil);
  GHAssertEqualStrings(@"0", [presets.dict objectForKey:@"wpredp"], nil);
}

@end
