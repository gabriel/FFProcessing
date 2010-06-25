//
//  YKUITableViewDataSource.h
//  YelpKit
//
//  Created by Gabriel Handford on 5/28/09.
//  Copyright 2009 Yelp. All rights reserved.
//

#import "YKUITableViewCell.h"
#import "YKUIView.h"
#import "YKError.h"

@class YKUITableView;

/*!
 YKUITableView data source protocol.
 Usually contains a list of cell data sources (conforming to the YKUITableViewCellDataSource protocol>
 */
@protocol YKUITableViewDataSource <NSObject>

@property (assign, nonatomic, getter=isEditable) BOOL editable;
@property (readonly, nonatomic) NSInteger sectionCount;

@property (assign, nonatomic) NSInteger offset;
@property (assign, nonatomic) NSInteger limit;
@property (assign, nonatomic) NSInteger totalCount;
@property (readonly, nonatomic, getter=isLoading) BOOL loading;
@property (assign, nonatomic) BOOL needsRefresh;
@property (assign, nonatomic, getter=isEditingMoveEnabled) BOOL editingMoveEnabled; // If YES, will show ordering on edit; Defaults to NO


- (id<YKUITableViewCellDataSource>)cellDataSourceAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)cellForTableView:(YKUITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)addCellDataSource:(id<YKUITableViewCellDataSource>)cellDataSource section:(NSInteger)section;

/*!
 Add cell data sources.
 @param array List of id<YKUITableViewCellDataSource>
 @param section Section to append to
 @param indexPaths If specified, adds NSIndexPath's that were added (for help animating)
 */
- (void)addCellDataSources:(NSArray */*of id<YKUITableViewCellDataSource>*/)array section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

- (BOOL)removeCellDataSourceAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)removeCellDataSourceForRow:(NSInteger)row inSection:(NSInteger)section;

- (void)replaceCellDataSource:(id<YKUITableViewCellDataSource>)cellDataSource indexPath:(NSIndexPath *)indexPath;

- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void)insertCellDataSource:(id<YKUITableViewCellDataSource>)cellDataSource atIndexPath:(NSIndexPath *)indexPath;

/*!
 Insert cell data sources.
 @param array List of id<YKUITableViewCellDataSource>
 @param section Section to insert to
 @param atIndex Index to insert at
 @param indexPaths If specified, adds NSIndexPath's that were added (for help animating)
 */
- (void)insertCellDataSources:(NSArray */*of id<YKUITableViewCellDataSource>*/)array section:(NSInteger)section atIndex:(NSInteger)index indexPaths:(NSMutableArray **)indexPaths;

/*!
 Enumerator for cell data sources.
 */
- (NSEnumerator *)enumeratorForCellDataSources;

/*!
 Replace cell data sources.
 @param array List of id<YKUITableViewCellDataSource>
 @param section Section to append to
 */
- (void)setCellDataSources:(NSArray */*of id<YKUITableViewCellDataSource>*/)array section:(NSInteger)section;

// Subclasses may override to reload from a persistent store
- (void)reload;

// Notify the data source that the table view will reload
- (void)tableViewWillReloadData:(YKUITableView *)tableView;

// Notify the data source that the table view reloaded
- (void)tableViewDidReloadData:(YKUITableView *)tableView;

- (void)clearSection:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

- (void)setHeaderTitle:(NSString *)title section:(NSInteger)section;
- (void)setHeaderView:(UIView *)view section:(NSInteger)section;

- (void)clearAll;

- (void)setHeaderView:(UIView *)view section:(NSInteger)section;
- (void)setFooterView:(UIView *)view section:(NSInteger)section;

/*!
 Get cell data sources for section.
 @param section
 */
- (NSMutableArray */*of id<YKUITableViewCellDataSource>*/)cellDataSourcesForSection:(NSInteger)section;

/*!
 Number of cells for a section.
 @param section Section to count
 @result Cell count in section
 */
- (NSInteger)count:(NSInteger)section;

/*!
 Count of items in all sections.
 @result Cell count
 */
- (NSInteger)count;

- (UITableViewCell *)tableView:(YKUITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(YKUITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(YKUITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

// Status
- (void)setMessage:(NSString *)message section:(NSInteger)section height:(CGFloat)height;

- (void)setMessage:(NSString *)message 
       buttonTitle:(NSString *)buttonTitle buttonTarget:(id)buttonTarget buttonAction:(SEL)buttonAction alternateButtonTitle:(NSString *)alternateButtonTitle alternateButtonTarget:(id)alternateButtonTarget alternateButtonAction:(SEL)alternateButtonAction
           section:(NSInteger)section height:(CGFloat)height;

- (void)setLoading:(BOOL)loading message:(NSString *)message section:(NSInteger)section height:(CGFloat)height;

/*!
 For YKUITableViewCellDataSource, find cell data source context that is on (checked or switch ON).
 @param section
 @result Cell data source context
 */
- (id)onContextInSection:(NSInteger)section;

/*!
 Set cell data source on for context (checked or switch ON).
 @param context
 @param section
 */
- (void)setOn:(BOOL)on forContext:(id)context inSection:(NSInteger)section;

@optional
- (NSInteger)numberOfSectionsInTableView:(YKUITableView *)tableView;
- (void)tableView:(YKUITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(YKUITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableView:(YKUITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(YKUITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(YKUITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (void)tableView:(YKUITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(YKUITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(YKUITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(YKUITableView *)tableView heightForFooterInSection:(NSInteger)section;
@end

@class YKUITableViewDataSource;

@protocol YKUITableViewDataSourceDelegate <NSObject>
- (void)tableViewDataSource:(YKUITableViewDataSource *)tableViewDataSource willReloadWithText:(NSString *)text;
- (void)tableViewDataSourceDidFinishReload:(YKUITableViewDataSource *)tableViewDataSource;
- (void)tableViewDataSource:(YKUITableViewDataSource *)tableViewDataSource didError:(YKError *)error;
- (void)tableViewDataSourceShouldReload:(YKUITableViewDataSource *)tableViewDataSource;
- (void)tableViewDataSourceShouldReloadData:(YKUITableViewDataSource *)tableViewDataSource;
@end

/*!
 Default YKUITableViewDataSource implementation.
 */
@interface YKUITableViewDataSource : NSObject <YKUITableViewDataSource> {
  NSString *_identifier;
  
  NSMutableDictionary */*Row -> NSMutableArray of id<YKUITableViewCellDataSource>*/_cellDataSourceSections;
  BOOL _needsRefresh;
  
  NSInteger _limit; // Defaults to -1 (for paging)
  NSInteger _totalCount; // Defaults to -1
  
  NSString *_revision; 
  
  NSInteger _offset; // Defaults to 0 (for paging)
  
  BOOL _loading;
  BOOL _statusEnabled;
  
  NSMutableDictionary */*Row -> NSString*/_sectionHeaderTitles;
  NSMutableDictionary */*Row -> UIView*/_sectionHeaderViews;
  
  NSMutableDictionary */*Row -> UIView*/_sectionFooterViews;
  
  BOOL _alwaysShowHeadersEnabled;
  
  NSInteger _sectionCount; // We need to keep section count stable since row animating requires tht we don't add or remove sections while animating.
  NSInteger _statusSection;
  
  BOOL _editable;
  
  // We can optimize away *forHeaderInSection by tracking if we've ever had headers set
  BOOL _headersExist;
  
  BOOL _editingMoveEnabled;
  
  id<YKUITableViewDataSourceDelegate> _delegate; // weak
}

@property (readonly, nonatomic) NSString *identifier;

@property (retain, nonatomic) NSString *revision;
@property (readonly, nonatomic, getter=isStatusEnabled) BOOL statusEnabled;
@property (assign, nonatomic, getter=isAlwaysShowHeadersEnabled) BOOL alwaysShowHeadersEnabled;
@property (assign, nonatomic) id<YKUITableViewDataSourceDelegate> delegate;

- (id)initWithIdentifier:(NSString *)identifier sectionCount:(NSInteger)sectionCount;

/*!
 Create empty data source.
 */
+ (YKUITableViewDataSource *)dataSource;

/*!
 Create data source with cell data sources.
 @param cellDataSources
 */
+ (YKUITableViewDataSource *)dataSourceWithCellDataSources:(NSArray */*of id<YKUITableViewCellDataSource>*/)cellDataSources;

/*!
 Clear section.
 @param section Section to clear
 @param indexPaths If set, adds the index paths we removed
 */
- (void)clearSection:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

/*!
 Get index path for last row in the last section.
 @result Last index path
 */
- (NSIndexPath *)lastIndexPath;

/*!
 Number of sections.
 @result Number of sections
 */
- (NSInteger)sectionCount;

@end


@interface YKUITableViewDataSourceEnumerator : NSEnumerator { 
  YKUITableViewDataSource *_dataSource;
  NSInteger _section;
  NSInteger _index;
}

- (id)initWithDataSource:(YKUITableViewDataSource *)dataSource;

@end
