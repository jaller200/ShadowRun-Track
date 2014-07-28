//
//  SettingsViewController.m
//  ShadowRun
//
//  Created by The Doctor on 11/29/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIImage+ImageEffects.h"
#import "BackgroundPicker.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize alarmMessageField;
@synthesize backgroundImageView;

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
        
        originalBackgroundSelected = [userDefaults stringForKey:@"backgroundSelected"];
        NSLog(@"SettingsViewController - Original Background Selected: %@", originalBackgroundSelected);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self alarmMessageField] setDelegate:self];
    
    prefs = [NSUserDefaults standardUserDefaults];
    NSString *alarmMessage = [prefs stringForKey:@"alarmMessage"];
    
    if (alarmMessage == nil || alarmMessage == NULL || [alarmMessage isEqualToString:@"(null)"]) {
        [[self alarmMessageField] setText:@""];
    } else {
        [[self alarmMessageField] setText:[NSString stringWithFormat:@"%@", alarmMessage]];
    }
    
    NSString *keyboardAppearance = [prefs stringForKey:@"keyboardAppearance"];
    
    if ([keyboardAppearance isEqualToString:@"light"]) {
        [keyboardAppearanceButton setTitle:@"Light" forState:UIControlStateNormal];
        [alarmMessageField setKeyboardAppearance:UIKeyboardAppearanceLight];
    } else {
        [keyboardAppearanceButton setTitle:@"Dark" forState:UIControlStateNormal];
        [alarmMessageField setKeyboardAppearance:UIKeyboardAppearanceDark];
    }
    
    NSLog(@"%@", originalBackgroundSelected);
}

- (void)done:(id)sender
{
    [alarmMessageField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    accessToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    [accessToolbar setItems:[NSArray arrayWithObjects:flexSpace, doneItem, nil] animated:NO];
    
    NSString *theme = [prefs stringForKey:@"keyboardAppearance"];
    
    if ([theme isEqualToString:@"light"]) {
        [accessToolbar setBarStyle:UIBarStyleDefault];
        
        // - This is info for the theme options (migrated from Keyboard Appearance) that will
        // - Be release in Release 2.1.0
        // [defaultToolbar setBarStyle:UIBarStyleDefault];
    } else {
        [accessToolbar setBarStyle:UIBarStyleBlackTranslucent];
        
        // - This is info for the theme options (migrated from Keyboard Appearance) that will
        // - Be release in Release 2.1.0
        // [defaultToolbar setBarStyle:UIBarStyleBlackTranslucent];
    }
    
    [alarmMessageField setInputAccessoryView:accessToolbar];
    
    [super viewWillAppear:animated];
    
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    
    if (backgroundSelected == nil) {
        backgroundSelected = @"Default";
        [prefs setObject:@"Default" forKey:@"backgroundSelected"];
    }
    
    [backgroundImageButton setTitle:backgroundSelected forState:UIControlStateNormal];
    
    NSLog(@"%@", originalBackgroundSelected);
    
    UIImage *background;
        
    if (IS_IPHONE_5) {
        background = [UIImage imageNamed:[NSString stringWithFormat:@"%@-4-Inch-Blurred.png", backgroundSelected]];
    } else {
        background = [UIImage imageNamed:[NSString stringWithFormat:@"%@-3-5-Inch-Blurred.png", backgroundSelected]];
    }
    
    [backgroundImageView setImage:background];
}

- (IBAction)changeAlarmSound:(id)sender
{
    NSLog(@"Settings - Changing Alarm Sound");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notice", @"Notice") message:NSLocalizedString(@"Currently the only option for this is Default...More coming soon!", @"Currently the only option for this is Default...More coming soon!") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    
    alarmSound = @"default";
    backgroundImage = @"default";
    
    [alertView show];
}

- (IBAction)changeBackgroundImage:(id)sender
{
    NSLog(@"Settings - Changing Background Image");
    
    alarmSound = @"default";
    backgroundImage = @"default";
    
    BackgroundPicker *bp = [[BackgroundPicker alloc] init];
    [bp setDismissBlock:^{
        [self.view setNeedsDisplay];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:bp];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setToolbarHidden:NO];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)saveSettings:(id)sender
{
    NSLog(@"SettingsViewController - Saving...");
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"SettingsViewController - Saved!");
}

- (IBAction)resetSettings:(id)sender
{
    NSLog(@"SettingsViewController - Resetting...");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Warning!") message:NSLocalizedString(@"This option will override all your changes made and revert to the default. Do you wish to proceed?", @"This option will override all your changes made and revert to the default. Do you wish to proceed?") delegate:self cancelButtonTitle:NSLocalizedString(@"Yes", @"Yes") otherButtonTitles:NSLocalizedString(@"No", @"No"), nil];
    alertView.tag = 5000;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5000) {
        if (buttonIndex == 0) {
            NSLog(@"SettingsViewController - Reset");
            
            [prefs setObject:nil forKey:@"alarmMessage"];
            [prefs setObject:@"Default" forKey:@"backgroundSelected"];
            [prefs setObject:@"dark" forKey:@"keyboardAppearance"];
            
            [keyboardAppearanceButton setTitle:@"Dark" forState:UIControlStateNormal];
            [alarmMessageField setKeyboardAppearance:UIKeyboardAppearanceDark];
            [accessToolbar setBarStyle:UIBarStyleBlack];
            
            [backgroundImageButton setTitle:@"Default" forState:UIControlStateNormal];
            
            [alarmMessageField setText:@"Start Running!"];
            
            UIImage *background;
            
            if (IS_IPHONE_5) {
                background = [UIImage imageNamed:[NSString stringWithFormat:@"Default-4-Inch-Blurred.png"]];
            } else {
                background = [UIImage imageNamed:[NSString stringWithFormat:@"Default-3-5-Inch-Blurred.png"]];
            }
            
            [backgroundImageView setImage:background];
        } else {
            NSLog(@"SettingsViewController - Did not reset");
            return;
        }
    }
}

- (IBAction)resetAlarmMessage:(id)sender
{
    NSLog(@"Reset Alarm Message...");
    
    [prefs setObject:nil forKey:@"alarmMessage"];
    
    [[self alarmMessageField] setText:@""];
    
    NSLog(@"SettingsViewController - Resetting Alarm Message... Message = %@", [prefs stringForKey:@"alarmMessage"]);
}

- (IBAction)changeAlarmMessage:(id)sender
{
    NSLog(@"Change Alarm Message...");
    
    NSString *alarmMessage = [[self alarmMessageField] text];
    NSLog(@"SettingsViewController - Alarm Message = %@", alarmMessage);
    
    
    [prefs setObject:alarmMessage forKey:@"alarmMessage"];
    
    NSLog(@"SettingsViewController - Alarm Message (in NSUSerDefaults) = %@", [prefs stringForKey:@"alarmMessage"]);
    
    newAlarmMessage = [prefs stringForKey:@"alarmMessage"];
}

- (IBAction)changeKeyboardAppearance:(id)sender
{
    NSString *keyboardAppearance = [prefs stringForKey:@"keyboardAppearance"];
    
    NSLog(@"SettingsViewController - Changing keyboard appearance from \"%@\"", keyboardAppearance);
    
    if ([keyboardAppearance isEqualToString:@"light"]) {
        originalKeyboardAppearance = @"light";
        [prefs setObject:@"dark" forKey:@"keyboardAppearance"];
        [keyboardAppearanceButton setTitle:@"Dark" forState:UIControlStateNormal];
        [alarmMessageField setKeyboardAppearance:UIKeyboardAppearanceDark];
        [accessToolbar setBarStyle:UIBarStyleBlackTranslucent];
        
        // - This is info for the theme options (migrated from Keyboard Appearance) that will
        // - Be release in Release 2.1.0
        // [defaultToolbar setBarStyle:UIBarStyleBlackTranslucent];
    } else {
        originalKeyboardAppearance = @"dark";
        [prefs setObject:@"light" forKey:@"keyboardAppearance"];
        [keyboardAppearanceButton setTitle:@"Light" forState:UIControlStateNormal];
        [alarmMessageField setKeyboardAppearance:UIKeyboardAppearanceLight];
        [accessToolbar setBarStyle:UIBarStyleDefault];
        
        // - This is info for the theme options (migrated from Keyboard Appearance) that will
        // - Be release in Release 2.1.0
        // [defaultToolbar setBarStyle:UIBarStyleDefault];
    }
}

- (IBAction)backgroundTapped:(id)sender
{
    NSLog(@"backgroundTapped");
    [[self alarmMessageField] endEditing:YES];
    [[self alarmMessageField] resignFirstResponder];
}

#pragma mark - TextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"TextField Did Begin Editing...");
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (IS_IPHONE_5) {
                             self.view.frame = CGRectMake(0, -15, 320, 568);
                         } else {
                             self.view.frame = CGRectMake(0, -100, 320, 480);
                         }
                     }
                     completion:nil];
    [UIView commitAnimations];
    
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    if (!IS_IPHONE_5) {
        self.view.frame = CGRectMake(0, 20, 320, 460);
        
        toolbar = nil;
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460, 320, 44)];
    } else {
        self.view.frame = CGRectMake(0, 0, 420, 568);
    }
    
    [UIView commitAnimations];
}

@end

