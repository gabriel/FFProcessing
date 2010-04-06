//
//  PBProcessing.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "PBProcessing.h"

#import "FFUtils.h"
#import "FFProcessing.h"


@implementation PBProcessing

- (id)init {
  if ((self = [super init])) {
    self.IFrameInterval = 6;
    self.smoothInterval = 3;
    self.smoothIterations = 2;
  }
  return self;
}

- (void)processURL:(NSURL *)URL outputPath:(NSString *)outputPath outputFormat:(NSString *)outputFormat outputCodecName:(NSString *)outputCodecName {  
  NSError *error = nil;
  
  if (![self openURL:URL format:nil outputPath:outputPath outputFormat:outputFormat outputCodecName:outputCodecName error:&error]) {
    FFDebug(@"Error opening: %@", error);
    return;
  }
  
  [self process:&error];
  
  [self close];
  
}

- (void)saveToPhotoLibrary:(NSString *)path {
  /*!
  if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(videoPath:didFinishSavingWithError:contextInfo:), NULL);
  } else {
    FFDebug(@"Path is not compatible: %@", path);
  }
  */
}  

- (void)videoPath:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
  if (error) {
    FFDebug(@"Error saving: %@", error);
  } else {
    FFDebug(@"Saved"); 
  }
}


@end
