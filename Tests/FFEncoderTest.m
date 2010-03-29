//
//  FFEncoderTest.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/28/10.
//  Copyright 2010. All rights reserved.
//

#import "GHUnit.h"

#import "FFCommon.h"
#import "FFEncoder.h"

@interface FFEncoderTest : GHTestCase { }
@end

@implementation FFEncoderTest

- (void)test {
  NSString *path = [[FFCommon documentsDirectory] stringByAppendingPathComponent:@"test.mp4"];
  FFEncoder *encoder = [[FFEncoder alloc] init];
  NSError *error = nil;
  
  AVFrame *picture = FFCreatePicture(PIX_FMT_YUV420P, 320, 480);
  GHAssertNotNULL(picture, nil);
  
  GHAssertTrue([encoder open:path error:&error], nil);
  
  GHAssertTrue([encoder writeHeader:&error], nil);
  
  // Fill in dummy picture data
  for (NSUInteger i = 0; i < 800; i++) {
    FFFillYUVImage(picture, i, 320, 480);
    [encoder writeVideoFrame:picture error:&error];
  }
  
  GHAssertTrue([encoder writeTrailer:&error], nil);
  
  [encoder close];
  
  FFReleasePicture(picture);
  
  [encoder release];
}  

@end
