//
//  FFEncoderTest.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/28/10.
//  Copyright 2010. All rights reserved.
//

#import "GHUnit.h"

#import "FFUtils.h"
#import "FFEncoder.h"

@interface FFEncoderTest : GHTestCase { }
@end

@implementation FFEncoderTest

- (void)testEncoding {
  NSString *path = [[FFUtils documentsDirectory] stringByAppendingPathComponent:@"test.mp4"];
  FFOptions *options = [[FFOptions alloc] initWithWidth:320 height:480 pixelFormat:PIX_FMT_YUV420P];
  FFEncoder *encoder = [[FFEncoder alloc] initWithOptions:options presets:[[[FFPresets alloc] init] autorelease]
                                                   path:path format:nil codecName:nil];
  NSError *error = nil;
  
  AVFrame *picture = FFPictureCreate(PIX_FMT_YUV420P, 320, 480);
  GHAssertNotNULL(picture, nil);
  
  GHAssertTrue([encoder open:&error], nil);
  
  GHAssertTrue([encoder writeHeader:&error], nil);

  // Fill in dummy picture data
  for (NSUInteger i = 0; i < 200; i++) {
    FFFillYUVImage(picture, i, 320, 480);    
    GHAssertTrue([encoder writeVideoFrame:picture error:&error], nil);
  }
  
  GHAssertTrue([encoder writeTrailer:&error], nil);
  
  [encoder close];
  
  FFPictureRelease(picture);
  
  [encoder release];
}  

@end
