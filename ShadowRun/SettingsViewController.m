//
//  SettingsViewController.m
//  ShadowRun
//
//  Created by The Doctor on 11/29/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self = [super initWithNibName:@"SettingsViewController~5" bundle:nil];
    } else {
        self = [super initWithNibName:@"SettingsViewController~4" bundle:nil];
    }
    
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        
        [tbi setTitle:@"Settings"];
        [tbi setImage:[UIImage imageNamed:@"Settings.png"]];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        originalAlarmMessage = [userDefaults stringForKey:@"alarmMessage"];
        
        NSLog(@"SettingsViewController - Original Alarm Message = %@", originalAlarmMessage);
        
        //[self save:self];
        //[self load:self];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self alarmMessageField] setDelegate:self];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *alarmMessage = [userDefaults stringForKey:@"alarmMessage"];
    
    if (alarmMessage == nil || alarmMessage == NULL || [alarmMessage isEqualToString:@"(null)"]) {
        [[self alarmMessageField] setText:@""];
    } else {
        [[self alarmMessageField] setText:[NSString stringWithFormat:@"%@", alarmMessage]];
    }
}

- (IBAction)changeAlarmSound:(id)sender
{
    NSLog(@"Settings - Changing Alarm Sound");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Currently the only option for this is Default...More coming soon!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    alarmSound = @"default";
    backgroundImage = @"default";
    
    [alertView show];
}

- (IBAction)changeBackgroundImage:(id)sender
{
    NSLog(@"Settings - Changing Background Image");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Currently the only option for this is Default...More coming soon!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    alarmSound = @"default";
    backgroundImage = @"default";
    
    [alertView show];
}

- (IBAction)saveSettings:(id)sender
{
    NSLog(@"SettingsViewController - Saving...");
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"SettingsViewController - Saved!");
}

- (IBAction)cancelSettings:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Do you want to exit without saving your settings?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert setTag:4999];
    [alert show];
    
    //NSLog(@"SettingsViewController - Canceled");
    
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetSettings:(id)sender
{
    NSLog(@"SettingsViewController - Resetting...");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"This option will override all your changes made and revert to the default. Do you wish to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alertView.tag = 5000;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (alertView.tag == 4999) {
        if (buttonIndex == 0) {
            NSLog(@"SettingsViewController - Canceled");
        
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            
            [userDefaults setObject:originalAlarmMessage forKey:@"alarmMessage"];
            
            NSLog(@"SettingsViewController - Alarm Message (on Cancel) set to %@", [userDefaults stringForKey:@"alarmMessage"]);
        } else {
            return;
        }
    }
    
    if (alertView.tag == 5000) {
        if (buttonIndex == 0) {
            NSLog(@"SettingsViewController - Reset");
            
            [userDefaults setObject:nil forKey:@"alarmMessage"];
        } else {
            NSLog(@"SettingsViewController - Did not reset");
            return;
        }
    }
}

- (IBAction)resetAlarmMessage:(id)sender
{
    NSLog(@"Reset Alarm Message...");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"alarmMessage"];
    
    [[self alarmMessageField] setText:@""];
    
    NSLog(@"SettingsViewController - Resetting Alarm Message... Message = %@", [userDefaults stringForKey:@"alarmMessage"]);
}

- (IBAction)changeAlarmMessage:(id)sender
{
    NSLog(@"Change Alarm Message...");
    
    NSString *alarmMessage = [[self alarmMessageField] text];
    NSLog(@"SettingsViewController - Alarm Message = %@", alarmMessage);
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:alarmMessage forKey:@"alarmMessage"];
    
    NSLog(@"SettingsViewController - Alarm Message (in NSUSerDefaults) = %@", [userDefaults stringForKey:@"alarmMessage"]);
    
    newAlarmMessage = [userDefaults stringForKey:@"alarmMessage"];
}

- (IBAction)backgroundTapped:(id)sender
{
    NSLog(@"backgroundTapped");
    [[self alarmMessageField] endEditing:YES];
    [[self alarmMessageField] resignFirstResponder];
}

/*- (IBAction)save:(id)sender
{
    NSLog(@"Saving Settings...");
    
    NSString *path;
    NSMutableDictionary *settings;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingString:@"settings.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
    }
    
    settings = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSString *alarmSoundKey = [[settings allKeys] objectAtIndex:0];
    [settings setObject:alarmSound forKey:alarmSoundKey];
    
    NSString *backgroundImageKey = [[settings allKeys] objectAtIndex:1];
    [settings setObject:backgroundImage forKey:backgroundImageKey];
}

- (IBAction)load:(id)sender
{
    NSLog(@"Loading Settings...");
    
    NSString *path;
    NSMutableDictionary *settings;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingString:@"settings.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
    }
    
    settings = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSString *alarmSoundKey = [[settings allKeys] objectAtIndex:0];
    alarmSound = [settings objectForKey:alarmSoundKey];
    
    NSString *backgroundImageKey = [[settings allKeys] objectAtIndex:1];
    backgroundImage = [settings objectForKey:backgroundImageKey];
    
}*/

#pragma mark - TextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    NSLog(@"TextField Did Begin Editing...");
    
    if (IS_IPHONE_5 == NO) {
        self.view.frame = CGRectMake(0, -100, 320, 420);
    }
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    if (IS_IPHONE_5 == NO) {
        self.view.frame = CGRectMake(0, 0, 320, 480);
    }
    
    [UIView commitAnimations];
}

@end

