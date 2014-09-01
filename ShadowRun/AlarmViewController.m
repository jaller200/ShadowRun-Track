//
//  AlarmViewController.m
//  ShadowRun
//
//  Created by The Doctor on 11/29/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "AlarmViewController.h"
#import "UIImage+ImageEffects.h"

@interface AlarmViewController ()

@end

@implementation AlarmViewController
@synthesize setItem, cancelItem, repeatButton;

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
        NSLog(@"Alarm Set String");
        
        if ([alarmSetString isEqualToString:@"yes"]) {
            [tbi setTitle:@"Alarm"];
            [tbi setImage:[UIImage imageNamed:@"AlarmOn.png"]];
            [[self tabBarItem] setSelectedImage:[UIImage imageNamed:@"AlarmOn.png"]];
            
            alarmSet = YES;
        } else {
            [tbi setTitle:@"Alarm"];
            [tbi setImage:[UIImage imageNamed:@"AlarmOff.png"]];
            [[self tabBarItem] setSelectedImage:[UIImage imageNamed:@"AlarmOff.png"]];
            
            alarmSet = NO;
        }
    }
    
    return self;
}

- (NSString *)editAlarmRepeatIntervalWithInteger:(NSUInteger)repeatInteger
{
    NSString *repeatIntString = @"";
    
    switch (repeatInteger) {
        case 4:
            repeatIntString = @"Yearly";
            break;
            
        case 8:
            repeatIntString = @"Monthly";
            break;
            
        case 16:
            repeatIntString = @"Daily";
            break;
            
        case 32:
            repeatIntString = @"Hourly";
            break;
            
        case 64:
            repeatIntString = @"Every Minute";
            break;
            
        case 8192:
            repeatIntString = @"Weekly";
            break;
            
        default:
            repeatIntString = @"Daily";
            break;
    }
    
    [self.repeatButton setTitle:repeatIntString forState:UIControlStateNormal];
    
    return repeatIntString;
}

#pragma mark - View Functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _prefs = [NSUserDefaults standardUserDefaults];
    
    [datePicker setDate:[NSDate date]];
    
    defaultToolbar.translucent = YES;
    defaultToolbar.alpha = 0.94;
    
    BOOL isIphone5 = IS_IPHONE_5;
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, isIphone5 == YES ? 612 : 524, 320, 216)];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, isIphone5 == YES ? 568 : 480, 320, 44)];
    
    NSString *themeColor = [_prefs stringForKey:@"keyboardAppearance"];
    
    if ([themeColor isEqualToString:@"light"]) {
        [pickerView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [toolbar setBarStyle:UIBarStyleDefault];
    } else {
        [pickerView setBackgroundColor:[UIColor colorWithWhite:0.22 alpha:1]];
        [toolbar setBarStyle:UIBarStyleBlack];
    }
    
    UIBarButtonItem *done, *flexSpace;
    
    done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexSpace, done, nil]];
    
    ShadowRunAppDelegate *appDelegate = (ShadowRunAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Retain pickerView
    _pickerView = pickerView;
    _toolbar = toolbar;
    
    [appDelegate.window addSubview:_pickerView];
    [appDelegate.window addSubview:_toolbar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [datePicker setDate:[NSDate date]];
    
    NSString *backgroundSelected = [_prefs stringForKey:@"backgroundSelected"];
    
    UIImage *background;
    
    if (IS_IPHONE_5) {
        background = [UIImage imageNamed:[NSString stringWithFormat:@"%@-4-Inch-Blurred.png", backgroundSelected]];
    } else {
        background = [UIImage imageNamed:[NSString stringWithFormat:@"%@-3-5-Inch-Blurred.png", backgroundSelected]];
    }
    
    [backgroundView setImage:background];
    
    NSString *alarmSetDate = [_prefs stringForKey:@"alarmDate"];
    NSLog(@"AlarmSetDate = %@", alarmSetDate);
    
    if (alarmSetDate == nil || alarmSetDate == NULL) {
        [[self alarmSetToLabel] setText:@"-Not Set-"];
    } else {
        [[self alarmSetToLabel] setText:alarmSetDate];
    }
    
    
    if (alarmSet) {
        [setItem setTitle:@"Change Alarm"];
    } else {
        [setItem setTitle:@"Set Alarm"];
    }
    
    cancelItem.enabled = alarmSet;
    
    _repeatUnit = [_prefs integerForKey:@"repeatUnit"];
    NSLog(@"repeatUnit = %lu", (unsigned long)_repeatUnit);
    
    if (!(_repeatUnit == 4 || _repeatUnit == 8 || _repeatUnit == 16 || _repeatUnit == 32 || _repeatUnit == 64 || _repeatUnit == 8192)) {
        _repeatUnit = 8;
    }
    
    [self editAlarmRepeatIntervalWithInteger:_repeatUnit];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view setNeedsDisplay];
}

#pragma mark - Custom Functions

- (void)done
{
    BOOL isIphone5 = IS_IPHONE_5;
    
    [UIView animateWithDuration:0.0
                     animations:nil
                     completion:^(BOOL completed) {
                         [UIView animateWithDuration:0.5
                                               delay:0.0 usingSpringWithDamping:500.0f
                               initialSpringVelocity:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              [self->_pickerView setFrame:CGRectMake(0, isIphone5 == YES ? 612 : 524, 320, 216)];
                                              [self->_toolbar setFrame:CGRectMake(0, isIphone5 == YES ? 568 : 480, 320, 44)];
                                          }
                                          completion:nil];
                     }];
}

- (IBAction)set:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    
    NSString *dateTimeString = [dateFormatter stringFromDate:[datePicker date]];
    NSLog(@"dateTimeString = %@", dateTimeString);
    
    NSLog(@"Alarm Set Button Tapped: %@", dateTimeString);
    
    [self scheduleLocalNotificationWithDate:[datePicker date]];
    
    [_prefs setObject:dateTimeString forKey:@"alarmDate"];
    
    NSDate *alarmDate = [_prefs objectForKey:@"alarmDate"];

    if (alarmDate == nil || alarmDate == NULL) {
        [[self alarmSetToLabel] setText:NSLocalizedString(@"-Not Set-", @"-Not Set-")];
    } else {
        [[self alarmSetToLabel] setText:[_prefs stringForKey:@"alarmDate"]];
    }
    
    alarmSet = YES;
    
    [[self tabBarItem] setImage:[UIImage imageNamed:@"AlarmOn.png"]];
    [[self tabBarItem] setSelectedImage:[UIImage imageNamed:@"AlarmOn.png"]];
    
    [self showMessage:NSLocalizedString(@"Alarm Set", @"Alarm Set")];
    
    [_prefs setObject:@"yes" forKey:@"alarmSet"];
    
    [setItem setTitle:@"Change Alarm"];
    cancelItem.enabled = alarmSet;
}

- (IBAction)cancel:(id)sender
{
    NSLog(@"Alarm Cancel Button Tapped");
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    alarmSet = NO;
    
    [[self tabBarItem] setImage:[UIImage imageNamed:@"AlarmOff.png"]];
    [[self tabBarItem] setSelectedImage:[UIImage imageNamed:@"AlarmOff.png"]];
    
    [self showMessage:NSLocalizedString(@"Alarm Canceled", @"Alarm Canceled")];
    
    [_prefs setObject:@"no" forKey:@"alarmSet"];
    [_prefs setObject:nil forKey:@"alarmDate"];
    [_prefs setObject:nil forKey:@"alarmTime"];
    
    [[self alarmSetToLabel] setText:NSLocalizedString(@"-Not Set-", @"-Not Set-")];
    
    [setItem setTitle:@"Set Alarm"];
    cancelItem.enabled = alarmSet;
}

- (IBAction)repeat:(id)sender
{
    NSLog(@"Repeat");
    
    BOOL isIphone5 = IS_IPHONE_5;
    
    [UIView animateWithDuration:0.0
                     animations:nil
                     completion:^(BOOL completed) {
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                              usingSpringWithDamping:500.0f
                               initialSpringVelocity:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              [self->_pickerView setFrame:CGRectMake(0, isIphone5 ? 352 : 264, 320, 216)];
                                              [self->_toolbar setFrame:CGRectMake(0, isIphone5 == YES ? 308 : 220, 320, 44)];
                                          }
                                          completion:nil];
                     }];
}

- (void)scheduleLocalNotificationWithDate:(NSDate *)date
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    float number = [_prefs floatForKey:@"alarm_number"];
    NSLog(@"The Alarm Number is: %f", number);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSLog(@"Date = %@", date);
    [_prefs setObject:date forKey:@"alarmTime"];
    
    NSDate *repeatDate = [NSDate date];
    repeatDate = [repeatDate dateByAddingTimeInterval:1*24*60*60];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *alarmMessage = [userDefault stringForKey:@"alarmMessage"];
    
    if (alarmMessage == NULL || alarmMessage == nil || [alarmMessage isEqualToString:@"(null)"]) {
        alarmMessage = NSLocalizedString(@"Start Running!", @"Start Running!");
    }
    
    notification.alertBody = alarmMessage;
    notification.soundName = @"Alarm.aiff";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    NSUInteger repeatIntervalInt = [_prefs integerForKey:@"repeatUnit"];
    NSLog(@"Repeat Interval Int = %lu", (unsigned long)repeatIntervalInt);
    
    notification.repeatInterval = repeatIntervalInt;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)changeLocalNotification:(NSUInteger)unit withDate:(NSDate *)date
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    
    NSString *alarmMessage = [_prefs stringForKey:@"alarmMessage"];
    if (!alarmMessage || [alarmMessage isEqualToString:@""]) {
        alarmMessage = @"Start Running!";
        [_prefs setObject:@"Start Running!" forKey:@"alarmMessage"];
    }
    
    notification.alertBody = alarmMessage;
    notification.soundName = @"Alarm.aiff";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = unit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)showMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alarm", @"Alarm") message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UIPickerView Delegate/DataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 6;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *timeIntervalString;
    
    switch (row) {
        case 0:
            timeIntervalString = @"Repeat Yearly";
            break;
            
        case 1:
            timeIntervalString = @"Repeat Monthly";
            break;
            
        case 2:
            timeIntervalString = @"Repeat Weekly";
            break;
            
        case 3:
            timeIntervalString = @"Repeat Daily";
            break;
            
        case 4:
            timeIntervalString = @"Repeat Hourly";
            break;
            
        case 5:
            timeIntervalString = @"Repeat Every Minute";
            break;
            
        default:
            break;
    }
    
    return timeIntervalString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUInteger unit = 0;
    
    switch (row) {
        case 0:
            unit = NSCalendarUnitYear;
            break;
            
        case 1:
            unit = NSCalendarUnitMonth;
            break;
            
        case 2:
            unit = NSCalendarUnitWeekOfYear;
            break;
            
        case 3:
            unit = NSCalendarUnitDay;
            break;
            
        case 4:
            unit = NSCalendarUnitHour;
            break;
            
        case 5:
            unit = NSCalendarUnitMinute;
            break;
            
        default:
            break;
    }
    
    NSDate *date = (NSDate *)[_prefs objectForKey:@"alarmTime"];
    NSLog(@"date = %@", date);
    
    [_prefs setInteger:unit forKey:@"repeatUnit"];
    
    if (date != nil) {
        NSLog(@"Resetting date to scheduled interval.");
        [self changeLocalNotification:unit withDate:date];
    }
    
    [self editAlarmRepeatIntervalWithInteger:unit];
}

@end
