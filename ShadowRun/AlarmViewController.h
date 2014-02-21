//
//  AlarmViewController.h
//  ShadowRun
//
//  Created by The Doctor on 11/29/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmViewController : UIViewController
{
    IBOutlet UIDatePicker *datePicker;
    BOOL alarmSet;
}

@property (weak, nonatomic) IBOutlet UILabel *alarmSetToLabel;

- (void)scheduleLocalNotificationWithDate:(NSDate *)date;
- (void)showMessage:(NSString *)message;

- (IBAction)set:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)setAlarmLength:(id)sender;

@end
