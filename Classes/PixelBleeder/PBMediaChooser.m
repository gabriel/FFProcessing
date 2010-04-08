//
//  PBMediaChooser.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "PBMediaChooser.h"

#import <MobileCoreServices/UTCoreTypes.h>

#import "PBUIItem.h"


@implementation PBMediaChooser

@synthesize delegate=_delegate;

- (void)dealloc {
  [_items release];
  [super dealloc];
}

- (NSArray *)mediaTypesForSourceType:(UIImagePickerControllerSourceType)sourceType {
  if (![UIImagePickerController isSourceTypeAvailable:sourceType]) return nil;
  
  NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
  NSMutableArray *mediaTypes = [NSMutableArray array];
  for (NSString *mediaType in availableMediaTypes) {
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) [mediaTypes addObject:mediaType];
  }
  return mediaTypes;
}
  

- (void)openSelectInView:(UIView *)view {
  
  [_items release];
  _items = [[NSMutableArray array] retain];
  
  for (NSNumber *sourceTypeNumber in [NSArray arrayWithObjects:
                                      [NSNumber numberWithUnsignedInteger:UIImagePickerControllerSourceTypeCamera],
                                      [NSNumber numberWithUnsignedInteger:UIImagePickerControllerSourceTypePhotoLibrary],
                                      [NSNumber numberWithUnsignedInteger:UIImagePickerControllerSourceTypeSavedPhotosAlbum],
                                      nil]) {
  
    NSArray *mediaTypes = [self mediaTypesForSourceType:[sourceTypeNumber unsignedIntegerValue]];    
    NSString *text = @"Unknown";
    switch ([sourceTypeNumber unsignedIntegerValue]) {
      case UIImagePickerControllerSourceTypeCamera: text = @"Camera"; break;
      case UIImagePickerControllerSourceTypePhotoLibrary: text = @"Library"; break;
      case UIImagePickerControllerSourceTypeSavedPhotosAlbum: text = @"Album"; break;
    }
    if ([mediaTypes count] > 0) [_items addObject:[PBUIItem text:text target:self action:@selector(openWithSourceType:) 
                                                         context:sourceTypeNumber]];
  }
  
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Media" delegate:self 
                                            cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil 
                                            otherButtonTitles:nil];
  
  for (PBUIItem *item in _items) {
    [sheet addButtonWithTitle:item.text];
  } 
  sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
  [sheet showInView:view];  
  [sheet autorelease];
}

- (void)openWithSourceType:(NSNumber *)sourceTypeNumber {
  PBMediaChooserController *videoController = [[PBMediaChooserController alloc] initWithSourceType:[sourceTypeNumber unsignedIntegerValue]
                                                                          mediaTypes:[self mediaTypesForSourceType:[sourceTypeNumber unsignedIntegerValue]]];
  videoController.delegate = self;
  [_delegate mediaChooser:self openViewController:videoController];
  [videoController release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSInteger index = (buttonIndex - 1);
  if (index >= 0 && index < [_items count])
    [[_items objectAtIndex:(buttonIndex-1)] perform];
}

#pragma mark Delegate (PBMediaChooserControllerDelegate)

- (void)videoController:(PBMediaChooserController *)videoController didSelectURL:(NSURL *)URL {
  [_delegate mediaChooser:self didSelectURL:URL];
}

@end
