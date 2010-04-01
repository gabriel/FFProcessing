//
//  PBApplicationController.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "PBApplicationController.h"

#import "FFUtils.h"

@implementation PBApplicationController

@synthesize sourceURL=_sourceURL, path=_path;

- (id)init {
  if ((self = [super init])) {
    self.title = @"☈";
  }
  return self;
}

- (void)dealloc {
  [_videoController release];
  [_moviePlayerController release];
  [_processing release];
  [_sourceURL release];
  [_path release];
	[super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
}  

- (void)openVideoController {
  if (!_videoController) {
    _videoController = [[PBVideoController alloc] init];
    _videoController.delegate = self;
  }
  [self.navigationController pushViewController:_videoController animated:YES];
}

- (void)process {
  if (!_processing)
    _processing = [[PBProcessing alloc] init];
  
  if (self.sourceURL) {
    self.path = [[FFUtils documentsDirectory] stringByAppendingPathComponent:@"test.mov"];
    [_processing processURL:self.sourceURL outputPath:self.path outputFormat:@"h264"];    
  }
}  

- (void)openMoviePlayerController {
  //if (!self.path) self.path = [FFUtils resolvePathForURL:[NSURL URLWithString:@"bundle://test-mosh.mp4"]];

  [_moviePlayerController release];
  _moviePlayerController = [[PBMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:self.path]];
  [_moviePlayerController play];
}  


#pragma mark Delegate (PBVideoControllerDelegate)

- (void)videoController:(PBVideoController *)videoController didSelectURL:(NSURL *)URL {  
  self.sourceURL = URL;
  [self.navigationController popToViewController:self animated:YES];
}

#pragma mark DataSource (UITableViewDataSource)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if (!cell)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"] autorelease];    

  switch (indexPath.row) {
    case 0: {
      cell.textLabel.text = @"Camera";
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      break;
    }
    case 1: {
      cell.textLabel.text = @"Process";
      cell.accessoryType = UITableViewCellAccessoryNone;
      break;
    }
    case 2: {
      cell.textLabel.text = @"Play";
      cell.accessoryType = UITableViewCellAccessoryNone;
      break;
    }
  }
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
  return 3;
}

#pragma mark Delegate (UITableViewDelegate)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0: {
      [self openVideoController]; 
      break;
    }
    case 1: {
      [self process];       
      break;
    }
    case 2: {
      [self openMoviePlayerController]; 
      break;
    }
  }
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
