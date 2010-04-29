//
//  PBApplicationController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "PBApplicationController.h"

#import "FFUtils.h"
#import "PBUIItem.h"
#import "YPUIAlertView.h"

@implementation PBApplicationController

@synthesize sourceURL=_sourceURL;

- (id)init {
  if ((self = [super init])) {
    self.title = @"VideoMosher";
    _processing = [[PBProcessing alloc] init];
    _processing.delegate = self;
  }
  return self;
}

- (void)dealloc {
  [_mediaListViewController release];
  [_moviePlayerController release];
  _processing.delegate = nil;
  [_processing release];
  [_sourceURL release];
	[super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSMutableArray *items = [NSMutableArray array];
  [items addObject:[PBUIItem text:@"Media" target:self action:@selector(selectMedia) accessoryType:UITableViewCellAccessoryDisclosureIndicator]];
  [items addObject:[PBUIItem text:@"Process" target:self action:@selector(process)]];
  [items addObject:[PBUIItem text:@"Play" target:self action:@selector(openMoviePlayerController)]];
  [items addObject:[PBUIItem text:@"Save" target:self action:@selector(saveMovieToPhotosAlbum)]];
  
  [self setItems:items];
  
  if (!_mediaListViewController) {
    _mediaListViewController = [[PBMediaListViewController alloc] init];
    //[_mediaListViewController addMediaItem:[NSURL URLWithString:@"bundle://short1.mov"]];
    [_mediaListViewController addMediaItem:[NSURL URLWithString:@"bundle://short2.mov"]];
    [_mediaListViewController reloadData];
  }
}

- (void)selectMedia {
  [self.navigationController pushViewController:_mediaListViewController animated:YES];
}

- (void)_cancel {
  [_processing cancel];
}

- (void)process {
  NSArray *URLs = [_mediaListViewController items];
  NSMutableArray *items = [NSMutableArray arrayWithCapacity:[URLs count]];
  for (NSURL *URL in URLs) {
    FFProcessingItem *item = [[FFProcessingItem alloc] initWithURL:URL format:nil];
    [items addObject:item];
    [item release];
  }
  
  [_processing startWithItems:items];
}  

- (void)openMoviePlayerController {  
  FFDebug(@"Playing: %@", _processing.outputPath);
  if (_processing.outputPath) {
    [_moviePlayerController release];
    _moviePlayerController = [[PBMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:_processing.outputPath]];
    [_moviePlayerController play];
  }
}  

- (void)saveMovieToPhotosAlbum {
  FFDebug(@"Playing: %@", _processing.outputPath);
  if (_processing.outputPath) {
    [self.container setStatusWithText:@"Saving..." activityIndicator:YES];     
    PBSaveThread *saveThread = [[PBSaveThread alloc] initWithPath:_processing.outputPath];
    saveThread.delegate = self;
    [saveThread start];
  }
}

- (void)_showError:(NSError *)error {
  [YPUIAlertView showOKAlertWithMessage:[NSString stringWithFormat:@"There was a problem (%@)", [error localizedDescription]] title:@"Oops"];
}

#pragma mark PBSaveThreadDelegate

- (void)saveThread:(PBSaveThread *)saveThread didFinishSavingWithError:(NSError *)error {
  [self.container clearStatus];
  if (error) [self _showError:error];
  saveThread.delegate = nil;
  [saveThread autorelease];
}

#pragma mark PBProcessingDelegate

- (void)processing:(PBProcessing *)processing didStartIndex:(NSInteger)index count:(NSInteger)count {
  [self.container setStatusWithText:[NSString stringWithFormat:@"Processing (%d/%d)...", (index + 1), count] activityIndicator:NO];  
  [_container.statusView setButtonTitle:@"Cancel" target:self action:@selector(_cancel)];
  [self.container setStatusProgress:0];  
}

- (void)processing:(PBProcessing *)processing didProgress:(float)progress index:(NSInteger)index count:(NSInteger)count {
  [self.container setStatusProgress:progress];
}

- (void)processing:(PBProcessing *)processing didFinishIndex:(NSInteger)index count:(NSInteger)count {
  if ((index + 1) == count) {
    [self.container clearStatus];  
  }
}

- (void)processing:(PBProcessing *)processing didError:(NSError *)error index:(NSInteger)index count:(NSInteger)count {
  [self.container clearStatus];
  [self _showError:error];
}

- (void)processingDidCancel:(PBProcessing *)processing {
  [self.container clearStatus];
}


@end
