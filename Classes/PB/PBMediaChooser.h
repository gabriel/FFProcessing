//
//  PBMediaChooser.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010. All rights reserved.
//

#import "PBMediaChooserController.h"

@class PBMediaChooser;

@protocol PBMediaChooserDelegate <NSObject>
- (void)mediaChooser:(PBMediaChooser *)mediaChooser openViewController:(UIViewController *)viewController;
- (void)mediaChooser:(PBMediaChooser *)mediaChooser didSelectURL:(NSURL *)URL;
@end

@interface PBMediaChooser : NSObject <PBMediaChooserControllerDelegate, UIActionSheetDelegate> {
  
  NSMutableArray *_items;
  
  id<PBMediaChooserDelegate> _delegate;
}

@property (assign, nonatomic) id<PBMediaChooserDelegate> delegate; // Weak

- (void)openSelectInView:(UIView *)view;


@end
