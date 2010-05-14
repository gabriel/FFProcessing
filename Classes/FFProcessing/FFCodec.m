//
//  FFCodec.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/1/10.
//  Copyright 2010. All rights reserved.
//

#import "FFCodec.h"

#import "libavcodec/avcodec.h"
#import "libavformat/avformat.h"


#import "FFUtils.h"

@implementation FFCodec

+ (void)debug {
  FFInitialize();
  
  AVCodec *codec = NULL;
  while ((codec = av_codec_next(codec))) {
    BOOL decode = (!!codec->decode);
    BOOL encode = (!!codec->encode);

    NSString *typeString = @"?";
    switch (codec->type) {
      case CODEC_TYPE_VIDEO: typeString = @"V"; break;
      case CODEC_TYPE_AUDIO: typeString = @"A"; break;
      case CODEC_TYPE_SUBTITLE: typeString = @"S"; break;
    }
    
    NSLog(@"Codec, name: %s, description: %s, type: %@, encode: %d, decode: %d", codec->name, codec->long_name, typeString, encode, decode);
  } 
  
  AVOutputFormat *outputFormat = NULL;
  while ((outputFormat = av_oformat_next(outputFormat))) {
    FFDebug(@"Output format, name: %s, description: %s, mime-type: %s, extensions: %s", 
            outputFormat->name, outputFormat->long_name, outputFormat->mime_type, outputFormat->extensions);
  }
}

@end
