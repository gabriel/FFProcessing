//
//  PBUITableViewController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "PBUITableViewController.h"

#import "PBUIItem.h"


@implementation PBUITableViewController

- (id)init {
  if ((self = [super init])) {
    _items = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc {
  [_items release];
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
}

- (void)addItem:(id<PBUIItem>)item {
  [_items addObject:item];
}

- (void)addItems:(NSArray *)items {
  [_items addObjectsFromArray:items];
}

- (void)setItems:(NSArray *)items {
  [_items removeAllObjects];
  [self addItems:items];
}

- (void)reloadData {
  [self.tableView reloadData];
}

#pragma mark DataSource (UITableViewDataSource)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if (!cell)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"] autorelease];    
  
  id<PBUIItem> item = [_items objectAtIndex:indexPath.row];  
  cell.textLabel.text = item.text;
  cell.accessoryType = item.accessoryType;
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
  return [_items count];
}

#pragma mark Delegate (UITableViewDelegate)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id<PBUIItem> item = [_items objectAtIndex:indexPath.row];
  [item perform];
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
