//
//  MusicViewController.h
//  ShadowRun
//
//  Created by The Doctor on 9/24/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

// Uses MediaKit Framework
@interface MusicViewController : UIViewController <MPMediaPickerControllerDelegate>
{
    __weak IBOutlet UIImageView *artworkImageView;
    __weak IBOutlet UIButton *playPauseButton;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *artistLabel;
    __weak IBOutlet UILabel *albumLabel;
    __weak IBOutlet UISlider *volumeSlider;
    __weak IBOutlet UILabel *volumeLabel;
    
    MPMusicPlayerController *musicPlayer;
}

@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;

// Actions
- (IBAction)showMediaPicker:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;

- (void)registerMediaPlayerNotifications;

@end
