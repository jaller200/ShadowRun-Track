//
//  CreditsHelpViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/24/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke.
//

#import "CreditsHelpViewController.h"
#import "TOSViewController.h"
#import "EULAViewController.h"
#import "SettingsViewController.h"

@implementation CreditsHelpViewController
@synthesize adView;

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
    }
    return self;
}

- (void)viewDidLoad
{
    [self.view setNeedsDisplay];
    UIColor *clr = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
    [[self view] setBackgroundColor:clr];
    
    [adView setDelegate:self];
    [adView setHidden:YES];
}

- (IBAction)openTOS:(id)sender
{
    NSLog(@"CreditsHelpViewController - Open TOS");
    
    TOSViewController *tos = [[TOSViewController alloc] init];
    
    [self presentViewController:tos animated:YES completion:nil];
}

- (IBAction)openEULA:(id)sender
{
    NSLog(@"CreditsHelpViewController - Open EULA");
    
    EULAViewController *eula = [[EULAViewController alloc] init];
    
    [self presentViewController:eula animated:YES completion:nil];
}

- (IBAction)gotoWebsite:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Under Construction" message:@"Our website is not yet up and running. Please check back later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.tag = 5000;
    [alertView show];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.shadowsystemsco.com/"]];
}

- (IBAction)openSettings:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    BOOL manualSettings = [prefs boolForKey:@"manual_settings"];
    
    if (manualSettings == YES) {
        NSLog(@"CreditsHelpViewController - Opening Settings");
        
        SettingsViewController  *settings = [[SettingsViewController alloc] init];
        
        [self presentViewController:settings animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Manual editing of ShadowRun settings has been disabled. You can enable it in the Settings application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = 4999;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4999) {
        if (buttonIndex == 0) {
            NSLog(@"CreditsViewController - Manual Editing of Settings Disabled. Please enable them.");
            return;
        }
    }
    
    if (alertView.tag == 5000) {
        if (buttonIndex == 0) {
            NSLog(@"CreditsViewController - Website");
            return;
        }
    }
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
