//
//  PBSaveThread.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/22/10.
//  Copyright 2010. All rights reserved.
//

#import "PBSaveThread.h"

#import "GHNSObject+Invocation.h"

@implementation PBSaveThread

@synthesize delegate=_delegate, path=_path;

- (id)initWithPath:(NSString *)path {
  if ((self = [self init])) {
    _path = [path retain];
  }
  return self;
}

- (void)dealloc {
  [_path release];
  [super dealloc];
}

- (void)main {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  UISaveVideoAtPathToSavedPhotosAlbum(_path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
  [pool release];
}

#pragma mark UISaveVideoAtPathToSavedPhotosAlbum

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
  [[(id)_delegate gh_proxyOnMainThread] saveThread:self didFinishSavingWithError:error];
}


@end
