//
//  YKUITableViewController.m
//  YelpKit
//
//  Created by Gabriel Handford on 3/11/09.
//  Copyright 2009 Yelp. All rights reserved.
//

#import "YKUITableViewController.h"
#import "YPPaginateView.h"
#import "YKDefines.h"
#import "UITableViewAdditions.h"
#import "YKLocalized.h"

@implementation YKUITableViewController

@synthesize tableView=_tableView, statusMode=_statusMode;

- (id)init {
  return [self initWithStyle:UITableViewStylePlain];
}

- (id)initWithStyle:(UITableViewStyle)style {
  return [self initWithStyle:style dataSource:nil];
}

- (id)initWithStyle:(UITableViewStyle)style dataSource:(id<YKUITableViewDataSource>)dataSource {
  if ((self = [super init])) {
    _style = style;
    _dataSource = [dataSource retain];
  }
  return self;
}

- (void)dealloc {
  [_dataSource release];
  _tableView.scrollViewDelegate = nil;
  _tableView.delegate = nil;
  [_tableView release];
  [super dealloc];
}

- (void)loadView {
  [super loadView]; 
  self.tableView;
}

- (void)viewDidUnload {  
  _tableView.scrollViewDelegate = nil;
  _tableView.delegate = nil;
  [_tableView release];
  _tableView = nil;
  [super viewDidUnload];
}

- (void)clear {
  self.dataSource.offset = 0;
  [self.dataSource clearAll];
  [self scrollToTop:NO];
  [self.tableView reloadData];  
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:animated];
}

- (void)refresh {
  // If dataSource is paging
  if (self.dataSource.limit > 0) {
    [self clear];
    [self refreshPage];
  }
}

- (void)refreshIfNeeded {
  if ([self.dataSource needsRefresh]) [self refresh];
}

- (void)setNeedsRefresh:(BOOL)refresh {
  self.dataSource.needsRefresh = refresh;
}

- (BOOL)needsRefresh {
  return self.dataSource.needsRefresh;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self reloadDataIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self reloadDataIfNeeded];
}

- (void)loadTableView {
  YKUITableView *tableView = [[YKUITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:_style];
  tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  tableView.delegate = self;  
  if (_dataSource) {
    tableView.dataSource = _dataSource;
  }
  self.tableView = tableView;
  [tableView release];
}

- (void)setTableView:(YKUITableView *)tableView {
  [tableView retain];
  [_tableView release];
  _tableView = tableView;
  _tableView.scrollViewDelegate = self;
  [self setContentView:_tableView];
}

- (YKUITableView *)tableView {
  if (!_tableView) [self loadTableView];
  return _tableView;
}

- (void)setDataSource:(id<YKUITableViewDataSource>)dataSource {
  [dataSource retain];
  [_dataSource release];
  _dataSource = dataSource;
  _tableView.dataSource = dataSource;
}

- (id<YKUITableViewDataSource>)dataSource {  
  return _dataSource;
}

- (void)reloadData {
  self.view;
  NSAssert(_dataSource, @"Subclasses must set a valid YKUITableViewDataSource");
  _needsReloadData = NO;
  [_tableView reloadData];
}

- (void)reloadDataIfNeeded {
  if (!_dataSource) {
    return; // If no data source then we are not ready to reload data
  }
  YPDebug(@"reloadDataIfNeeded: %d", _needsReloadData);
  if (_needsReloadData) [self reloadData];
}

- (void)didLoadViewWithProgress {
  [super didLoadViewWithProgress];
  [self reloadDataIfNeeded];
}

- (void)setNeedsReloadData {
  _needsReloadData = YES;
  if (self.isVisible) {
    [self reloadData];
  }
}

#pragma mark Status

// Override
- (void)enableLoadingWithMessage:(NSString *)message {
  // Ignore loading if refresh header view is showing loading
  if (self.tableView.refreshHeaderView.state == YPUIPullRefreshLoading) return;
  
  switch (_statusMode) {
    case YKUITableViewStatusModeController:
      [self scrollToTop:NO];
      [super enableLoadingWithMessage:message];
      break;      
    case YKUITableViewStatusModeTableView:
      [super disableLoading];
      [_tableView enableLoadingWithMessage:message];
      break;
    case YKUITableViewStatusModeTableViewPaging:
      [super disableLoading];
      if (self.dataSource.offset > 0) {
        _loadingNextPage = YES;
        [_tableView enableLoadingWithMessage:nil section:[self nextPageButtonSection]
                                      height:70 resetPosition:NO disableScroll:NO disableSelection:NO];
      } else {
        [_tableView enableLoadingWithMessage:message section:0 height:0 resetPosition:NO disableScroll:NO disableSelection:NO];
      }      
      break;
    case YKUITableViewStatusModeTableViewSection:
      [super disableLoading];
      [_tableView enableLoadingWithMessage:message section:[self statusSection] height:0 resetPosition:NO disableScroll:NO disableSelection:NO];
      break;
  }
}

- (NSInteger)statusSection {
  return 0;
}

// Override
- (void)setMessage:(NSString *)message title:(NSString *)title target:(id)target action:(SEL)action {
  switch (_statusMode) {
    case YKUITableViewStatusModeController:
      [super setMessage:message title:title target:target action:action];
      break;  
    case YKUITableViewStatusModeTableView:
      [super disableLoading];
      [_tableView setMessage:message title:title target:target action:action];
      break;      
    case YKUITableViewStatusModeTableViewSection:
    case YKUITableViewStatusModeTableViewPaging:
      [super disableLoading];
      [_tableView setMessage:message section:[self statusSection] height:0 resetPosition:NO disableScroll:NO title:title target:target action:action];
      break;
  }
}

// Override
- (void)disableLoading {
  switch (_statusMode) {
    case YKUITableViewStatusModeController:
      if (_loadingNextPage) {
        [_tableView disableLoadingInSection:[self nextPageButtonSection] reloadData:YES];
        _loadingNextPage = NO;
      } else {
        [_tableView disableLoadingWithReloadData:NO];
        [super disableLoading];
      }
      break;
    case YKUITableViewStatusModeTableView:
      [_tableView disableLoadingWithReloadData:YES];
      [super disableLoading];
      break; 
    case YKUITableViewStatusModeTableViewSection:
      [_tableView disableLoadingInSection:[self statusSection] reloadData:YES];
      [super disableLoading];
      break;      
    case YKUITableViewStatusModeTableViewPaging:
      if (_loadingNextPage) {
        [_tableView disableLoadingInSection:[self nextPageButtonSection] reloadData:YES];
        _loadingNextPage = NO;
      } else {
        [_tableView disableLoadingInSection:[self statusSection] reloadData:NO];
        [_tableView disableLoadingInSection:[self nextPageButtonSection] reloadData:NO];
        [self reloadData];
      }
      [super disableLoading];
      break;
  }
}

// Override
- (BOOL)isLoading {
  switch (_statusMode) {
    case YKUITableViewStatusModeController:
      return [super isLoading]; 
    case YKUITableViewStatusModeTableView:
    case YKUITableViewStatusModeTableViewPaging:
    case YKUITableViewStatusModeTableViewSection:
      return [self.tableView isLoading];
  }
  return NO;
}

#pragma mark -

// Override
- (void)scrollToTop:(BOOL)animated {
  if ([self isRefreshHeaderEnabled] && _tableView.refreshHeaderView.state == YPUIPullRefreshLoading && !_tableView.refreshHeaderView.isMomentary) {
    [_tableView.tableView setContentOffset:CGPointMake(0, -_tableView.refreshHeaderView.pullHeight)];
  } else {
    [_tableView scrollToTop:animated];
  }
}

- (void)setScrollViewDelegate:(id<UIScrollViewDelegate>)scrollViewDelegate {
  _scrollViewDelegate = scrollViewDelegate;
  _tableView.scrollViewDelegate = self; // Will forward delegate calls to _scrollViewDelegate
}

- (void)reset {
  [self scrollToTop:NO];
}

#pragma mark Paging

- (void)refreshPage {
  [NSException raise:NSDestinationInvalidException 
              format:@"Must implement refreshPage in subclasses of YKUITableViewController"];
}

- (void)addNextPageButton:(BOOL)animated {
  NSInteger nextCount = (self.dataSource.totalCount - self.dataSource.offset);
  YPDebug(@"Next count: %d", nextCount);
  if (nextCount > 0) {
    YPPaginateView *paginateView = [[YPPaginateView alloc] initWithFrame:CGRectMake(0, 0, 320, 70) 
                                                                  target:self 
                                                              nextAction:@selector(refreshPage)
                                                          previousAction:NULL
                                                                  offset:0
                                                                   limit:self.dataSource.limit
                                                                   count:self.dataSource.offset
                                                                   total:self.dataSource.totalCount];
    paginateView.nextButton.title = [self nextPageStringForCount:paginateView.nextPageSize];
    [self.tableView setCellDataSources:[NSArray arrayWithObject:paginateView] section:[self nextPageButtonSection] animated:animated];
    [paginateView release];
  } else {
    [self.tableView setCellDataSources:nil section:[self nextPageButtonSection] animated:animated];    
  }
}

- (void)addCellDataSources:(NSArray *)cellDataSources animated:(BOOL)animated {
  self.dataSource.offset += [cellDataSources count];
  if (animated) {
    [self.tableView beginUpdates];
    [self.tableView addCellDataSources:cellDataSources section:0 withRowAnimation:UITableViewRowAnimationBottom];
    [self addNextPageButton:YES];
    [self.tableView endUpdates];    
  } else {
    // TODO(johnb): Should disableLoading be here?
    [self disableLoading];
    [self.tableView addCellDataSources:cellDataSources section:0 withRowAnimation:UITableViewRowAnimationNone];
    [self addNextPageButton:NO];
    [self reloadData];
  }
}  

- (NSString *)nextPageStringForCount:(NSInteger)count {
  return YKLocalizedCount(@"Next Item", @"Load Next %d Items", count);
}

- (NSInteger)nextPageButtonSection {
  return 1;
}

- (void)enableLoadingWithPaging {
  if (self.dataSource.offset > 0) {
    _loadingNextPage = YES;
    [self.tableView enableLoadingWithMessage:nil section:[self nextPageButtonSection]
                                      height:70 resetPosition:NO disableScroll:NO disableSelection:NO];
  } else {
    [self enableLoading];
  }
}

#pragma mark Refresh

- (void)setRefreshHeaderEnabled:(BOOL)enabled {
  [self.tableView setRefreshHeaderEnabled:enabled];
}

- (BOOL)isRefreshHeaderEnabled {
  return [self.tableView isRefreshHeaderEnabled];
}

- (void)setRefreshing:(BOOL)refreshing {
  [super setRefreshing:refreshing];
  
  // Ensure refresh header is loading;
  // If we are momentary then ensure we aren't expanded
  [self.tableView.refreshHeaderView setState:(refreshing ? YPUIPullRefreshLoading : YPUIPullRefreshNormal)];
  if (self.tableView.refreshHeaderView.momentary) {
    [self.tableView expandRefreshHeaderView:NO];
  } else {    
    [self.tableView expandRefreshHeaderView:(refreshing && ![self isLoading])];
  }

}

#pragma mark Delegates (YKUITableView)

- (void)tableView:(YKUITableView *)tableView didSelectCellDataSource:(id<YKUITableViewCellDataSource>)cellDataSource indexPath:(NSIndexPath *)indexPath { 
  
}

- (void)tableView:(YKUITableView *)tableView didSelectAccessoryCellDataSource:(id<YKUITableViewCellDataSource>)cellDataSource indexPath:(NSIndexPath *)indexPath {
  
}

- (void)tableView:(YKUITableView *)tableView didMoveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  
}

#pragma mark Delegates (UIScrollView) 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (self.tableView.refreshHeaderView && scrollView.isDragging) {    
    if (self.tableView.refreshHeaderView.state == YPUIPullRefreshPulling && 
        scrollView.contentOffset.y > -(self.tableView.refreshHeaderView.pullHeight + 5) && 
        scrollView.contentOffset.y < 0) {
      
      [self.tableView.refreshHeaderView setState:YPUIPullRefreshNormal];
    } else if (self.tableView.refreshHeaderView.state == YPUIPullRefreshNormal && scrollView.contentOffset.y < -(self.tableView.refreshHeaderView.pullHeight + 5)) {
      [self.tableView.refreshHeaderView setState:YPUIPullRefreshPulling];
    }    
  }
  [self.tableView.refreshHeaderView setPullAmount:-scrollView.contentOffset.y];
  
  if ([_scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    [_scrollViewDelegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if ([_scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    [_scrollViewDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {  
  if (self.tableView.refreshHeaderView && scrollView.contentOffset.y <= -(self.tableView.refreshHeaderView.pullHeight + 5) && 
      self.tableView.refreshHeaderView.state != YPUIPullRefreshLoading) {
    self.refreshing = YES;
    [self refresh];
  } else {
    [self.tableView.refreshHeaderView setPullAmount:0];
  }
  
  if ([_scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    [_scrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  if ([_scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    [_scrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if ([_scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    [_scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  if ([_scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
    [_scrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
}


@end
