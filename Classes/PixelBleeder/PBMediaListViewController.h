//
//  PBMediaListViewController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUITableViewController.h"

#import "PBMediaChooser.h"

@interface PBMediaListViewController : PBUITableViewController <PBMediaChooserDelegate> {
  PBMediaChooser *_mediaChooser;
}

- (void)addMediaItem:(NSURL *)URL;

- (NSArray *)mediaItems;

@end
