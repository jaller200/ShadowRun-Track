//
//  AlarmViewController.h
//  ShadowRun
//
//  Created by The Doctor on 11/29/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UIDatePicker *datePicker;
    BOOL alarmSet;
    
    __weak IBOutlet UIBarButtonItem *setAlarmButton;
    __weak IBOutlet UIBarButtonItem *cancelAlarmButton;
    
    IBOutlet UIToolbar *defaultToolbar;
    IBOutlet UIImageView *backgroundView;
    
    NSString *currentLanguage;
    NSUserDefaults *_prefs;
    NSUInteger _repeatUnit;
    
    UIPickerView *_pickerView;
    UIToolbar *_toolbar;
}

@property (weak, nonatomic) IBOutlet UILabel *alarmSetToLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *setItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;

- (void)scheduleLocalNotificationWithDate:(NSDate *)date;
- (void)showMessage:(NSString *)message;

- (IBAction)set:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)repeat:(id)sender;

@end
