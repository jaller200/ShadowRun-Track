//
//  DetailViewController.h
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke.
//

#import <UIKit/UIKit.h>

@class ShadowRun;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIAlertViewDelegate, UINavigationBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    // Outlets
    __weak IBOutlet UITextField *titleField;
    __weak IBOutlet UITextField *distanceField;
    __weak IBOutlet UITextField *runTypeField;
    __weak IBOutlet UITextField *temperatureField;
    __weak IBOutlet UITextField *timeOfDayField;
    __weak IBOutlet UIButton *runTypeButton;
    __weak IBOutlet UIButton *dateButton;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *mphAverageLabel;
    __weak IBOutlet UILabel *mphAverageLabelLabel;
    __weak IBOutlet UITextView *textViewView;
    __weak IBOutlet UIToolbar *defaultToolbar;
    __weak IBOutlet UIButton *milesKilosButton;
    __weak IBOutlet UIButton *degreesCelciusButton;
    
    // Objects
    UIToolbar *toolbar;
    
    // Variables
    BOOL isNewRun;
    BOOL isFromStopwatchBOOL;
    BOOL isMiles;
}

#pragma mark - Actions/Variables/Etc.
// Objects
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIDatePicker *timeOfDayPickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (nonatomic, strong) ShadowRun *pickerRun;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *changeDateButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *notesButton;
@property (weak, nonatomic) IBOutlet UITextField *timeField;

// Strings
@property (nonatomic) NSString *stopwatchTimeString;

// Variables
@property (nonatomic) float speed;

// ShadowRun
@property (nonatomic, strong) ShadowRun *run;
@property (nonatomic, copy) void (^dismissBlock)(void);

@property (weak, nonatomic) IBOutlet UIToolbar *defaultToolbar;

// IDs
- (id)initForNewRun:(BOOL)isNew isFromStopwatch:(BOOL)isFromStopwatch;

// Actions
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)hidePickerView:(id)sender;
- (IBAction)showRunTypePicker:(UITextField *)sender;
- (IBAction)showTimeOfDayPicker:(id)sender;

- (IBAction)changeTimeOfDay:(id)sender;
- (IBAction)changeDate:(id)sender;
- (IBAction)convert:(id)sender;
- (IBAction)calculateTime:(id)sender;

- (IBAction)addNotes:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

- (float)calculateMph;
- (float)calculateAveragePace;

- (IBAction)changeMilesKilos:(id)sender;
- (IBAction)changeDegreesCelcius:(id)sender;

@end
