//
//  FFAVEncoder.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/17/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEncoder.h"
#import "FFEncoderOptions.h"

@interface FFAVEncoder : NSObject <FFEncoder> {
  FFEncoderOptions *_options;
}

- (id)initWithOptions:(FFEncoderOptions *)options;

@end
