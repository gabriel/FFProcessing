//
//  PBProcessing.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//


@interface PBProcessing : NSObject {

}

- (void)processURL:(NSURL *)URL outputPath:(NSString *)outputPath outputFormat:(NSString *)outputFormat outputCodecName:(NSString *)outputCodecName;

@end
