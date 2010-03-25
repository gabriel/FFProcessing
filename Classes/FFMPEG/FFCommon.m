//
//  FFCommon.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFCommon.h"

static AVPacket gFlushPacket;

void FFInitialize(void) {
  av_register_all();
  
  av_init_packet(&gFlushPacket);
  gFlushPacket.data = (uint8_t*)"FLUSH";
}

BOOL FFIsFlushPacket(AVPacket *packet) {
  return (packet->data == gFlushPacket.data);
}

AVFrame *FFCreatePicture(enum PixelFormat pixelFormat, int width, int height) {
  
  AVFrame *picture = avcodec_alloc_frame();
  if (!picture) return NULL;
  
  int size = avpicture_get_size(pixelFormat, width, height);
  uint8_t *pictureBuffer = av_malloc(size);
  
  if (!pictureBuffer) {
    av_free(picture);
    return NULL;
  }
  
  avpicture_fill((AVPicture *)picture, pictureBuffer, pixelFormat, width, height);
  return picture;
}

void FFFillYUVImage(AVFrame *picture, NSInteger frameIndex, int width, int height) {
  
  /* Y */
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      picture->data[0][y * picture->linesize[0] + x] = x + y + frameIndex * 3;
    }
  }
  
  /* Cb and Cr */
  for (int y = 0; y < height/2; y++) {
    for (int x = 0; x < width/2; x++) {
      picture->data[1][y * picture->linesize[1] + x] = 128 + y + frameIndex * 2;
      picture->data[2][y * picture->linesize[2] + x] = 64 + x + frameIndex * 5;
    }
  }  
}

@implementation FFCommon

+ (NSString *)documentsDirectory {	
	static NSString *DocumentsDirectory = NULL;
  if (DocumentsDirectory == NULL) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocumentsDirectory = [[paths objectAtIndex:0] copy];
	}
	return DocumentsDirectory;
}

@end
