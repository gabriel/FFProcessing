//
//  FFAVCaptureSessionReader.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "FFReader.h"

@interface FFAVCaptureSessionReader : NSObject <FFReader, AVCaptureVideoDataOutputSampleBufferDelegate> {
  AVCaptureSession *_captureSession;
  AVCaptureVideoDataOutput *_videoOutput;
}

- (BOOL)start:(NSError **)error;

- (void)stop;

@end
