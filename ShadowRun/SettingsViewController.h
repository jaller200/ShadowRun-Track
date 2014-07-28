//
//  SettingsViewController.h
//  ShadowRun
//
//  Created by The Doctor on 11/29/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
    NSString *backgroundImage;
    NSString *alarmSound;
    NSString *originalAlarmMessage;
    NSString *newAlarmMessage;
    NSString *originalKeyboardAppearance;
    
    NSString *originalBackgroundSelected;
    
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIButton *keyboardAppearanceButton;
    IBOutlet UIButton *backgroundImageButton;
    IBOutlet UILabel *settingsLabel;
    IBOutlet UIToolbar *defaultToolbar;
    
    UIToolbar *accessToolbar;
    
    NSUserDefaults *prefs;
}

// Properties
@property (weak, nonatomic) IBOutlet UITextField *alarmMessageField;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

// IBActions
- (IBAction)changeAlarmSound:(id)sender;
- (IBAction)changeBackgroundImage:(id)sender;
- (IBAction)saveSettings:(id)sender;
- (IBAction)resetSettings:(id)sender;
- (IBAction)resetAlarmMessage:(id)sender;
- (IBAction)changeAlarmMessage:(id)sender;
- (IBAction)changeKeyboardAppearance:(id)sender;

- (IBAction)backgroundTapped:(id)sender;

@end
