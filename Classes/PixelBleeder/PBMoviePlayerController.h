//
//  PBMoviePlayerController.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface PBMoviePlayerController : UIViewController {
  MPMoviePlayerController *_moviePlayerController;
}

- (id)initWithContentURL:(NSURL *)URL;

- (void)play;

@end
