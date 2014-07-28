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
    __weak IBOutlet UIImageView *artworkBackgroundView;
    __weak IBOutlet UIButton *playPauseButton;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *artistLabel;
    __weak IBOutlet UILabel *albumLabel;
    __weak IBOutlet UISlider *volumeSlider;
    __weak IBOutlet UILabel *volumeLabel;
    __weak IBOutlet UIButton *nextButton;
    __weak IBOutlet UIButton *prevButton;
    __weak IBOutlet UIToolbar *defaultToolbar;
    
    IBOutlet UIView *detailsView;;
    IBOutlet UIImageView *backgroundView;
    
    MPMusicPlayerController *musicPlayer;
    
    NSUserDefaults *prefs;
    NSUInteger itemsInCollection;
    NSUInteger currentSong;
}

@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

// Actions
- (IBAction)showMediaPicker:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;

- (void)registerMediaPlayerNotifications;

@end
