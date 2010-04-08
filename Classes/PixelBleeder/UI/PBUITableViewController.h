//
//  PBUITableViewController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "PBUIItem.h"

@interface PBUITableViewController : UITableViewController {
  NSMutableArray *_items;
}

- (void)addItem:(id<PBUIItem>)item;
- (void)addItems:(NSArray *)items;
- (void)setItems:(NSArray *)items;

- (void)reloadData;

@end
