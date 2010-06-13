//
//  FFEncodeProcessor.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEncodeProcessor.h"
#import "FFUtils.h"
#import "FFMPUtils.h"
#import "FFMPEncoder.h"

@implementation FFEncodeProcessor

- (id)initWithEncoderOptions:(FFEncoderOptions *)encoderOptions {
  if ((self = [self init])) {
    _encoderOptions = [encoderOptions retain];
  }  
  return self;
}

- (void)dealloc {
  [self close:nil];
  [_encoderOptions release];
  [super dealloc];
}

- (BOOL)open:(NSError **)error { 
  return YES;
}

- (BOOL)openEncoderWithFormat:(FFVFormat)format decoder:(id<FFDecoder>)decoder error:(NSError **)error {
  
  // Fill in encoder options (with decoder properties) if not set
  FFVFormat encoderFormat = _encoderOptions.format;
  FFRational videoTimeBase = _encoderOptions.videoTimeBase;
  if (encoderFormat.width == 0) encoderFormat.width = format.width;
  if (encoderFormat.height == 0) encoderFormat.height = format.height;
  if (encoderFormat.pixelFormat == kFFPixelFormatType_None) encoderFormat.pixelFormat = format.pixelFormat;
  if (videoTimeBase.num == 0) videoTimeBase = decoder.options.videoTimeBase;
  
  FFEncoderOptions *options = [[FFEncoderOptions alloc] initWithPath:_encoderOptions.path 
                                                          formatName:_encoderOptions.formatName
                                                           codecName:_encoderOptions.codecName
                                                              format:encoderFormat
                                                       videoTimeBase:videoTimeBase];
  
  _encoder = [[FFMPEncoder alloc] initWithOptions:options];
  [options release];  
  
  if ([_encoder open:error]) {    
    return [_encoder writeHeader:error];
  }

  return NO;
}

- (BOOL)close:(NSError **)error {
  if ([_encoder isOpen]) {
    [_encoder writeTrailer:error]; // TODO: return NO on error
    [_encoder close];
  }
  [_encoder release];
  _encoder = nil;
  return YES;
}

- (BOOL)processFrame:(FFVFrameRef)frame decoder:(id<FFDecoder>)decoder index:(NSInteger)index error:(NSError **)error {
  
  if (!_encoder) {
    if (![self openEncoderWithFormat:FFVFrameGetFormat(frame) decoder:decoder error:error])
      return NO;
  }
  
  int bytesEncoded = [_encoder encodeFrame:frame error:error];
  if (bytesEncoded < 0) {
    FFDebug(@"Encode error");
    return NO;
  }  
  
  // If bytesEncoded is zero, there was buffering
  if (bytesEncoded == 0) {      
    return NO;
  }
  
  return [_encoder writeVideoBuffer:error];  
  
}

@end
