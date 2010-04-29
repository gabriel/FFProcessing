//
//  FFEdgeFilter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEdgeFilter.h"

#import "libavcodec/avcodec.h"
#import "FFUtils.h"

@implementation FFEdgeFilter

- (AVFrame *)filterFrame:(AVFrame *)frame decoder:(FFDecoder *)decoder {
  int x = 0;
  int y = 0;
  int width = decoder.options.width;
  int height = decoder.options.height;
  
  int index = 0;
  
  while (y < height) {
    int p = (x * 3) + (y * frame->linesize[index]);
    //FFDebug(@"p=%d", p);
    int8_t r = frame->data[index][p];
    int8_t g = frame->data[index][p + 1];
    int8_t b = frame->data[index][p + 2];
    
    frame->data[index][p] = r;
    frame->data[index][p + 1] = b;
    frame->data[index][p + 2] = g;
    
    x++;
    if (x >= width) {
      x = 0;
      y++;
    }
  }  
  return frame;
}

@end
