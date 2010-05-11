//
//  FFAVCaptureSessionReader.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "FFReader.h"
#import "FFConverter.h"

@interface FFAVCaptureSessionReader : NSObject <FFReader, AVCaptureVideoDataOutputSampleBufferDelegate> {
  AVCaptureSession *_captureSession;
  AVCaptureVideoDataOutput *_videoOutput;
  
  FFAVFrame _avFrame;
  BOOL _dataChanged;

  uint8_t *_data; // Data from camera
  size_t _dataSize;
  
  FFConverter *_converter;
}

- (BOOL)start:(NSError **)error;

- (void)stop;

@end
