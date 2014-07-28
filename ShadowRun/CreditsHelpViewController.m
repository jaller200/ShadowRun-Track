//
//  CreditsHelpViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/24/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "CreditsHelpViewController.h"
#import "SettingsViewController.h"
#import "UIImage+ImageEffects.h"

@implementation CreditsHelpViewController
@synthesize adView;
@synthesize defaultToolbar;
@synthesize backgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self = [super initWithNibName:@"CreditsHelpViewController~5" bundle:nil];
    } else {
        self = [super initWithNibName:@"CreditsHelpViewController~4" bundle:nil];
    }
    
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        
        [tbi setTitle:@"Credits"];
        [tbi setImage:[UIImage imageNamed:@"Credits.png"]];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"Credits", @"Credits")];
    }
    return self;
}

- (void)viewDidLoad
{
    defaultToolbar.barStyle = UIBarStyleDefault;
    defaultToolbar.translucent = YES;
    defaultToolbar.alpha = 0.94;

    [adView setDelegate:self];
    [adView setHidden:YES];
    
    prefs = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setNeedsDisplay];
    
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    NSLog(@"CreditsHelpViewController - backgroundSelected: %@", backgroundSelected);
    
    if (IS_IPHONE_5) {
        [backgroundView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-4-Inch.png", backgroundSelected]]];
    } else {
        [backgroundView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-3-5-Inch.png", backgroundSelected]]];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 193, 280, 133)];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    [view setAlpha:0.65];
    [view.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [view.layer setBorderWidth:0.5];
    
    [self.view insertSubview:view belowSubview:verseView];
}

- (IBAction)openSettings:(id)sender
{
    NSLog(@"CreditsHelpViewController - Opening Settings");
        
    SettingsViewController  *settings = [[SettingsViewController alloc] init];
        
    [self presentViewController:settings animated:YES completion:nil];
}

#pragma mark - iAd Methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [adView setHidden:NO];
    NSLog(@"CreditsViewController - Showing iAd");
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    NSLog(@"CreditsViewController - Loading iAd");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [adView setHidden:YES];
    NSLog(@"CreditsViewController - Could not load iAd (check internet connection?)");
}

@end
