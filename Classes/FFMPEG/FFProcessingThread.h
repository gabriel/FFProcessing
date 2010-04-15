//
//  FFProcessingThread.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/15/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessingQueue.h"

@interface FFProcessingThread : NSThread {
  FFProcessingQueue *_processingQueue;
  
}

- (id)initWithProcessingQueue:(FFProcessingQueue *)processingQueue;

@end
