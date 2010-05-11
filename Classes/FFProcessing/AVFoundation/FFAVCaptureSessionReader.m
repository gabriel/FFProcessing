//
//  FFAVCaptureSessionReader.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import "FFAVCaptureSessionReader.h"
#import "FFUtils.h"

#define kCVPixelFormat kCVPixelFormatType_32BGRA
#define kPixelFormat PIX_FMT_BGRA
//#define kConverterPixelFormat PIX_FMT_BGRA
//#define kConverterPixelFormat PIX_FMT_RGB24
//#define kCVPixelFormat kCVPixelFormatType_24RGB
//#define kPixelFormat PIX_FMT_RGB24

@implementation FFAVCaptureSessionReader

- (id)init {
  if ((self = [super init])) {
    _avFrame = FFAVFrameNone;
  }
  return self;
}

- (void)dealloc {
  FFAVFrameRelease(_avFrame);
  // Data is free above since it was set in the FFAVFrame
  //av_free(_data);
  [super dealloc];
}

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
                                [NSNumber numberWithUnsignedInt:kCVPixelFormat], kCVPixelBufferPixelFormatTypeKey,
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
  if (_dataChanged) {
    //FFDebug(@"Next frame");
    FFAVFrameSetData(_avFrame, _data);
    _dataChanged = NO;
    if (_converter) {
      return [_converter scalePicture:_avFrame error:nil];    
    } else {
      return _avFrame;
    }
  }
  return FFAVFrameNone;
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
       fromConnection:(AVCaptureConnection *)connection {
  
  CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  CVPixelBufferLockBaseAddress(imageBuffer, 0);
  
  size_t width = CVPixelBufferGetWidth(imageBuffer);
  size_t height = CVPixelBufferGetHeight(imageBuffer);
  //size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
  
  size_t size = CVPixelBufferGetDataSize(imageBuffer);
  //bool isPlanar = CVPixelBufferIsPlanar(imageBuffer);
  uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
  
  //size_t left, right, top, bottom;
  //CVPixelBufferGetExtendedPixels(imageBuffer, &left, &right, &top, &bottom);

  // TODO(gabe): Fail if planar
  
  FFDebug(@"width=%d, height=%d, size=%d", width, height, size);
  
  if (_avFrame.frame == NULL) 
    _avFrame = FFAVFrameCreate(FFAVFormatMake(width, height, kPixelFormat));

  if (_data == NULL || size != _dataSize) {
    FFDebug(@"Allocating video data of size: %d", size);
    if (_data != NULL) av_free(_data);
    _data = av_malloc(size);
    _dataSize = size;
  }
    
  memcpy(_data, baseAddress, _dataSize); 
  _dataChanged = YES;
  
  CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

@end
