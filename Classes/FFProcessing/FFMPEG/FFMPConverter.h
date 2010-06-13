//
//  FFMPConverter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"
#import "FFFilter.h"

@interface FFMPConverter : NSObject <FFFilter> {
  FFVFormat _format;
  FFVFrameRef _frame;
}

/*!
 Converter with format (output).
 @param format Format; If width, height, or pixelFormat are set to 0, then will use the source format for that parameter
 */
- (id)initWithFormat:(FFVFormat)format;

- (FFVFrameRef)scaleFrame:(FFVFrameRef)frame error:(NSError **)error;

@end
