//
//  PBMediaChooserController.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

@class PBMediaChooserController;

@protocol PBMediaChooserControllerDelegate <NSObject>
- (void)videoController:(PBMediaChooserController *)videoController didSelectURL:(NSURL *)URL;
@end

@interface PBMediaChooserController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  UIImagePickerController *_videoController;
  
  UIImagePickerControllerSourceType _sourceType;
  NSArray *_mediaTypes;
  
  id<PBMediaChooserControllerDelegate> _delegate; // Weak
}

@property (assign, nonatomic) id<PBMediaChooserControllerDelegate> delegate;
@property (retain, nonatomic) NSArray *mediaTypes;

- (id)initWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray *)mediaTypes;

@end
