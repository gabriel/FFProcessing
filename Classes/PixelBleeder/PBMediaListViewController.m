//
//  PBMediaListViewController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010. All rights reserved.
//

#import "PBMediaListViewController.h"


@implementation PBMediaListViewController

- (id)init {
  if ((self = [super init])) {
    self.title = @"Media";    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_add)];  
  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  [toolbar setTintColor:[UIColor blackColor]];
  [toolbar setItems:[NSArray arrayWithObjects:addItem, nil] animated:NO];
  [addItem release];    
  [self.container setFooterView:toolbar];
  [toolbar release];
  
  [self setEditing:NO animated:NO];
}

- (void)_add {
  if (!_mediaChooser) {
    _mediaChooser = [[PBMediaChooser alloc] init];
    _mediaChooser.delegate = self;
  }
  [_mediaChooser openSelectInView:self.view.window];  
}

- (void)_select:(id)context {
  
}

- (void)addMediaItem:(NSURL *)URL {
  NSString *text = [[URL path] lastPathComponent];
  [self addItem:[PBUIItem text:text target:self action:@selector(_select:) context:URL]];
}

- (NSArray *)mediaItems {
  NSMutableArray *mediaList = [NSMutableArray arrayWithCapacity:[_items count]];
  for (id<PBUIItem> item in _items) {
    [mediaList addObject:item.context];
  }
  return mediaList;
}

#pragma mark Delegates (PBMediaChooser)

- (void)mediaChooser:(PBMediaChooser *)mediaChooser openViewController:(UIViewController *)viewController {
  [self.navigationController pushViewController:viewController animated:YES];
}

- (void)mediaChooser:(PBMediaChooser *)mediaChooser didSelectURL:(NSURL *)URL {
  [self addMediaItem:URL];
  [self reloadData];
  [self.navigationController popToViewController:self animated:YES];  
}

#pragma mark Data Source (UITableViewDataSource) 

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  [self moveItemAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self removeItemAtIndex:indexPath.row];
  }
}

@end
