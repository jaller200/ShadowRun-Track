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
}

// Properties
@property (weak, nonatomic) IBOutlet UITextField *alarmMessageField;

// IBActions
- (IBAction)changeAlarmSound:(id)sender;
- (IBAction)changeBackgroundImage:(id)sender;
- (IBAction)saveSettings:(id)sender;
- (IBAction)cancelSettings:(id)sender;
- (IBAction)resetSettings:(id)sender;
- (IBAction)resetAlarmMessage:(id)sender;
- (IBAction)changeAlarmMessage:(id)sender;

- (IBAction)backgroundTapped:(id)sender;

@end
