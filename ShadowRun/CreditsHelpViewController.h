//
//  CreditsHelpViewController.h
//  ShadowRun
//
//  Created by The Doctor on 9/24/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface CreditsHelpViewController : UIViewController <UIAlertViewDelegate, ADBannerViewDelegate>
{
    __weak IBOutlet UIButton *websiteButton;
    IBOutlet UIBarButtonItem *settingsButton;
    ADBannerView *adView;
}

@property (nonatomic, retain) IBOutlet ADBannerView *adView;

- (IBAction)openTOS:(id)sender;
- (IBAction)openEULA:(id)sender;
- (IBAction)gotoWebsite:(id)sender;
- (IBAction)openSettings:(id)sender;

@end