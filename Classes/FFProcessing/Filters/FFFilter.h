//
//  FFFilter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "libavcodec/avcodec.h"
#import "FFDecoder.h"

@protocol FFFilter <NSObject>
- (FFPictureFrame)filterPictureFrame:(FFPictureFrame)pictureFrame error:(NSError **)error;
@end

