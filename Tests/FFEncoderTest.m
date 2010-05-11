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
  NSString *outputFormat = @"mp4";
  NSString *outputCodecName = @"mpeg4";
  FFAVFormat avFormat = FFAVFormatMake(320, 480, PIX_FMT_YUV420P);
  
  FFEncoderOptions *options = [[FFEncoderOptions alloc] initWithPath:path format:outputFormat codecName:outputCodecName
                                                            avFormat:avFormat
                                                       videoTimeBase:(AVRational){0,1}];
  FFEncoder *encoder = [[FFEncoder alloc] initWithOptions:options];
  NSError *error = nil;
  
  FFAVFrame avFrame = FFAVFrameCreate(avFormat);
  GHAssertNotNULL(avFrame.frame, nil);
  
  GHAssertTrue([encoder open:&error], nil);
  
  GHAssertTrue([encoder writeHeader:&error], nil);

  // Fill in dummy picture data
  for (NSUInteger i = 0; i < 200; i++) {
    FFFillYUVImage(avFrame, i);    
    GHAssertTrue([encoder writeVideoFrame:avFrame.frame error:&error], nil);
  }
  
  GHAssertTrue([encoder writeTrailer:&error], nil);
  
  [encoder close];
  
  FFAVFrameRelease(avFrame);
  
  [encoder release];
}  

@end
