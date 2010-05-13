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
  [self close];
  [super dealloc];
}

- (BOOL)_start:(NSError **)error {
  _captureSession = [[AVCaptureSession alloc] init];
  AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:error];
  if (!videoInput) return NO;
  
  [_captureSession addInput:videoInput];
    
  _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
  //_videoOutput.minFrameDuration = CMTimeMake(1, 10);
  _videoOutput.alwaysDiscardsLateVideoFrames = TRUE;
  _videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithUnsignedInt:kCVPixelFormat], kCVPixelBufferPixelFormatTypeKey,
                                nil];
  [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_current_queue()];
  
  [_captureSession addOutput:_videoOutput];  
  [_captureSession startRunning];
  FFDebug(@"Started capture session");
  return YES;
}

- (void)close {
  if (!_captureSession) return;

  [_captureSession stopRunning];
  [_captureSession release];
  _captureSession = nil;
  //_videoOutput.sampleBufferDelegate = nil;
  [_videoOutput release];
  _videoOutput = nil;
  if (_avFrame.frame != NULL) {
    FFAVFrameRelease(_avFrame);
    // Data is free above since it was set in the FFAVFrame
    //av_free(_data);  
    _avFrame = FFAVFrameNone;
  }
  _data = NULL;
  _dataSize = 0;  
  FFDebug(@"Closed capture session");
}

- (FFAVFrame)nextFrame:(NSError **)error {
  if (!_captureSession) {
    [self _start:error];
    return FFAVFrameNone;
  }
  
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
  
  //FFDebug(@"width=%d, height=%d, size=%d", width, height, size);
  
  if (_avFrame.frame == NULL) 
    _avFrame = FFAVFrameCreate(FFAVFormatMake(width, height, kPixelFormat));

  if (_data == NULL || size != _dataSize) {
    FFDebug(@"Allocating video data of size: %d", size);
    if (_data != NULL) av_free(_data);
    _data = av_malloc(size);
    _dataSize = size;
  }
  
#if DEBUG
  static NSInteger DebugCount = 0;
  if (DebugCount++ % 30 == 0) FFDebug(@"[SAMPLE BUFFER]");
#endif  
  
  memcpy(_data, baseAddress, _dataSize); 
  _dataChanged = YES;
  
  CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

@end
