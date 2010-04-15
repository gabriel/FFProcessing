//
//  PBUITableViewController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUIItem.h"
#import "PBUIContainer.h"

@interface PBUITableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  NSMutableArray *_items;
  
  PBUIContainer *_container;
  UITableView *_tableView;
}

@property (readonly, nonatomic) PBUIContainer *container;
@property (readonly, nonatomic) UITableView *tableView;

- (void)addItem:(id<PBUIItem>)item;
- (void)addItems:(NSArray *)items;
- (void)setItems:(NSArray *)items;
- (void)moveItemAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex;
- (void)removeItemAtIndex:(NSInteger)index;

- (void)reloadData;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
- (BOOL)isEditing;
- (void)toggleEditing;

- (void)reloadData;

@end
