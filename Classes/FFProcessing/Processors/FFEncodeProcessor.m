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

- (BOOL)openEncoderWithPictureFormat:(FFPictureFormat)pictureFormat decoder:(FFDecoder *)decoder error:(NSError **)error {
  
  // Fill in encoder options (with decoder properties) if not set
  FFPictureFormat encoderPictureFormat = _encoderOptions.pictureFormat;
  AVRational videoTimeBase = _encoderOptions.videoTimeBase;
  if (encoderPictureFormat.width == 0) encoderPictureFormat.width = pictureFormat.width;
  if (encoderPictureFormat.height == 0) encoderPictureFormat.height = pictureFormat.height;
  if (encoderPictureFormat.pixelFormat == PIX_FMT_NONE) encoderPictureFormat.pixelFormat = pictureFormat.pixelFormat;
  if (videoTimeBase.num == 0) videoTimeBase = decoder.options.videoTimeBase;
  
  FFEncoderOptions *options = [[FFEncoderOptions alloc] initWithPath:_encoderOptions.path 
                                                              format:_encoderOptions.format
                                                           codecName:_encoderOptions.codecName
                                                       pictureFormat:encoderPictureFormat
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

- (BOOL)processPictureFrame:(FFPictureFrame)pictureFrame decoder:(FFDecoder *)decoder index:(NSInteger)index error:(NSError **)error {
  
  if (!_encoder) {
    if (![self openEncoderWithPictureFormat:pictureFrame.pictureFormat decoder:decoder error:error])
      return NO;
  }
  
  int bytesEncoded = [_encoder encodeVideoFrame:pictureFrame.frame error:error];
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
