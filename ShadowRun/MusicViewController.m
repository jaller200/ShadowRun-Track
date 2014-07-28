//
//  MusicViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/24/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "MusicViewController.h"
#import "UIImage+ImageEffects.h"

// Uses MediaKit Framework
@implementation MusicViewController
@synthesize musicPlayer;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self = [super initWithNibName:@"MusicViewController~5" bundle:nil];
    } else {
        self = [super initWithNibName:@"MusicViewController~4" bundle:nil];
    }
    
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        
        [tbi setTitle:@"Music"];
        [tbi setImage:[UIImage imageNamed:@"mic.png"]];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"Music", @"Music")];
    }
    return self;
}

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    defaultToolbar.translucent = YES;
    defaultToolbar.alpha = 0.94;
    
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    [artworkImageView setImage:[UIImage imageNamed:@"noArtwork.jpg"]];
    
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"video_pause_64.png"] forState:UIControlStateNormal];
    } else {
        [playPauseButton setImage:[UIImage imageNamed:@"video_play_64.png"] forState:UIControlStateNormal];
    }
    
    [self registerMediaPlayerNotifications];
    
    [volumeSlider setHidden:YES];
    [volumeLabel setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    
    if (IS_IPHONE_5) {
        [backgroundView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-4-Inch.png", backgroundSelected]]];
    } else {
        [backgroundView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-3-5-Inch.png", backgroundSelected]]];
    }
    
    [detailsView setBackgroundColor:[UIColor lightGrayColor]];
    [detailsView setAlpha:0.65];
    [detailsView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [detailsView.layer setBorderWidth:0.5];
    
    itemsInCollection = [prefs integerForKey:@"itemsInCollection"];
    
    currentSong = [prefs integerForKey:@"currentSong"];
    
    if (currentSong == 0) {
        [prevButton setEnabled:NO];
    } else {
        [prevButton setEnabled:YES];
    }
    
    if (currentSong == itemsInCollection) {
        [nextButton setEnabled:NO];
    } else {
        [nextButton setEnabled:YES];
    }
    
    UIImage *artworkImage = [UIImage imageNamed:@"noArtwork.jpg"];
    [artworkBackgroundView setImage:artworkImage];
}

#pragma mark - MPMusicPlayer Functions

- (void)handle_NowPlayingItemChanged:(id)notification
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtwork.jpg"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork) {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            artworkImage = [artwork imageWithSize:CGSizeMake(200, 200)];
        } else {
            artworkImage = [artwork imageWithSize:CGSizeMake(150, 150)];
        }
        
        [prefs setBool:YES forKey:@"musicPlaying"];
    } else {
        [prefs setBool:NO forKey:@"musicPlaying"];
    }
    
    [artworkImageView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        [titleLabel setText:[NSString stringWithFormat:@"%@", titleString]];
    } else {
        [titleLabel setText:@"Unknown title"];
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        [artistLabel setText:[NSString stringWithFormat:@"%@", artistString]];
    } else {
        [artistLabel setText:@"Unknown artist"];
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        [albumLabel setText:[NSString stringWithFormat:@"%@", albumString]];
    } else {
        [albumLabel setText:@"Unknown album"];
    }
}

- (void)handle_PlaybackStateChanged:(id)notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    if (playbackState == MPMusicPlaybackStatePaused) {
        [playPauseButton setImage:[UIImage imageNamed:@"video_play_64.png"] forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playPauseButton setImage:[UIImage imageNamed:@"video_pause_64.png"] forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        [playPauseButton setImage:[UIImage imageNamed:@"video_play_64.png"] forState:UIControlStateNormal];
        [musicPlayer stop];
    }
}


#pragma mark - Notification Center

- (void)registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handle_NowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:musicPlayer];
    [notificationCenter addObserver:self
                           selector:@selector(handle_PlaybackStateChanged:)
                               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object:musicPlayer];
    [musicPlayer beginGeneratingPlaybackNotifications];
}

#pragma mark - MediaPicker Functions

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    if (mediaItemCollection) {
        [musicPlayer setQueueWithItemCollection:mediaItemCollection];
        [musicPlayer play];
        
        itemsInCollection = mediaItemCollection.count - 1;
        [prefs setInteger:itemsInCollection forKey:@"itemsInCollection"];
        currentSong = 0;
        [prefs setInteger:currentSong forKey:@"currentSong"];
        
        if (currentSong + 1 == itemsInCollection) {
            [nextButton setEnabled:NO];
        } else {
            [nextButton setEnabled:YES];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [prevButton setEnabled:NO];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Functions

- (IBAction)showMediaPicker:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
    [mediaPicker setDelegate:self];
    [mediaPicker setAllowsPickingMultipleItems:YES];
    [mediaPicker setPrompt:@"Select Media"];
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

- (IBAction)previousSong:(id)sender
{
    if (currentSong != 0) {
        [musicPlayer skipToPreviousItem];
        currentSong--;
        [prefs setInteger:currentSong forKey:@"currentSong"];
        
        if (currentSong == 0) {
            [prevButton setEnabled:NO];
        }
        
        [nextButton setEnabled:YES];
    } else {
        [prevButton setEnabled:NO];
    }
}

- (IBAction)playPause:(id)sender
{
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [musicPlayer pause];
    } else {
        [musicPlayer play];
    }
}

- (IBAction)nextSong:(id)sender
{
    if (currentSong != itemsInCollection) {
        [musicPlayer skipToNextItem];
        currentSong++;
        [prefs setInteger:currentSong forKey:@"currentSong"];
        
        if (currentSong == itemsInCollection) {
            [nextButton setEnabled:NO];
        } else {
            [nextButton setEnabled:YES];
        }
    }
    
    [prevButton setEnabled:YES];
    [prevButton setAlpha:1];
}

#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"Deallocating");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object:musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object:musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMusicPlayerControllerVolumeDidChangeNotification
                                                  object:musicPlayer];
    [musicPlayer endGeneratingPlaybackNotifications];
}

@end
