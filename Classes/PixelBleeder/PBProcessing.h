//
//  PBProcessing.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessing.h"

@interface PBProcessing : NSObject <FFProcessingDelegate> {
  FFProcessing *_processing;
  NSString *_outputPath;
}

@property (retain, nonatomic) NSString *outputPath;  

- (void)processURLs:(NSArray *)URLs;

@end
