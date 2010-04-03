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
#import "FFDefines.h"

@implementation PBProcessing

- (void)processURL:(NSURL *)URL outputPath:(NSString *)outputPath outputFormat:(NSString *)outputFormat {  
  NSError *error = nil;
  FFProcessing *processing = [[FFProcessing alloc] init];
  if (![processing openURL:URL format:nil outputPath:outputPath outputFormat:outputFormat error:&error]) {
    FFDebug(@"Error opening: %@", error);
    return;
  }
  
  [processing process:&error];
  
  [processing close];
  
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
