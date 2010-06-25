//
//  YKUITableViewDataSource.m
//  YelpKit
//
//  Created by Gabriel Handford on 5/28/09.
//  Copyright 2009 Yelp. All rights reserved.
//

#import "YKUITableViewDataSource.h"

#import "YKUITableView.h"
#import "YKCGUtils.h"
#import "YKDefines.h"
#import "YPUIStatusCell.h"

@implementation YKUITableViewDataSource

@synthesize identifier=_identifier, needsRefresh=_needsRefresh, totalCount=_totalCount, 
offset=_offset, limit=_limit, revision=_revision, sectionCount=_sectionCount,
statusEnabled=_statusEnabled, loading=_loading, editable=_editable,
alwaysShowHeadersEnabled=_alwaysShowHeadersEnabled, editingMoveEnabled=_editingMoveEnabled,
delegate=_delegate;

- (id)init {
  if ((self = [super init])) {
    _totalCount = -1;
    _limit = -1;  
    _sectionCount = 1;
    _statusSection = -2;
    _needsRefresh = YES;
  }
  return self;
}

- (id)initWithIdentifier:(NSString *)identifier sectionCount:(NSInteger)sectionCount {
  NSParameterAssert(sectionCount > 0);
  if ((self = [self init])) {
    _identifier = [identifier copy];
    _sectionCount = sectionCount;
  }
  return self;
}

- (void)dealloc {
  [_identifier release];
  [_cellDataSourceSections release];
  [_revision release];
  [_sectionHeaderTitles release];
  [_sectionHeaderViews release];
  [_sectionFooterViews release];
  [super dealloc];
}

+ (YKUITableViewDataSource *)dataSource {
  return [[[self alloc] init] autorelease];
}

+ (YKUITableViewDataSource *)dataSourceWithCellDataSources:(NSArray */*of id<YKUITableViewCellDataSource>*/)cellDataSources {
  YKUITableViewDataSource *dataSource = [self dataSource];
  [dataSource addCellDataSources:cellDataSources section:0 indexPaths:nil];
  return dataSource;
}

- (void)clearAll {
  self.offset = 0;
  [_cellDataSourceSections release];
  _cellDataSourceSections = nil;
}

- (NSMutableArray *)dataSourceForSection:(NSInteger)section create:(BOOL)create {
  if (!_cellDataSourceSections && create) _cellDataSourceSections = [[NSMutableDictionary alloc] init];
  
  NSMutableArray *dataSource = [_cellDataSourceSections objectForKey:[NSNumber numberWithInteger:section]];
  if (create && !dataSource) {
    dataSource = [NSMutableArray array];
    [_cellDataSourceSections setObject:dataSource forKey:[NSNumber numberWithInteger:section]];
  }
  return dataSource;
}

- (NSMutableArray *)cellDataSourcesForSection:(NSInteger)section {
  return [_cellDataSourceSections objectForKey:[NSNumber numberWithInteger:section]];
}

- (NSMutableArray *)dataSourceForSection:(NSInteger)section {
  return [self dataSourceForSection:section create:NO];
}

- (NSInteger)count:(NSInteger)section {
  return [[self dataSourceForSection:section] count];
}

- (id<YKUITableViewCellDataSource>)cellDataSourceAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *dataSource = [self dataSourceForSection:indexPath.section];
  if (dataSource && indexPath.row < [dataSource count])
    return [dataSource objectAtIndex:indexPath.row];
  return nil;
}

- (BOOL)removeCellDataSourceAtIndexPath:(NSIndexPath *)indexPath {
  if (!indexPath) { // nil index path will otherwise end up removing cell at section:0 row:0
    YPError(@"Asked to remove cell at nil index path");
    return NO;
  }
  YPDebug(@"Removing cell data source at: %@", indexPath);  
  return [self removeCellDataSourceForRow:indexPath.row inSection:indexPath.section];
}

- (BOOL)removeCellDataSourceForRow:(NSInteger)row inSection:(NSInteger)section {
  NSMutableArray *dataSource = [self dataSourceForSection:section];
  if (row < [dataSource count]) {
    [dataSource removeObjectAtIndex:row];
    return YES;
  }
  return NO;
}

- (UITableViewCell *)cellForTableView:(YKUITableView *)tableView indexPath:(NSIndexPath *)indexPath {
  id<YKUITableViewCellDataSource> cellDataSource = [self cellDataSourceAtIndexPath:indexPath];
  UITableViewCell *cell = [cellDataSource cellForTableView:tableView rowAtIndexPath:indexPath];
  return cell;
}

- (NSEnumerator *)enumeratorForCellDataSources {
  return [[[YKUITableViewDataSourceEnumerator alloc] initWithDataSource:self] autorelease];
}

- (void)insertCellDataSources:(NSArray */*of id<YKUITableViewCellDataSource>*/)array section:(NSInteger)section atIndex:(NSInteger)index indexPaths:(NSMutableArray **)indexPaths { 
  NSMutableArray *dataSource = [self dataSourceForSection:section create:YES];
  
  NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
  for(NSInteger i = 0; i < [array count]; i++) {
    [indexes addIndex:(i + index)];
    if (indexPaths) [*indexPaths addObject:[NSIndexPath indexPathForRow:(i + index) inSection:section]];
  }
  
  [dataSource insertObjects:array atIndexes:indexes];
  if (section >= _sectionCount) _sectionCount = section + 1;
}

- (void)insertCellDataSource:(id<YKUITableViewCellDataSource>)cellDataSource atIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *dataSource = [self dataSourceForSection:indexPath.section create:YES];
  [dataSource insertObject:cellDataSource atIndex:indexPath.row];
}

- (NSIndexPath *)addCellDataSource:(id<YKUITableViewCellDataSource>)cellDataSource section:(NSInteger)section {
  NSMutableArray *dataSource = [self dataSourceForSection:section create:YES];
  NSInteger previousCount = [dataSource count];
  [dataSource addObject:cellDataSource];
  if (section >= _sectionCount) _sectionCount = section + 1;
  return [NSIndexPath indexPathForRow:previousCount inSection:section];
}

- (void)addCellDataSources:(NSArray */*of id<YKUITableViewCellDataSource>*/)array section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths {
  YPDebug(@"Adding %d cell data sources in section: %d", [array count], section);
  NSMutableArray *dataSource = [self dataSourceForSection:section create:YES];
  NSInteger previousCount = [dataSource count];
  [dataSource addObjectsFromArray:array];
  if (section >= _sectionCount) _sectionCount = section + 1;

  if (indexPaths) {
    for(NSInteger i = 0; i < [array count]; i++) {
      [*indexPaths addObject:[NSIndexPath indexPathForRow:(i+previousCount) inSection:section]];
    }
  }
}

- (void)replaceCellDataSource:(id<YKUITableViewCellDataSource>)cellDataSource indexPath:(NSIndexPath *)indexPath {
  NSMutableArray *dataSource = [self dataSourceForSection:indexPath.section];
  if (indexPath.row < [dataSource count]) {
    [dataSource replaceObjectAtIndex:indexPath.row withObject:cellDataSource];
  } else YPError(@"Tried to remove invalid index path: %@", indexPath);
}

- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  id<YKUITableViewCellDataSource> cellDataSource = [[self cellDataSourceAtIndexPath:fromIndexPath] retain];
  [self removeCellDataSourceAtIndexPath:fromIndexPath];
  [self insertCellDataSource:cellDataSource atIndexPath:toIndexPath];
  [cellDataSource release];
}

- (void)setCellDataSources:(NSArray */*of id<YKUITableViewCellDataSource>*/)array section:(NSInteger)section {
  YPDebug(@"Setting %d cell data sources in section: %d", [array count], section);
  NSMutableArray *dataSource = [self dataSourceForSection:section create:YES];
  [dataSource setArray:array];
  if (section >= _sectionCount) _sectionCount = section + 1;
}

- (void)setHeaderTitle:(NSString *)title section:(NSInteger)section {
  _headersExist = YES;
  if (title) {
    if (!_sectionHeaderTitles) _sectionHeaderTitles = [[NSMutableDictionary alloc] init];
    [_sectionHeaderTitles setObject:title forKey:[NSNumber numberWithInteger:section]];
  } else {
    [_sectionHeaderTitles removeObjectForKey:[NSNumber numberWithInteger:section]];
  }
}

- (void)setHeaderView:(UIView *)view section:(NSInteger)section {
  _headersExist = YES;
  if (view) {
    if (!_sectionHeaderViews) _sectionHeaderViews = [[NSMutableDictionary alloc] init];
    [_sectionHeaderViews setObject:view forKey:[NSNumber numberWithInteger:section]];
  } else {
    [_sectionHeaderViews removeObjectForKey:[NSNumber numberWithInteger:section]];
  } 
}

- (void)setFooterView:(UIView *)view section:(NSInteger)section {
  if (view) {
    if (!_sectionFooterViews) _sectionFooterViews = [[NSMutableDictionary alloc] init];
    [_sectionFooterViews setObject:view forKey:[NSNumber numberWithInteger:section]];
  } else {
    [_sectionFooterViews removeObjectForKey:[NSNumber numberWithInteger:section]];
  } 
}

- (BOOL)hasHeaderForSection:(NSInteger)section {
  if (!_headersExist) return NO;
  if (_alwaysShowHeadersEnabled || [self count:section] > 0) 
    return ([_sectionHeaderTitles objectForKey:[NSNumber numberWithInteger:section]] != nil);
  return NO;  
}

- (void)clearSection:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths {
  YPDebug(@"Clearing section: %d", section);
  NSMutableArray *dataSource = [self dataSourceForSection:section];
  if (indexPaths) {
    for(NSInteger i = 0; i < [dataSource count]; i++) {
      [*indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
  }
  [dataSource removeAllObjects];
}

- (NSInteger)count {
  NSInteger count = 0;
  for(NSInteger i = 0; i < _sectionCount; i++) {
    count += [self count:i];
  }
  return count;
}

- (NSIndexPath *)lastIndexPath {
  NSInteger sectionIndex = [self sectionCount] - 1;
  while(sectionIndex >= 0) {
    NSInteger rowIndex = [self count:sectionIndex] - 1;
    if (rowIndex >= 0) {
      return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    }
    sectionIndex--;
  }
  return nil;
}

- (NSString *)description {
  return YKDescription(@"identifier", @"cellDataSourceSections", @"totalCount");
}

- (void)tableViewWillReloadData:(YKUITableView *)tableView { }

- (void)tableViewDidReloadData:(YKUITableView *)tableView { }

- (void)reload {
  // Subclasses could implement as:
  /*!
  [_delegate tableViewDataSource:self willReloadWithText:nil];
   // Do work here
  [_delegate tableViewDataSourceDidFinishReload:self];
   */
}

- (YPUIStatusCell *)_setStatus:(NSString *)message 
                   buttonTitle:(NSString *)buttonTitle buttonTarget:(id)buttonTarget buttonAction:(SEL)buttonAction
          alternateButtonTitle:(NSString *)alternateButtonTitle alternateButtonTarget:(id)alternateButtonTarget alternateButtonAction:(SEL)alternateButtonAction
                       section:(NSInteger)section height:(CGFloat)height {
  
  NSParameterAssert(section >= 0);

  _statusEnabled = YES;
  YPUIStatusCell *statusCell = [[YPUIStatusCell alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
  statusCell.text = message;
  
  if (buttonTitle && alternateButtonTitle) {
    [statusCell setButtonWithTitle:buttonTitle target:buttonTarget action:buttonAction];
    [statusCell setAlternateButtonWithTitle:alternateButtonTitle target:alternateButtonTarget action:alternateButtonAction];
  } else if (buttonTitle) {
    [statusCell setButtonWithTitle:buttonTitle target:buttonTarget action:buttonAction];
  }

  [self setCellDataSources:[NSArray arrayWithObject:statusCell] section:section];

  [statusCell release]; 
  return statusCell;
}

- (YPUIStatusCell *)_setStatus:(NSString *)message section:(NSInteger)section height:(CGFloat)height {
  return [self _setStatus:message buttonTitle:nil buttonTarget:nil buttonAction:NULL
     alternateButtonTitle:nil alternateButtonTarget:nil alternateButtonAction:NULL
                  section:section height:height];
}

- (CGSize)sizeThatFitsInTableView:(YKUITableView *)tableView section:(NSInteger)section {
  CGSize size = tableView.frame.size;
  if (size.height == 0) size.height = 367;
  
  CGSize headerSize = tableView.tableView.tableHeaderView.frame.size;
  size.height -= headerSize.height;

  if (section == 1)
    size.height -= [tableView heightForSection:(section-1)];

  return size;
}

#pragma mark Status 

- (void)setMessage:(NSString *)message section:(NSInteger)section height:(CGFloat)height {
  [self _setStatus:message section:section height:height];
}

- (void)setMessage:(NSString *)message 
       buttonTitle:(NSString *)buttonTitle buttonTarget:(id)buttonTarget buttonAction:(SEL)buttonAction
  alternateButtonTitle:(NSString *)alternateButtonTitle alternateButtonTarget:(id)alternateButtonTarget alternateButtonAction:(SEL)alternateButtonAction
           section:(NSInteger)section height:(CGFloat)height {

  [self _setStatus:message buttonTitle:buttonTitle buttonTarget:buttonTarget buttonAction:buttonAction 
alternateButtonTitle:alternateButtonTitle alternateButtonTarget:alternateButtonTarget alternateButtonAction:alternateButtonAction
           section:section height:height];
}

- (void)setLoading:(BOOL)loading section:(NSInteger)section height:(CGFloat)height {
  [self setLoading:loading message:nil section:section height:height];
}

- (void)setLoading:(BOOL)loading message:(NSString *)message section:(NSInteger)section height:(CGFloat)height {  
  _loading = loading;
  _statusEnabled = loading;
  _statusSection = section;

  if (loading) {
    YPUIStatusCell *statusCell = [self _setStatus:nil section:section height:height];
    [statusCell setLoading:loading message:message];
  } else {
    [self clearSection:section indexPaths:nil];
  }
}

- (void)setError:(YKError *)error section:(NSInteger)section height:(CGFloat)height {
  [self setMessage:[error localizedDescription] section:section height:height];
}

#pragma mark Checked Cells (YKUITableViewCellDataSource)

- (id)onContextInSection:(NSInteger)section {
  for (id cellDataSource in [self cellDataSourcesForSection:section]) {
    if ([cellDataSource isKindOfClass:[YKUITableViewCellDataSource class]] 
        && [cellDataSource isOn]) return [cellDataSource context];
  }
  return nil;
}

- (void)setOn:(BOOL)on forContext:(id)context inSection:(NSInteger)section {
  for (id cellDataSource in [self cellDataSourcesForSection:section]) {
    if ([cellDataSource isKindOfClass:[YKUITableViewCellDataSource class]])
      [cellDataSource setOn:(on && context && [[cellDataSource context] isEqual:context])];
  } 
}

#pragma mark Delegates (YKUITableViewDataSource)

- (UITableViewCell *)tableView:(YKUITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self cellForTableView:tableView indexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(YKUITableView *)tableView {
  return [self sectionCount];
}

- (NSInteger)tableView:(YKUITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self dataSourceForSection:section] count];
}

- (CGFloat)tableView:(YKUITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  id<YKUITableViewCellDataSource> cellDataSource = [self cellDataSourceAtIndexPath:indexPath];
  if ([cellDataSource respondsToSelector:@selector(sizeThatFits:tableView:rowAtIndexPath:)]) {
    return [cellDataSource sizeThatFits:CGSizeMake(320, 0) tableView:tableView rowAtIndexPath:indexPath].height;
  }

  CGFloat height = [cellDataSource sizeThatFits:CGSizeMake(320, 0)].height;
  if (height <= 0) YPWarn(@"No height for cell data source at index path: %@", indexPath);
  return height;
}

- (NSIndexPath *)tableView:(YKUITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath;
}

- (NSString *)tableView:(YKUITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (!_headersExist) return nil;
  // Only show title if we have cells
  if (!_alwaysShowHeadersEnabled && [self count:section] == 0) return nil;
  
  return [_sectionHeaderTitles objectForKey:[NSNumber numberWithInteger:section]];
}

- (UIView *)tableView:(YKUITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (!_headersExist) return nil;
  // Only show view if we have cells
  if (!_alwaysShowHeadersEnabled && [self count:section] == 0) return nil;
  
  NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
  if (!sectionTitle) return nil;
  
  UIView *sectionHeaderView = [_sectionHeaderViews objectForKey:[NSNumber numberWithInteger:section]];  
  // TODO(gabe): We should assert this
  // NSAssert([sectionHeaderView respondsToSelector:@selector(setText:)], @"Header views must respond to setText:");
  if ([sectionHeaderView respondsToSelector:@selector(setText:)])       
    [(id)sectionHeaderView setText:sectionTitle];
  return sectionHeaderView;
}

- (CGFloat)tableView:(YKUITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (!_headersExist) return 0.0;
  return [self tableView:tableView viewForHeaderInSection:section].frame.size.height;
}

- (UIView *)tableView:(YKUITableView *)tableView viewForFooterInSection:(NSInteger)section {
  // Only show view if we have cells
  if ([self count:section] == 0) return nil;
  
  return [_sectionFooterViews objectForKey:[NSNumber numberWithInteger:section]]; 
}

- (CGFloat)tableView:(YKUITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return [self tableView:tableView viewForFooterInSection:section].frame.size.height;
}

- (void)tableView:(YKUITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView.tableView endEditing:YES];
  
  if (editingStyle == UITableViewCellEditingStyleDelete && indexPath) {
    [self removeCellDataSourceAtIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
  }
}   

@end


@implementation YKUITableViewDataSourceEnumerator 

- (id)initWithDataSource:(YKUITableViewDataSource *)dataSource {
  if ((self = [super init])) {
    _dataSource = [dataSource retain];
    _section = 0;
    _index = 0;
  }
  return self;
}

- (void)dealloc {
  [_dataSource release];
  [super dealloc];
}

- (id)nextObject {
  if (_section >= [_dataSource sectionCount]) return nil;
  NSArray *cellDataSources = [_dataSource cellDataSourcesForSection:_section];
  if (_index >= [cellDataSources count]) {
    _index = 0;
    _section++;
    return [self nextObject];
  }
  return [cellDataSources objectAtIndex:_index++];
}

@end
