//
//  FFUtils.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#import "FFUtils.h"

NSString *const FFSourceErrorCodeKey = @"FFSourceErrorCodeKey";

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

AVFrame *FFPictureCreate(enum PixelFormat pixelFormat, int width, int height) {
  
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

void FFPictureRelease(AVFrame *picture) {
  if (picture != NULL)  {
    if (picture->data != NULL) av_free(picture->data[0]);
    av_free(picture);  
  }
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

AVRational FFFindRationalApproximation(float r, long maxden) {  

  long m[2][2];
  long ai;
  float x = r;
  
  // initialize matrix
  m[0][0] = m[1][1] = 1;
  m[0][1] = m[1][0] = 0;
  
  // loop finding terms until denom gets too big
  while (m[1][0] * (ai = (long)x ) + m[1][1] <= maxden) {
    long t;
    t = m[0][0] * ai + m[0][1];
    m[0][1] = m[0][0];
    m[0][0] = t;
    t = m[1][0] * ai + m[1][1];
    m[1][1] = m[1][0];
    m[1][0] = t;
    if (x == (double)ai) break;     // AF: division by zero
    x = 1/(x - (double) ai);
    if (x > (double)0x7FFFFFFF) break;  // AF: representation failure
  } 
  
  return (AVRational){m[0][0], m[1][0]};
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

+ (NSString *)resolvedPathForURL:(NSURL *)URL {  
  URL = [self resolvedURLForURL:URL];
  if ([URL isFileURL]) return [URL path];
  return [URL absoluteString];
}

+ (NSURL *)resolvedURLForURL:(NSURL *)URL {
  if ([[URL scheme] isEqualToString:@"bundle"]) {
    NSString *path = [URL host];
    NSString *pathInBundle = [[NSBundle mainBundle] pathForResource:[path stringByDeletingPathExtension] ofType:[path pathExtension]];
    if (!pathInBundle) {
      FFDebug(@"Path in bundle not found: %@", path);
      return nil;
    }
    return [NSURL fileURLWithPath:pathInBundle];
  }  
  return URL;  
}

@end
