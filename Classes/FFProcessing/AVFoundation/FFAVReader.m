//
//  FFAVReader.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/14/10.
//  Copyright 2010 All rights reserved.
//

#import "FFAVReader.h"


@implementation FFAVReader

- (FFVFormat)format {
  return FFVFormatNone;
}

- (BOOL)readFrame:(FFVFrameRef)frame {
  return NO;
}

- (void)start {
}

- (void)close {
}

@end
