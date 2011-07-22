//
//  FFAVCaptureSessionReader.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import "FFAVCaptureSessionReader.h"
#import "FFUtils.h"
#import "FFTypes.h"
#import "FFAVUtils.h"

#if !TARGET_IPHONE_SIMULATOR

#define kCVPixelFormat kCVPixelFormatType_32BGRA

//#define kCVPixelFormat kCVPixelFormatType_1Monochrome
//#define kCVPixelFormat kCVPixelFormatType_24RGB

@implementation FFAVCaptureSessionReader

@synthesize sessionPreset=_sessionPreset;

- (void)dealloc {
  [self close];
  [_sessionPreset release];
  [super dealloc];
}

- (void)_setupVideoDevice:(AVCaptureDevice *)videoCaptureDevice {  
  [videoCaptureDevice lockForConfiguration:nil];
  if ([videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) 
    videoCaptureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
  
  if ([videoCaptureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
    videoCaptureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;  
  
  if ([videoCaptureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
    videoCaptureDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
  [videoCaptureDevice unlockForConfiguration];  
}

- (BOOL)_start:(NSError **)error {
  if (_captureSession) {
    FFSetError(error, 0, @"Capture session already started");
    return NO;
  }
  
  _captureSession = [[AVCaptureSession alloc] init];
  NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
  FFDebug(@"Devices: %@", devices);
  // [devices lastObject]; // For front camera
  AVCaptureDevice *videoCaptureDevice = [devices gh_firstObject];
  if (!videoCaptureDevice) return NO;
  [self _setupVideoDevice:videoCaptureDevice];
    
  AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:error];
  if (!videoInput) return NO;
  
  NSString *sessionPreset = _sessionPreset;
  if (!sessionPreset) sessionPreset = AVCaptureSessionPresetLow;
  
  [_captureSession setSessionPreset:sessionPreset];
  [_captureSession addInput:videoInput];
  
  NSArray *audioCaptureDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
  if ([audioCaptureDevices count] > 0) {
    AVCaptureDevice *audioCaptureDevice = [audioCaptureDevices objectAtIndex:0];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:error];
    if (!audioInput) return NO;
    [_captureSession addInput:audioInput];
  }  
 
  _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
  //_videoOutput.minFrameDuration = CMTimeMake(1, 15);
  _videoOutput.alwaysDiscardsLateVideoFrames = TRUE;
  _videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithUnsignedInt:kCVPixelFormat], kCVPixelBufferPixelFormatTypeKey,
                                nil];  
  
  _queue = dispatch_queue_create("rel.me.FFProcessing", NULL);
  [_videoOutput setSampleBufferDelegate:self queue:_queue];
  
  if (![_captureSession canAddOutput:_videoOutput]) {
    FFSetError(error, 0, @"Can't add video output: %@", _videoOutput);
    return NO;
  }
  
  [_captureSession addOutput:_videoOutput];  
  [_captureSession startRunning];
  FFDebug(@"Started capture session");
  return YES;
}

- (void)close {
  if (!_captureSession) return;

  [_captureSession stopRunning];
  
  // Wait until it stops
  if (_captureSession.isRunning)
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
  
  [_captureSession release];
  _captureSession = nil;
  
  dispatch_release(_queue);
  
  //_videoOutput.sampleBufferDelegate = nil;
  [_videoOutput release];
  _videoOutput = nil;
  
  FFVFrameRelease(_frame);  
  _frame = NULL;
  free(_data);  
  _data = NULL;
  _dataSize = 0;  
  FFDebug(@"Closed capture session");
}

- (FFVFrameRef)nextFrame:(NSError **)error {
  _wantsData = YES;
  if (!_captureSession) {
    [self _start:error];
    return NULL;
  }
  
  if (!_captureSession.isRunning) FFWarn(@"Capture session is not running");
  if (_captureSession.isInterrupted) FFWarn(@"Capture session is interrupted");
  
  if (!_dataChanged) return NULL;

  FFVFrameSetData(_frame, _data);
  _dataChanged = NO;
  return _frame;
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
       fromConnection:(AVCaptureConnection *)connection {

  if (!_wantsData) return;
  
  CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  if (imageBuffer == NULL) {
    // TODO: Capture audio
    return;
  }

  CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
  
  //size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
  
  //size_t size = CVPixelBufferGetDataSize(imageBuffer);
  //bool isPlanar = CVPixelBufferIsPlanar(imageBuffer);
  uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
  
  //size_t left, right, top, bottom;
  //CVPixelBufferGetExtendedPixels(imageBuffer, &left, &right, &top, &bottom);

  // TODO(gabe): Fail if planar
  
  size_t size = CVPixelBufferGetDataSize(imageBuffer);
  
  if (_frame == NULL) {
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    FFDebug(@"Creating frame; width=%d, height=%d, size=%d", width, height, size);
    FFPixelFormat pixelFormat = FFPixelFormatFromCVPixelFormat(kCVPixelFormat);
    _frame = FFVFrameCreateWithData(FFVFormatMake(width, height, pixelFormat), NULL);
  }

  if (_data == NULL || size != _dataSize) {
    FFDebug(@"Allocating video data of size: %d", size);
    if (_data != NULL) free(_data);
    _data = malloc(size);
    _dataSize = size;
  }
  
#if DEBUG
  static NSInteger DebugCount = 0;
  if (DebugCount++ % 30 == 0) FFDebug(@"[SAMPLE BUFFER]");
#endif  
  
  memcpy(_data, baseAddress, _dataSize); 
  _dataChanged = YES;
  _wantsData = NO;
  
  CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
}

@end

#else

@implementation FFAVCaptureSessionReader

- (FFVFrameRef)nextFrame:(NSError **)error { 
  if (_frame == NULL) {
    _frame = FFVFrameCreate(FFVFormatMake(320, 480, kFFPixelFormatType_32BGRA));
    FFFill32BGRAImage(_frame, 0);
    FFDebug(@"Filled 32BGRA image");
  }
  FFDebug(@"[FRAME]");
  return _frame;  
}

- (void)close { }

@end

#endif