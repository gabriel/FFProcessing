//
//  FFDataMoshProcessor.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDataMoshProcessor.h"
#import "FFUtils.h"
#import "FFMPUtils.h"

@implementation FFDataMoshProcessor

@synthesize skipEveryIFrameInterval=_skipEveryIFrameInterval, smoothFrameInterval=_smoothFrameInterval, smoothFrameRepeat=_smoothFrameRepeat;

- (void)reset {
  _IFrameIndex = 0;  
  _PFrameIndex = 0;
  _GOPIndex = 0;
  _previousPTS = 0;
}

- (BOOL)open:(NSError **)error {
  [self reset];
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
  if (bytesEncoded == 0) 
    return NO;
  
  AVFrame *codedFrame = (AVFrame *)[_encoder codedFrame];

  if (codedFrame->pict_type == FF_I_TYPE) {        
    FFDebug(@"I-frame %lld (%d, %d)", codedFrame->pts, _IFrameIndex, _GOPIndex);
    _IFrameIndex++;
    _GOPIndex = 0;
    
    if ((_skipEveryIFrameInterval > 0) && // Skipping I-frames is on
        !(index == 0 && _IFrameIndex == 1) && // Don't skip if first I-frame in first input, no matter what options
        ((index > 0 && _IFrameIndex == 1) || // Skip if first I-frame in subsequent inputs
         (_IFrameIndex % _skipEveryIFrameInterval == 0))) // We are on skip interval
    { 
      FFDebug(@"Skipping I-frame");          
    } else {
      if (![_encoder writeVideoBuffer:error]) 
        return NO;
    }
    
  } else if (codedFrame->pict_type == FF_P_TYPE) {
    _GOPIndex++;
    if (_smoothFrameInterval > 0 && (_PFrameIndex++ % _smoothFrameInterval == 0) && _previousPTS > 0) {
      
      NSInteger count = _smoothFrameRepeat + 1;
      int64_t startPTS = codedFrame->pts;
      int64_t duration = (int64_t)((codedFrame->pts - _previousPTS)/(double)count);
      
      for (int i = 0; i < count; i++) {
        codedFrame->pts = startPTS + (duration * i);            
        FFDebug(@"P-frame (duping), %lld (%d/%d)", codedFrame->pts, (i + 1), count);
        if (![_encoder writeVideoBuffer:error]) 
          return NO;
      }
    } else { 
      FFDebug(@"P-frame %lld", codedFrame->pts);
      if (![_encoder writeVideoBuffer:error]) 
        return NO;
    }
  }  
  
  _previousPTS = codedFrame->pts;
  
  return YES;
}

@end
