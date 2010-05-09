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

- (id)init {
  if ((self = [super init])) {
    _avFrame = FFAVFrameNone;
    _converter = [[FFConverter alloc] initWithAVFormat:FFAVFormatMake(256, 256, PIX_FMT_RGB24)];
  }
  return self;
}

- (void)dealloc {
  FFAVFrameRelease(_avFrame);
  av_free(_data);
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
  if (_dataChanged) {
    FFDebug(@"Next frame");
    FFAVFrameSetData(_avFrame, _data);
    _avFrame = [_converter scalePicture:_avFrame error:nil];
    _dataChanged = NO;
    return _avFrame;
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
  size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
  
  size_t size = CVPixelBufferGetDataSize(imageBuffer);
  bool isPlanar = CVPixelBufferIsPlanar(imageBuffer);
  uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);

  // TODO(gabe): Fail if planar
  
  FFDebug(@"width=%d, height=%d, bytesPerRow=%d, size=%d, isPlanar=%d", width, height, bytesPerRow, size, isPlanar);
  
  if (_avFrame.frame == NULL) 
    _avFrame = FFAVFrameCreate(FFAVFormatMake(width, height, PIX_FMT_BGRA));

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
