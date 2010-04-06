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
    self.title = @"PixelBleeder";
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
  _videoController = [[PBVideoController alloc] init];
  _videoController.delegate = self;
  [self.navigationController pushViewController:_videoController animated:YES];
  [_videoController release];
}

- (void)setProcessOptions:(NSInteger)mode {
  if (!_processing)
    _processing = [[PBProcessing alloc] init];

  switch (mode) {
    case 1:
      _processing.IFrameInterval = 6;
      _processing.smoothInterval = 3;
      _processing.smoothIterations = 2;
      break;
    case 2:
      _processing.IFrameInterval = 999999;
      _processing.smoothInterval = 3;
      _processing.smoothIterations = 4;
      break;
  }
}

- (void)process:(NSURL *)sourceURL {
  if (!_processing)
    _processing = [[PBProcessing alloc] init];
    
  if (sourceURL) {
    NSString *outputFormat = @"mp4";
    NSString *outputCodecName = nil; //@"libx264";
    self.path = [[FFUtils documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"mosh.mp4", outputFormat]];
    FFDebug(@"Process: %@ to %@", sourceURL, self.path);
    [_processing processURL:sourceURL outputPath:self.path outputFormat:outputFormat outputCodecName:outputCodecName];
  }
}  

- (void)openMoviePlayerController {
  FFDebug(@"Playing: %@", self.path);
  if (self.path) {
    [_moviePlayerController release];
    _moviePlayerController = [[PBMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:self.path]];
    [_moviePlayerController play];
  }
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
  
  cell.accessoryType = UITableViewCellAccessoryNone;

  switch (indexPath.row) {
    case 0: {
      cell.textLabel.text = @"Camera";
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      break;
    }
    case 1: {
      cell.textLabel.text = @"Process (Camera)";
      break;
    }
    case 2: {
      cell.textLabel.text = @"Play";
      break;
    }
    case 3: {
      cell.textLabel.text = @"Process Test (ST:TNG)";
      break;
    }     
    case 4: {
      cell.textLabel.text = @"Process Options #1";
      break;
    }
    case 5: {
      cell.textLabel.text = @"Process Options #2";
      break;
    }
      
  }
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
  return 6;
}

#pragma mark Delegate (UITableViewDelegate)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0: {
      [self openVideoController]; 
      break;
    }
    case 1: {
      [self process:self.sourceURL];
      break;
    }
    case 2: {
      [self openMoviePlayerController]; 
      break;
    }      
    case 3: {
      [self process:[FFUtils resolvedURLForURL:[NSURL URLWithString:@"bundle://star_trek.mov"]]];
      break;
    }
    case 4: {
      [self setProcessOptions:1]; 
      break;
    }
    case 5: {
      [self setProcessOptions:2]; 
      break;
    }
  }
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
