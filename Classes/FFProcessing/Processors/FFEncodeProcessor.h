//
//  FFEncodeProcessor.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessor.h"
#import "FFEncoder.h"
#import "FFEncoderOptions.h"

@interface FFEncodeProcessor : NSObject <FFProcessor> {
  
  FFEncoder *_encoder;
  FFEncoderOptions *_encoderOptions;
  
}

- (id)initWithEncoderOptions:(FFEncoderOptions *)encoderOptions;

- (BOOL)openEncoderWithAVFormat:(FFAVFormat)avFormat decoder:(FFDecoder *)decoder error:(NSError **)error;

@end
