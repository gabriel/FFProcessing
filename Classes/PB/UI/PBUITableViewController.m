//
//  PBUITableViewController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUITableViewController.h"

#import "PBUIItem.h"


@implementation PBUITableViewController

@synthesize container=_container;

- (id)init {
  if ((self = [super init])) {
    _items = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc {
  [_items release];
  [_container release];
  [_tableView release];
  [super dealloc];
}

- (void)loadView {
  [_container release];
  _container = [[PBUIContainer alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
  
  [_tableView release];
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_container setContentView:_tableView];
  self.view = _container;
}

- (PBUIContainer *)container {
  self.view;
  return _container;
}

- (UITableView *)tableView {
  self.view;
  return _tableView;
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

- (void)moveItemAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex {
  id item = [[_items objectAtIndex:index] retain];
  [_items removeObjectAtIndex:index];
  [_items insertObject:item atIndex:toIndex];
  [item release];
}

- (void)removeItemAtIndex:(NSInteger)index {
  [_items removeObjectAtIndex:index];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  if (!editing) {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                            target:self action:@selector(toggleEditing)] autorelease];
    [self.tableView setEditing:NO animated:animated];
  } else if (editing) {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self action:@selector(toggleEditing)] autorelease];
    [self.tableView setEditing:YES animated:animated];
  }
}

- (BOOL)isEditing {
  return self.tableView.isEditing;
}

- (void)toggleEditing {
  [self setEditing:![self isEditing] animated:YES];
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
