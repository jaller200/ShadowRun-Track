//
//  AlarmViewController.m
//  ShadowRun
//
//  Created by The Doctor on 11/29/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmLengthViewController.h"

@interface AlarmViewController ()

@end

@implementation AlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self = [super initWithNibName:@"AlarmViewController~5" bundle:nil];
    } else {
        self = [super initWithNibName:@"AlarmViewController~4" bundle:nil];
    }
    
    if (self) {
        UITabBarItem *tbi = [self tabBarItem];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *alarmSetString = [userDefaults stringForKey:@"alarmSet"];
        
        if ([alarmSetString isEqualToString:@"yes"]) {
            [tbi setTitle:@"Alarm"];
            [tbi setImage:[UIImage imageNamed:@"AlarmOn.png"]];
        } else {
            [tbi setTitle:@"Alarm"];
            [tbi setImage:[UIImage imageNamed:@"AlarmOff.png"]];
        }
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int number = [prefs integerForKey:@"alarm_number"];
        NSLog(@"The Alarm Number is: %d", number);
    }
    
    return self;
}

#pragma mark - View Functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [datePicker setDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *alarmSetDate = [userDefaults objectForKey:@"alarmDate"];
    NSLog(@"AlarmSetDate = %@", alarmSetDate);
    
    NSString *alarmSetString = [dateFormatter stringFromDate:alarmSetDate];
    
    if (alarmSetDate == nil || alarmSetDate == NULL) {
        [[self alarmSetToLabel] setText:@"-Not Set-"];
    } else {
        [[self alarmSetToLabel] setText:alarmSetString];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setNeedsDisplay];
}

#pragma mark - Custom Functions

- (IBAction)set:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    
    NSString *dateTimeString = [dateFormatter stringFromDate:[datePicker date]];
    
    NSLog(@"Alarm Set Button Tapped: %@", dateTimeString);
    
    [self scheduleLocalNotificationWithDate:[datePicker date]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dateTimeString forKey:@"alarmDate"];
    
    NSDate *alarmDate = [userDefaults objectForKey:@"alarmDate"];

    if (alarmDate == nil || alarmDate == NULL) {
        [[self alarmSetToLabel] setText:@"-Not Set-"];
    } else {
        [[self alarmSetToLabel] setText:[userDefaults stringForKey:@"alarmDate"]];
    }
    
    alarmSet = YES;
    
    [[self tabBarItem] setImage:[UIImage imageNamed:@"AlarmOn.png"]];
    
    [self showMessage:@"Alarm Set"];
    
    [userDefaults setObject:@"yes" forKey:@"alarmSet"];
}

- (IBAction)cancel:(id)sender
{
    NSLog(@"Alarm Cancel Button Tapped");
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    alarmSet = NO;
    
    [[self tabBarItem] setImage:[UIImage imageNamed:@"AlarmOff.png"]];
    
    [self showMessage:@"Alarm Canceled"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"no" forKey:@"alarmSet"];
    
    [userDefaults setObject:nil forKey:@"alarmDate"];
    
    [[self alarmSetToLabel] setText:@"-Not Set-"];
}

- (void)scheduleLocalNotificationWithDate:(NSDate *)date
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    float number = [prefs integerForKey:@"alarm_number"];
    NSLog(@"The Alarm Number is: %f", number);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *repeatDate = [NSDate date];
    repeatDate = [repeatDate dateByAddingTimeInterval:1*24*60*60];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *alarmMessage = [userDefault stringForKey:@"alarmMessage"];
    
    if (alarmMessage == NULL || alarmMessage == nil || [alarmMessage isEqualToString:@"(null)"]) {
        alarmMessage = @"Start Running!";
    }
    
    notification.alertBody = alarmMessage;
    notification.soundName = @"Alarm.aiff";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)showMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alarm" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)setAlarmLength:(id)sender
{
    AlarmLengthViewController *alarmLengthViewController = [[AlarmLengthViewController alloc] init];
    
    [self presentViewController:alarmLengthViewController animated:YES completion:nil];
}

@end
