//
//  FFEncoderTest.m
//  FFPlayer
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
  FFEncoder *encoder = [[FFEncoder alloc] init];
  NSError *error = nil;
  
  AVFrame *picture = FFCreatePicture(PIX_FMT_YUV420P, 320, 480);
  GHAssertNotNULL(picture, nil);
  
  GHAssertTrue([encoder open:path error:&error], nil);
  
  GHAssertTrue([encoder writeHeader:&error], nil);

  // Fill in dummy picture data
  for (NSUInteger i = 0; i < 200; i++) {
    FFFillYUVImage(picture, i, 320, 480);    
    GHAssertTrue([encoder writeVideoFrame:picture error:&error], nil);
  }
  
  GHAssertTrue([encoder writeTrailer:&error], nil);
  
  [encoder close];
  
  FFReleasePicture(picture);
  
  [encoder release];
}  

- (void)testMoshing {
  NSString *path = [[FFUtils documentsDirectory] stringByAppendingPathComponent:@"test-mosh.mp4"];
  FFEncoder *encoder = [[FFEncoder alloc] init];
  NSError *error = nil;
  
  AVFrame *picture = FFCreatePicture(PIX_FMT_YUV420P, 320, 480);
  GHAssertNotNULL(picture, nil);
  
  GHAssertTrue([encoder open:path error:&error], nil);
  
  GHAssertTrue([encoder writeHeader:&error], nil);
  
  AVCodecContext *videoCodecContext = [encoder videoCodecContext];
  
  NSInteger skipIFrameIndex = 0;
  NSInteger skipIFrameMod = 10;

  // Fill in dummy picture data
  for (NSUInteger i = 0; i < 200; i++) {
    FFFillYUVImage(picture, i, 320, 480);
    
    int bytesEncoded = [encoder encodeVideoFrame:picture error:&error];
    GHAssertFalse(bytesEncoded < 0, nil);

    // Mosh!
    if (videoCodecContext->coded_frame->key_frame) {      
      if (skipIFrameIndex++ % skipIFrameMod != 0)
        continue;     
    }
    
    // If bytesEncoded is zero, there was buffering
    if (bytesEncoded > 0) {
      GHAssertTrue([encoder writeVideoBuffer:&error], nil);
    }
  }
  
  GHAssertTrue([encoder writeTrailer:&error], nil);
  
  [encoder close];
  
  FFReleasePicture(picture);
  
  [encoder release];
}  


@end
