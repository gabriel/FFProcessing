//
//  FFChromaKeyFilter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/14/10.
//  Copyright 2010 All rights reserved.
//

#import "FFChromaKeyFilter.h"
#import "FFUtils.h"

@implementation FFChromaKeyFilter

- (void)dealloc {
  if (_image) cvReleaseImage(&_image);
  [super dealloc];
}

- (FFVFrameRef)filterFrame:(FFVFrameRef)frame error:(NSError **)error {
  
  CvSize size = cvSize(frame->format.width, frame->format.height);
  if (!_image) _image = cvCreateImage(size, IPL_DEPTH_8U, 4);
  
  _image->imageData = (char *)frame->data[0];
  
  cvSmooth(_image, _image, CV_GAUSSIAN, 3, 0, 0, 0);
  
  int bytesPerRow = FFVFrameGetBytesPerRow(frame, 0);
  int bytesPerPixel = FFVFrameGetBytesPerPixel(frame, 0);  
  
  uint8_t tmin = 150;
  for (int x = 0; x < frame->format.width; x++) {
    for (int y = 0; y < frame->format.height; y++) {
      int p = (x * bytesPerPixel) + (y * bytesPerRow);
      if (x == 50 && y == 50)
        FFDebug(@"%d,%d,%d", (uint8_t)_image->imageData[p], (uint8_t)_image->imageData[p + 1], (uint8_t)_image->imageData[p + 2]);
      if ((uint8_t)_image->imageData[p] > tmin && 
          (uint8_t)_image->imageData[p + 1] > tmin &&
          (uint8_t)_image->imageData[p + 2] > tmin) {
        
        _image->imageData[p] = 0;
        _image->imageData[p + 1] = 0xFF;
        _image->imageData[p + 2] = 0;
        
      }
    }
  }
  
  return frame;
}

@end
