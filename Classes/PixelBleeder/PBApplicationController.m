//
//  PBApplicationController.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "PBApplicationController.h"

#import "FFUtils.h"
#import "PBUIItem.h"


@implementation PBApplicationController

@synthesize sourceURL=_sourceURL;

- (id)init {
  if ((self = [super init])) {
    self.title = @"MediaMosher";
  }
  return self;
}

- (void)dealloc {
  [_mediaListViewController release];
  [_moviePlayerController release];
  [_processing release];
  [_sourceURL release];
	[super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSMutableArray *items = [NSMutableArray array];
  [items addObject:[PBUIItem text:@"Media" target:self action:@selector(selectMedia) accessoryType:UITableViewCellAccessoryDisclosureIndicator]];
  [items addObject:[PBUIItem text:@"Mosh" target:self action:@selector(process)]];
  [items addObject:[PBUIItem text:@"Play" target:self action:@selector(openMoviePlayerController)]];
  
  [self setItems:items];
  
  if (!_mediaListViewController) {
    _mediaListViewController = [[PBMediaListViewController alloc] init];
    [_mediaListViewController addMediaItem:[FFUtils resolvedURLForURL:[NSURL URLWithString:@"bundle://short2.mov"]]];
    [_mediaListViewController addMediaItem:[FFUtils resolvedURLForURL:[NSURL URLWithString:@"bundle://short1.mov"]]];  
  }
}

- (void)selectMedia {
  [self.navigationController pushViewController:_mediaListViewController animated:YES];
}

- (void)process {
  NSArray *mediaItems = [_mediaListViewController mediaItems];
  
  if (!_processing)
    _processing = [[PBProcessing alloc] init];
    
  [_processing processURLs:mediaItems];
}  

- (void)openMoviePlayerController {  
  FFDebug(@"Playing: %@", _processing.outputPath);
  if (_processing.outputPath) {
    [_moviePlayerController release];
    _moviePlayerController = [[PBMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:_processing.outputPath]];
    [_moviePlayerController play];
  }
}  

#pragma mark Delegates (PBProcessingDelegate)

//[self.container setStatusWithText:@"Processing..." progress:0.24];

@end
