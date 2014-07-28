//
//  CreditsHelpViewController.h
//  ShadowRun
//
//  Created by The Doctor on 9/24/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface CreditsHelpViewController : UIViewController <ADBannerViewDelegate>
{
    __weak IBOutlet UIBarButtonItem *settingsButton;
    __weak IBOutlet UITextView *copyrightView;
    __weak IBOutlet UITextView *verseView;
    
    ADBannerView *adView;
    NSUserDefaults *prefs;
}

@property (nonatomic, retain) IBOutlet ADBannerView *adView;
@property (weak, nonatomic) IBOutlet UIToolbar *defaultToolbar;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;

- (IBAction)openSettings:(id)sender;

@end
