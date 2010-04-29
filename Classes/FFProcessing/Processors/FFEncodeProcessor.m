//
//  FFEncodeProcessor.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEncodeProcessor.h"
#import "FFUtils.h"

@implementation FFEncodeProcessor

- (id)initWithEncoderOptions:(FFEncoderOptions *)encoderOptions {
  if ((self = [self init])) {
    _encoderOptions = [encoderOptions retain];
  }  
  return self;
}

- (void)dealloc {
  [_encoderOptions release];
  [_encoder release];
  [super dealloc];
}

- (BOOL)open:(NSError **)error { 
  return YES;
}

- (BOOL)openEncoderWithDecoder:(FFDecoder *)decoder error:(NSError **)error {
  
  // Fill in encoder options (with decoder properties) if not set
  int width = _encoderOptions.width;
  int height = _encoderOptions.height;
  enum PixelFormat pixelFormat = _encoderOptions.pixelFormat;
  AVRational videoTimeBase = _encoderOptions.videoTimeBase;
  if (width == 0) width = decoder.options.width;
  if (height == 0) height = decoder.options.height;
  if (pixelFormat == PIX_FMT_NONE) pixelFormat = decoder.options.pixelFormat;
  if (videoTimeBase.num == 0) videoTimeBase = decoder.options.videoTimeBase;
  
  FFEncoderOptions *options = [[FFEncoderOptions alloc] initWithPath:_encoderOptions.path 
                                                              format:_encoderOptions.format
                                                           codecName:_encoderOptions.codecName
                                                               width:width
                                                              height:height
                                                         pixelFormat:pixelFormat
                                                       videoTimeBase:videoTimeBase];
  
  _encoder = [[FFEncoder alloc] initWithOptions:options];
  [options release];  
  
  if ([_encoder open:error]) {
    return [_encoder writeHeader:error];
  }
  return NO;
}

- (BOOL)close:(NSError **)error {
  [_encoder writeTrailer:error]; // TODO: return NO on error
  [_encoder close];
  [_encoder release];
  _encoder = nil;
  return YES;
}

- (BOOL)processFrame:(AVFrame *)frame decoder:(FFDecoder *)decoder index:(NSInteger)index error:(NSError **)error {
  
  if (!_encoder) {
    if (![self openEncoderWithDecoder:decoder error:error])
      return NO;
  }
  
  int bytesEncoded = [_encoder encodeVideoFrame:frame error:error];
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
