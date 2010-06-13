//
//  FFEncoderOptions.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/17/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"

@interface FFEncoderOptions : NSObject {

  NSString *_path;
  NSString *_formatName;
  NSString *_codecName;  
  
  FFVFormat _format;
  FFRational _videoTimeBase;
  FFRational _sampleAspectRatio;
}

@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSString *formatName;
@property (readonly, nonatomic) NSString *codecName;  
@property (readonly, nonatomic) FFVFormat format;
@property (readonly, nonatomic) FFRational videoTimeBase;
@property (readonly, nonatomic) FFRational sampleAspectRatio;


- (id)initWithPath:(NSString *)path formatName:(NSString *)formatName codecName:(NSString *)codecName
     format:(FFVFormat)format videoTimeBase:(FFRational)videoTimeBase;

@end