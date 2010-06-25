//
//  YKUITableViewController.h
//  YelpKit
//
//  Created by Gabriel Handford on 3/11/09.
//  Copyright 2009 Yelp. All rights reserved.
//

#import "YKUITableView.h"
#import "YKUITableViewDataSource.h"
#import "YPUIViewController.h"

typedef enum {
  YKUITableViewStatusModeController, // Status shows in view (on top of content view)
  YKUITableViewStatusModeTableView = 1, // Status shows in view (on top of table view)
  YKUITableViewStatusModeTableViewSection = 2, // Status shows in a section (0 by default)
  YKUITableViewStatusModeTableViewPaging = 3, // Status shows in view (on top of table view) with paging support
} YKUITableViewStatusMode;

@interface YKUITableViewController : YPUIViewController <YKUITableViewDelegate, UIScrollViewDelegate> {
    
  UITableViewStyle _style;
  YKUITableView *_tableView;
  
  BOOL _needsReloadData;
  
  id<YKUITableViewDataSource> _dataSource;
  BOOL _loadingNextPage;
  
  id<UIScrollViewDelegate> _scrollViewDelegate;
    
  YKUITableViewStatusMode _statusMode;
}

@property (retain, nonatomic) YKUITableView *tableView;
@property (assign, nonatomic) YKUITableViewStatusMode statusMode;

/*!
 Create table view controller with style.
 @param style
 */
- (id)initWithStyle:(UITableViewStyle)style;

- (id)initWithStyle:(UITableViewStyle)style dataSource:(id<YKUITableViewDataSource>)dataSource;

- (void)setDataSource:(id<YKUITableViewDataSource>)dataSource;

- (id<YKUITableViewDataSource>)dataSource;

/*!
 Clear data source, offset and reload data.
 */
- (void)clear;

//! Should load the next offset items. Subclasses must implement.
- (void)refreshPage;

//! Adds the next items button to the section returned by nextPageButtonSection if there are pages left to load.
- (void)addNextPageButton:(BOOL)animated;

//! The table view section to place the loadNextItemsButtion in.  Defaults to 1.
- (NSInteger)nextPageButtonSection;

/*!
 String to display on next items button for provided count. Defaults to "Next item" and "Next <count> items"
 */
- (NSString *)nextPageStringForCount:(NSInteger)count;

/*!
 If the data source's offset is nonzero, will load in the section returned by nextPageButtonSection,
 rather than covering the whole view
 */
- (void)enableLoadingWithPaging;

- (NSInteger)statusSection;

//! Reload data source.
- (void)reloadData;

//! Reload data only if needed.
- (void)reloadDataIfNeeded;

//! Set needs reload data; Will reloadData if visible.
- (void)setNeedsReloadData;

/*!
 Add cell data sources.
 */
- (void)addCellDataSources:(NSArray */*of id<YKUITableViewCellDataSource>*/)cellDataSources animated:(BOOL)animated;

/*!
 Load table view.
 Subclasses can override this method to provide their own table view implementation.
 */
- (void)loadTableView;

- (void)setScrollViewDelegate:(id<UIScrollViewDelegate>)scrollViewDelegate;

/*!
 Enable/disable refresh header.
 @param enabled
 */
- (void)setRefreshHeaderEnabled:(BOOL)enabled;

//! Check if refresh header enabled
- (BOOL)isRefreshHeaderEnabled;

@end
