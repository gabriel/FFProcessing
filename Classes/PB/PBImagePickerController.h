//
//  PBImagePickerController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

@class PBImagePickerController;

@protocol PBImagePickerControllerDelegate <NSObject>
- (void)imageController:(PBImagePickerController *)imageController didSelectURL:(NSURL *)URL;
@end

@interface PBImagePickerController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  UIImagePickerController *_imageController;
  
  UIImagePickerControllerSourceType _sourceType;
  NSArray *_mediaTypes;
  
  id<PBImagePickerControllerDelegate> _delegate; // Weak
}

@property (assign, nonatomic) id<PBImagePickerControllerDelegate> delegate;
@property (retain, nonatomic) NSArray *mediaTypes;
@property (readonly, nonatomic) UIImagePickerController *imageController;

- (id)initWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray *)mediaTypes;

@end
