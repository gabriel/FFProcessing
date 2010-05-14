//
//  FFUtils.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#import "FFUtils.h"

#include "libavformat/avformat.h"

NSString *const FFMPEGErrorCodeKey = @"FFMPEGErrorCodeKey";

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

void FFFillYUVImage(FFVFrameRef frame, NSInteger frameIndex) {
  
  FFVFormat format = FFVFrameGetFormat(frame);

  uint8_t *data0 = FFVFrameGetData(frame, 0);
  int linesize0 = FFVFrameGetBytesPerRow(frame, 0);
  
  /* Y */
  for (int y = 0; y < format.height; y++) {
    for (int x = 0; x < format.width; x++) {
      data0[y * linesize0 + x] = x + y + frameIndex * 3;
    }
  }
  
  uint8_t *data1 = FFVFrameGetData(frame, 1);
  int linesize1 = FFVFrameGetBytesPerRow(frame, 1);

  uint8_t *data2 = FFVFrameGetData(frame, 2);
  int linesize2 = FFVFrameGetBytesPerRow(frame, 2);

  /* Cb and Cr */
  for (int y = 0; y < format.height/2.0; y++) {
    for (int x = 0; x < format.width/2.0; x++) {
      data1[y * linesize1 + x] = 128 + y + frameIndex * 2;
      data2[y * linesize2 + x] = 64 + x + frameIndex * 5;
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

double FFAngleRadians(double x, double y) {
  double xu, yu, ang;
  
  xu = fabs(x);
  yu = fabs(y);
  
  if ((xu == 0) && (yu == 0)) return(0);
  
  ang = atan(yu/xu);
  
  if(x >= 0){
    if(y >= 0) return(ang);
    else return(2*M_PI - ang);
  }
  else{
    if(y >= 0) return(M_PI - ang);
    else return(M_PI + ang);
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
