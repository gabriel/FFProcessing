//
//  FFUtils.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#import "FFUtils.h"

static AVPacket gFlushPacket;
static BOOL gInitialized = NO;

void FFInitialize(void) {
  if (FFIsInitialized()) return;
  gInitialized = YES;
  av_register_all();
  
  av_init_packet(&gFlushPacket);
  gFlushPacket.data = (uint8_t *)"FLUSH";
}

BOOL FFIsInitialized(void) {
  return gInitialized;
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

void FFReleasePicture(AVFrame *picture) {
  if (picture->data != NULL) av_free(picture->data[0]);
  if (picture != NULL) av_free(picture);  
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

@implementation FFUtils

+ (NSString *)documentsDirectory {	
	static NSString *DocumentsDirectory = NULL;
  if (DocumentsDirectory == NULL) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DocumentsDirectory = [[paths objectAtIndex:0] copy];
	}
	return DocumentsDirectory;
}

+ (NSString *)resolvePathForURL:(NSURL *)URL {  
  if ([[URL scheme] isEqualToString:@"bundle"]) {
    NSString *path = [URL host];
    return [[NSBundle mainBundle] pathForResource:[path stringByDeletingPathExtension] ofType:[path pathExtension]];
  }  
  if ([URL isFileURL]) return [URL path];
  return [URL absoluteString];
}

@end
