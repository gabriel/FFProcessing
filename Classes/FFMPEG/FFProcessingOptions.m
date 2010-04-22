//
//  FFProcessingOptions.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/17/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessingOptions.h"


@implementation FFProcessingOptions

@synthesize encoderOptions=_encoderOptions, skipEveryIFrameInterval=_skipEveryIFrameInterval, 
smoothFrameInterval=_smoothFrameInterval, smoothFrameRepeat=_smoothFrameRepeat;

- (void)dealloc {
  [_encoderOptions release];
  [super dealloc];
}

@end
