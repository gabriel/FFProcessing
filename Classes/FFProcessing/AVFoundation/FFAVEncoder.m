//
//  FFAVEncoder.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/17/10.
//  Copyright 2010. All rights reserved.
//

#import "FFAVEncoder.h"


@implementation FFAVEncoder

- (id)initWithOptions:(FFEncoderOptions *)options {
  if ((self = [self init])) {
    _options = [options retain];
  }
  return self;
}

- (void)dealloc {
  [_options release];
  [super dealloc];
}

- (BOOL)open:(NSError **)error {
  return NO;
}

- (BOOL)isOpen {
  return NO;
}

- (BOOL)writeHeader:(NSError **)error {
  return NO;
}

- (int)encodeFrame:(FFVFrameRef)frame error:(NSError **)error {
  return 0;
}

- (BOOL)writeVideoBuffer:(NSError **)error {
  return NO;
}

- (BOOL)writeTrailer:(NSError **)error {
  return NO;
}

- (void)close {
}

/*!
 Access underlying coded frame.
 
 For FFMPEncoder is an (AVFrame *).
 */
- (void *)codedFrame {
  return NULL;
}

/*
- () {
  _output = [[AVCaptureMovieFileOutput alloc] init];  
  _output.maxRecordedDuration = CMTimeMakeWithSeconds(5, 600);
  _URL = [[NSURL alloc] initFileURLWithPath: [NSTemporaryDirectory() stringByAppendingString:@"video1.mov"]];  
  [_output startRecordingToOutputFileURL:_URL recordingDelegate:self];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL 
      fromConnections:(NSArray *)connections {
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL 
      fromConnections:(NSArray *)connections error:(NSError *)error {
}
*/
 

/*
- () {
  AVMutableComposition *saveComposition = [AVMutableComposition composition];
  
  NSError *error;
  NSURL *URL = [[NSURL alloc] initFileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"video1.mov"]];
  
  NSMutableDictionary *options = [NSMutableDictionary dictionary];
  
  //BOOL yes = YES;
  //NSValue *value = [NSValue valueWithBytes:&yes objCType:@encode(BOOL)];
  //[options setObject:value forKey: AVURLAssetPreferPreciseDurationAndTimingKey];
  
  AVURLAsset *video = [AVURLAsset URLAssetWithURL:URL options:nil];  
  video.preferredTransform = CGAffineTransformMakeRotation(DegreesToRadians(90));
  
  [saveComposition insertTimeRange:CMTimeRangeMake(kCMTimeZero, [video duration]) 
                           ofAsset:video atTime:kCMTimeZero error:&error];

  AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:saveComposition presetName:AVAssetExportPresetLowQuality];  
  exporter.outputURL = URL;  
  exporter.outputFileType = [[exporter supportedFileTypes] objectAtIndex:0];  
  [exporter exportAsynchronouslyWithCompletionHandler:^{
    [self performSelectorOnMainThread:@selector(playMerged) withObject:nil waitUntilDone:NO];
    NSLog(@"playing %@",self);
  }];
}
*/

@end
