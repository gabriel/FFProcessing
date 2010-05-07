//
//  FFAVCaptureSessionReader.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFAVCaptureSessionReader.h"
#import "FFUtils.h"

@implementation FFAVCaptureSessionReader

- (BOOL)start:(NSError **)error {
  [_captureSession release];
  _captureSession = [[AVCaptureSession alloc] init];
  AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:error];
  if (!videoInput) return NO;
  
  [_captureSession addInput:videoInput];
  
  [_videoOutput release];
  _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
  //_videoOutput.minFrameDuration = CMTimeMake(1, 10);
  _videoOutput.alwaysDiscardsLateVideoFrames = TRUE;
  _videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                nil];
  [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_current_queue()];
  
  [_captureSession addOutput:_videoOutput];  
  [_captureSession startRunning];
  
  return YES;
}

- (void)stop {
  [_captureSession stopRunning];
}

- (FFAVFrame)nextFrame:(NSError **)error {
  return FFAVFrameNone;
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
       fromConnection:(AVCaptureConnection *)connection {
  
  CVImageBufferRef frame = CMSampleBufferGetImageBuffer(sampleBuffer);
  CVPixelBufferLockBaseAddress(frame, 0);
  
  size_t width = CVPixelBufferGetWidth(frame);
  size_t height = CVPixelBufferGetHeight(frame);
  size_t depth = CVPixelBufferGetBytesPerRow(frame);
  
  size_t size = CVPixelBufferGetDataSize(frame);
  bool isPlanar = CVPixelBufferIsPlanar(frame);
  //uint8_t *data = (uint8_t *)CVPixelBufferGetBaseAddress(frame);
  
  FFDebug(@"width=%d, height=%d, depth=%d, size=%d, isPlanar=%d", width, height, depth, size, isPlanar);
  
  CVPixelBufferUnlockBaseAddress(frame, 0);
}

@end
