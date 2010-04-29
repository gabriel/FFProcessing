//
//  PBSaveThread.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/22/10.
//  Copyright 2010. All rights reserved.
//

@class PBSaveThread;

@protocol PBSaveThreadDelegate <NSObject>
- (void)saveThread:(PBSaveThread *)saveThread didFinishSavingWithError:(NSError *)error;
@end

@interface PBSaveThread : NSThread {
  NSString *_path;
  id<PBSaveThreadDelegate> _delegate;
}

@property (assign, nonatomic) NSString *path;
@property (assign, nonatomic) id<PBSaveThreadDelegate> delegate;


@end
