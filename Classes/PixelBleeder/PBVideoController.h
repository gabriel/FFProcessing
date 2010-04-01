//
//  PBVideoController.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

@class PBVideoController;

@protocol PBVideoControllerDelegate <NSObject>
- (void)videoController:(PBVideoController *)videoController didSelectURL:(NSURL *)URL;
@end

@interface PBVideoController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  UIImagePickerController *_videoController;
  
  id<PBVideoControllerDelegate> _delegate; // Weak
}

@property (assign, nonatomic) id<PBVideoControllerDelegate> delegate;

@end
