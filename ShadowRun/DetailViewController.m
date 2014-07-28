//
//  DetailViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "DetailViewController.h"
#import "ShadowRun.h"
#import "ShadowRunStore.h"
#import "ShadowRunViewController.h"
#import "NotesViewController.h"
#import "UIImage+ImageEffects.h"

#import "ShadowRunAppDelegate.h"

@implementation UITextField (Additions)

- (void)setSuffixText:(NSString *)suffix;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:self.font.fontName size:self.font.pointSize]];
    [label setTextColor:self.textColor];
    [label setAlpha:.5];
    [label setText:suffix];
    
    UIFont *font = label.font;
    
    CGSize suffixSize;
    NSDictionary *attrs = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    suffixSize = [suffix sizeWithAttributes:attrs];
    
    label.frame = CGRectMake(0, 0, suffixSize.width, self.frame.size.height);
    
    [self setRightView:label];
    [self setRightViewMode:UITextFieldViewModeAlways];
}

@end

@implementation DetailViewController

#pragma mark - Synthesize Methods
@synthesize dismissBlock, run, speed;
@synthesize datePicker, pickerView, timeOfDayPickerView;
@synthesize notesButton;
@synthesize timeField = timeField;
@synthesize defaultToolbar;
@synthesize embedView = embedView;

// PickerView Methods
@synthesize pickerRun;

#pragma mark - INIT Functions

- (id)initForNewRun:(BOOL)isNew isFromStopwatch:(BOOL)isFromStopwatch
{
    if (IS_IPHONE_5) {
        if (isNew) {
            self = [super initWithNibName:@"DetailViewController~5NewRun" bundle:nil];
        } else {
            self = [super initWithNibName:@"DetailViewController~5" bundle:nil];
        }
    } else {
        if (isNew) {
            self = [super initWithNibName:@"DetailViewController~4NewRun" bundle:nil];
        } else {
            self = [super initWithNibName:@"DetailViewController~4" bundle:nil];
        }
    }
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
            
            isNewRun = YES;
            
            self.navigationController.navigationBar.delegate = self;
            
            [[self navigationController] disablesAutomaticKeyboardDismissal];
        }
        
        if (isFromStopwatch) {
            isFromStopwatchBOOL = YES;
        } else {
            isFromStopwatchBOOL = NO;
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (void)setRun:(ShadowRun *)r
{
    run = r;
    [[self navigationItem] setTitle:[run runTitle]];
}

- (void)setSpeed:(float)s
{
    speed = s;
}

#pragma mark - View Functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    defaultToolbar.barStyle = UIBarStyleDefault;
    defaultToolbar.translucent = YES;
    defaultToolbar.alpha = 0.94;
    
    [titleField setDelegate:self];
    
    runTypeField.delegate = self;
    runTypeField.tag = 3005;
    timeOfDayField.delegate = self;
    timeOfDayField.tag = 30061;
    
    dateButton.titleLabel.textAlignment = NSTextAlignmentLeft;

    ShadowRunAppDelegate *appDelegate = (ShadowRunAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInteger defaultHeight = 0;
    
    if (IS_IPHONE_5) {
        defaultHeight = 614;
        isIphone5 = YES;
    } else {
        defaultHeight = 544;
        isIphone5 = NO;
    }
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, defaultHeight, 320, 216)];
    [datePicker setHidden:NO];
    [[appDelegate window] insertSubview:datePicker aboveSubview:[[[appDelegate window] rootViewController] view]];
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, defaultHeight, 320, 44)];
    [toolbar setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    [toolbar setHidden:NO];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backgroundTapped:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = [NSArray arrayWithObjects:flexSpace, doneItem, nil];
    [[appDelegate window] insertSubview:toolbar aboveSubview:[[[appDelegate window] rootViewController] view]];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, defaultHeight, 320, 216)];
    [pickerView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    [pickerView setHidden:NO];
    [[appDelegate window] insertSubview:pickerView aboveSubview:[[[appDelegate window] rootViewController] view]];
    
    timeOfDayPickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, defaultHeight, 320, 216)];
    [timeOfDayPickerView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    [timeOfDayPickerView setHidden:NO];
    [[appDelegate window] insertSubview:timeOfDayPickerView aboveSubview:[[[appDelegate window] rootViewController] view]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Create the accessory toolbar
    UIToolbar *accessoryToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *doneAccessItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backgroundTapped:)];
    UIBarButtonItem *flexAccessSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [accessoryToolbar setItems:[NSArray arrayWithObjects:flexAccessSpace, doneAccessItem, nil] animated:NO];
    
    
    // Create the keyboard accessory views
    [titleField setInputAccessoryView:accessoryToolbar];
    [timeField setInputAccessoryView:accessoryToolbar];
    [distanceField setInputAccessoryView:accessoryToolbar];
    [temperatureField setInputAccessoryView:accessoryToolbar];
    
    // Create the keyboard appearance
    NSString *theme = [prefs stringForKey:@"keyboardAppearance"];
    
    NSLog(@"theme = %@", theme);
    
    if ([theme isEqualToString:@"light"]) {
        [titleField setKeyboardAppearance:UIKeyboardAppearanceLight];
        [distanceField setKeyboardAppearance:UIKeyboardAppearanceLight];
        [timeField setKeyboardAppearance:UIKeyboardAppearanceLight];
        [temperatureField setKeyboardAppearance:UIKeyboardAppearanceLight];
        [pickerView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [timeOfDayPickerView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [datePicker setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [toolbar setBarStyle:UIBarStyleDefault];
        [accessoryToolbar setBarStyle:UIBarStyleDefault];
        
        
        // - This is info for the theme options (migrated from Keyboard Appearance) that will
        // - Be release in Release 2.1.0
        /*[defaultToolbar setBarStyle:UIBarStyleDefault];
        
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBarController.tabBar.translucent = YES;
        self.tabBarController.tabBar.alpha = 0.94;*/
    } else {
        [titleField setKeyboardAppearance:UIKeyboardAppearanceDark];
        [distanceField setKeyboardAppearance:UIKeyboardAppearanceDark];
        [timeField setKeyboardAppearance:UIKeyboardAppearanceDark];
        [temperatureField setKeyboardAppearance:UIKeyboardAppearanceDark];
        [pickerView setBackgroundColor:[UIColor colorWithWhite:0.222 alpha:1]];
        [timeOfDayPickerView setBackgroundColor:[UIColor colorWithWhite:0.222 alpha:1]];
        [datePicker setBackgroundColor:[UIColor colorWithWhite:0.222 alpha:1]];
        [toolbar setBarStyle:UIBarStyleBlack];
        [accessoryToolbar setBarStyle:UIBarStyleBlack];
        
        
        // - This is info for the theme options (migrated from Keyboard Appearance) that will
        // - Be release in Release 2.1.0
        /*[defaultToolbar setBarStyle:UIBarStyleBlackTranslucent];
        
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.tabBarController.tabBar.barTintColor = [UIColor blackColor];
        self.tabBarController.tabBar.translucent = YES;
        self.tabBarController.tabBar.alpha = 0.94;*/
    }
    
    
    // Create the background UIImage....
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    UIImage *background;
    
    // .... and populate it with the correct image
    if (IS_IPHONE_5) {
        background = [UIImage imageNamed:[NSString stringWithFormat:@"%@-4-Inch-Blurred.png", backgroundSelected]];
    } else {
        background = [UIImage imageNamed:[NSString stringWithFormat:@"%@-3-5-Inch-Blurred.png", backgroundSelected]];
    }
    
    [backgroundView setImage:background];
    
    
    // Set delegates and tags for UITextViews
    [distanceField setDelegate:self];
    [timeField setDelegate:self];
    [titleField setDelegate:self];
    
    [distanceField setTag:2013];
    [timeField setTag:2014];
    [titleField setTag:2016];
    
    // No need for this right now, I can just use UILabel in IB
    //[timeField setSuffixText:NSLocalizedString(@"Minutes", @"Minutes")];
    
    [titleField setText:[run runTitle]];
    
    // Create the number formatter and trim the distance and speed to 2 decimal places
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormat setMaximumFractionDigits:2];
    
    [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run speed]]]]];
    
    NSLog(@"%f", [run speed]);
    
    // isFromStopwatchBOOL not fully implemented... isFromStopwatchBOOL is always YES
    if (isFromStopwatchBOOL) {
        NSLog(@"DetailViewController - isFromStopwatchBOOL = YES");
        [timeField setText:[NSString stringWithFormat:@"%.2f", speed]];
    } else {
        NSLog(@"DetailViewController - isFromStopwatchBOOL = NO");
        [timeField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run time]]]]];
    }

    // Now optimize numFormat for temperature - 1 decimal place
    [numFormat setMaximumFractionDigits:1];
    
    float runTemp = [run temperature];
    
    if (runTemp == 0) {
        [temperatureField setText:@""];
    } else {
        [temperatureField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run temperature]]]]];
    }
    
    // Create the date formatters and set the dates
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [run dateCreated];
    [dateButton setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
    
    // Set the run type
    NSString *typeLabel = [[run type] valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = NSLocalizedString(@"No Run Type", @"No Run Type");
    }
    [runTypeField setText:[NSString stringWithFormat:@"%@", typeLabel]];
    
    [self calculateAveragePace];
    
    NSLog(@"DetailViewController - IsNewRun = %d", isNewRun);
    
    NSDateFormatter *todDateFormatter = [[NSDateFormatter alloc] init];
    [todDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [todDateFormatter setDateFormat:@"HH:mm:ss"];
    
    [todDateFormatter setDateFormat:@"h:mm a"];
    
    [timeOfDayField setText:[todDateFormatter stringFromDate:[run timeOfDay]]];
    
    if (isNewRun) {
        [run setMileKilos:@"miles"];
        [milesKilosButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Miles", @"Miles")] forState:UIControlStateNormal];
    } else {
        NSString *milesKilos = [run mileKilos];
        
        if ([milesKilos isEqualToString:@"miles"]) {
            [milesKilosButton setTitle:NSLocalizedString(@"Miles", @"Miles") forState:UIControlStateNormal];
        } else {
            [milesKilosButton setTitle:NSLocalizedString(@"Kilometers", @"Kilometers") forState:UIControlStateNormal];
        }
    }
    
    if (isNewRun) {
        [run setDegreesCelcius:@"degrees"];
        [degreesCelciusButton setTitle:[NSString stringWithFormat:@"°F"] forState:UIControlStateNormal];
    } else {
        NSString *degreesCelcius = [run degreesCelcius];
        
        if ([degreesCelcius isEqualToString:@"degrees"]) {
            [degreesCelciusButton setTitle:@"°F" forState:UIControlStateNormal];
        } else {
            [degreesCelciusButton setTitle:@"°C" forState:UIControlStateNormal];
        }
    }
    
    if ([[mphAverageLabel text] isEqualToString:@"nan"] || [[mphAverageLabel text] isEqualToString:@"inf"]) {
        [mphAverageLabel setText:@"0.00"];
    }
    
    [temperatureField setTag:2015];
    [temperatureField setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
    [self backgroundTapped:self];
    
    // Set the run entities objects
    [run setRunTitle:[titleField text]];
    [run setSpeed:[[distanceField text] floatValue]];
    [run setTime:[[timeField text] floatValue]];
    [run setTemperature:[[temperatureField text] floatValue]];
    
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormat setMaximumFractionDigits:2];
    
    [timeField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run time]]]]];
    [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run speed]]]]];
    
    [numFormat setMaximumFractionDigits:1];
    
    [temperatureField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run temperature]]]]];
    
    NSLog(@"%f", [run speed]);
    
    float avgPace = [self calculateAveragePace];
    [run setAvgMph:avgPace];
    
    BOOL success = [[ShadowRunStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"DetailViewController - Saved Run");
    } else {
        NSLog(@"DetailViewController - Could not save run");
    }
}

#pragma mark - TextField Delegate Methods

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)runType:(UITextField *)aTextField
{
    [aTextField endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePickerViews:self];
    
    if (textField.tag == 2013) {
        [textField becomeFirstResponder];
        
        if ([textField.text isEqual:@"0"]) {
            [textField setText:@""];
        }
        
        NSString *tempString = distanceField.text;
        NSRange range = [tempString rangeOfString:@".00"];
        
        if (range.location != NSNotFound) {
            distanceField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    
    if (textField.tag == 2014) {
        [textField becomeFirstResponder];
        
        if ([textField.text isEqualToString:@"0"]) {
            [textField setText:@""];
        }
        
        NSString *tempString = timeField.text;
        NSRange range = [tempString rangeOfString:@".00"];
        
        if (range.location != NSNotFound) {
            timeField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    
    if (textField.tag == 2015) {
        [textField becomeFirstResponder];
        
        if (IS_IPHONE_5) {

        } else {
            [UIView animateWithDuration:0.0
                             animations:^{
                                 self.embedView.frame = CGRectMake(0, 61, 320, isNewRun ? 371 : 323);
                             }
                             completion:^(BOOL success) {
                                 [UIView animateWithDuration:0.5
                                                       delay:0.0
                                      usingSpringWithDamping:500.0f
                                       initialSpringVelocity:0.0f
                                                     options:UIViewAnimationOptionCurveEaseIn
                                                  animations:^{
                                                      self.embedView.frame = CGRectMake(0, -30, 320, isNewRun ? 371 : 323);
                                                  }
                                                  completion:nil];
                             }];
        }
    
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.tag == 2013) {
        float distanceFloat = [[distanceField text] floatValue];
        [distanceField setText:[NSString stringWithFormat:@"%.2f", distanceFloat]];
        
        [distanceField resignFirstResponder];
        
        [distanceField setText:[distanceField.text stringByReplacingOccurrencesOfString:@".00" withString:@""]];
    }
    
    if (textField.tag == 2014) {
        float timeFloat = [[timeField text] floatValue];
        [timeField setText:[NSString stringWithFormat:@"%.2f", timeFloat]];
        
        [timeField resignFirstResponder];
        
        [timeField setText:[timeField.text stringByReplacingOccurrencesOfString:@".00" withString:@""]];
    }
    
    if (textField.tag == 2015) {
        [UIView animateWithDuration:0.0
                         animations:nil
                         completion:^(BOOL success) {
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                  usingSpringWithDamping:500.0f
                                   initialSpringVelocity:0.0f
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  if (!isIphone5) {
                                                      self.view.frame = CGRectMake(0, 0, 320, 480);
                                                  }
                                              }
                                              completion:nil];
                         }];
        [UIView commitAnimations];
    }

    [[self navigationItem] setTitle:[titleField text]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [titleField resignFirstResponder];
    [datePicker resignFirstResponder];
    
    if (![[temperatureField text] isEqualToString:@""]) {
        NSString *tempString = temperatureField.text;
        temperatureField.text = [tempString stringByAppendingString:@"°"];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 3005) {
        [distanceField endEditing:YES];
        [timeField endEditing:YES];
        [titleField endEditing:YES];
        [temperatureField endEditing:YES];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        
        [self showRunTypePicker:textField];
        
        [UIView commitAnimations];
        
        return NO;
    }
    
    if (textField.tag == 30061) {
        [distanceField endEditing:YES];
        [timeField endEditing:YES];
        [titleField endEditing:YES];
        [temperatureField endEditing:YES];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        
        [self showTimeOfDayPicker:textField];
        
        [UIView commitAnimations];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark - UIAlertView Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if (alertView.tag == 3001) {
        if ([title isEqualToString:NSLocalizedString(@"Yes", "Yes")]) {
            [self afterConvert:self];
        } else {
            return;
        }
    }
    
    if (alertView.tag == 3002) {
        if ([title isEqualToString:NSLocalizedString(@"Yes", "Yes")]) {
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
        } else {
            return;
        }
    }
}

#pragma mark - Custom Methods

- (IBAction)convert:(id)sender
{
    BOOL milesOrKilometers = [prefs boolForKey:@"miles_kilometers"];
    
    if (milesOrKilometers) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Convert", @"Convert")
                                                        message:NSLocalizedString(@"Convert the current distance to Miles (rounded)?", @"Convert the current distance to Miles (rounded)?")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"No", @"No")
                                              otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
        alertView.tag = 3001;
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Convert", @"Convert")
                                                            message:NSLocalizedString(@"Convert the current distance to Kilometers (rounded)?", @"Convert the current distance to Kilometers (rounded)?")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"No", @"No")
                                                  otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
        alertView.tag = 3001;
        [alertView show];
    }
}

- (IBAction)afterConvert:(id)sender
{
    BOOL milesOrKilometers = [prefs boolForKey:@"miles_kilometers"];
    
    if (milesOrKilometers) {
        NSLog(@"DetailViewController - Converting to Miles");
        
        float kilometers = [[distanceField text]  floatValue];
        
        float miles = kilometers * 0.621371;
        
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        [numFormat setMaximumFractionDigits:2];
        
        [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:miles]]]];
    } else {
        NSLog(@"DetailViewController - Converting to Kilometers");
        
        float miles = [[distanceField text] floatValue];
        
        float kilometers = miles * 1.60934;
        
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        [numFormat setMaximumFractionDigits:2];
        
        [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:kilometers]]]];
    }
}

- (void)save:(id)sender
{
    if ([[titleField text] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning!", @"Warning!") message:NSLocalizedString(@"You have not given this run a name. Would you like to proceed without one?", @"You have not given this run a name. Would you like to proceed without one?") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"No") otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
        alertView.tag = 3002;
        [alertView show];
    } else {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
    }
}

- (void)cancel:(id)sender
{
    [[ShadowRunStore sharedStore] removeRun:run];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (IBAction)addNotes:(id)sender
{
    NSLog(@"DetailViewController - Add Notes...");
    
    NotesViewController *notesViewController = [[NotesViewController alloc] init];
    
    //[notesViewController setRun:run];
    [notesViewController setDismissBlock:^{[self.view setNeedsDisplay];}];
    [notesViewController setRun:run];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:notesViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [distanceField resignFirstResponder];
    [timeField resignFirstResponder];
    [titleField resignFirstResponder];
}

- (IBAction)changeMilesKilos:(id)sender
{
    NSString *milesKilos = [run mileKilos];
    
    if ([milesKilos isEqualToString:@"miles"]) {
        NSLog(@"DetailViewController - Changing to Kilos");
        [run setMileKilos:@"kilos"];
        [milesKilosButton setTitle:NSLocalizedString(@"Kilometers", @"Kilometers") forState:UIControlStateNormal];
    } else if ([milesKilos isEqualToString:@"kilos"]) {
        NSLog(@"DetailViewController - Changing to Miles");
        [run setMileKilos:@"miles"];
        [milesKilosButton setTitle:NSLocalizedString(@"Miles", @"Miles") forState:UIControlStateNormal];
    } else {
        NSLog(@"DetailViewController - Undefined value for mileKilos...Changing to \"Miles\"");
        [run setMileKilos:@"miles"];
        [milesKilosButton setTitle:NSLocalizedString(@"Miles", @"Miles") forState:UIControlStateNormal];
    }
}

- (IBAction)changeDegreesCelcius:(id)sender
{
    NSString *degreesCelcius = [run degreesCelcius];
    
    if ([degreesCelcius isEqualToString:@"degrees"]) {
        NSLog(@"DetailViewController - Changing to Celcius");
        [run setDegreesCelcius:@"celcius"];
        [degreesCelciusButton setTitle:@"°C" forState:UIControlStateNormal];
    } else if ([degreesCelcius isEqualToString:@"celcius"]) {
        NSLog(@"DetailViewController - Chaning to Degrees");
        [run setDegreesCelcius:@"degrees"];
        [degreesCelciusButton setTitle:@"°F" forState:UIControlStateNormal];
    } else {
        NSLog(@"DetailViewController - Undefined value to degreesCelcius...Changing to \"Farenheight\"");
        [run setDegreesCelcius:@"degrees"];
        [degreesCelciusButton setTitle:@"°F" forState:UIControlStateNormal];
    }
}

#pragma mark - RunType Picker Methods

- (IBAction)showRunTypePicker:(id)sender
{
    [pickerView endEditing:YES];
    
    [self hidePickerViews:self];
    
    NSLog(@"isIphone5 = %d", isIphone5 ? 1 : 0);
    
    [UIView animateWithDuration:0 delay:0.0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.embedView.frame = CGRectMake(0, 61, 320, isIphone5 ? 414 : 323);
                        }
                     completion:^(BOOL success) {
                            [UIView animateWithDuration:.5
                                                  delay:0.0
                                 usingSpringWithDamping:500.0f
                                  initialSpringVelocity:0.0f
                                                options:UIViewAnimationOptionCurveEaseIn
                                             animations:^{
                                                toolbar.frame = CGRectMake(0, isIphone5 ? 308 : 220, 320, 44);
                                                pickerView.frame = CGRectMake(0, isIphone5 ? 352 : 264, 320, 216);
                                                  
                                                  
                                                if (isIphone5 == NO) {
                                                    self.embedView.frame = CGRectMake(0, 50, 320, 323);
                                                }
                                            }
                                             completion:nil];
                            }];
    
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    
    NSString *type = [runTypeField text];
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    int objectIndex;
    
    for (NSManagedObjectContext *object in [[ShadowRunStore sharedStore] allRunTypes]) {
        NSString *runType = [object valueForKey:@"label"];
        [finalArray addObject:runType];
    }
    
    for (objectIndex = 0; objectIndex < [finalArray count]; objectIndex++) {
        if ([finalArray[objectIndex] isEqualToString:type]) {
            break;
        }
    }
    
    NSLog(@"objectIndex = %d", objectIndex);
    
    [pickerView selectRow:objectIndex inComponent:0 animated:NO];
    
    [UIView commitAnimations];
}

#pragma mark - TimeOfDay Methods

- (IBAction)showTimeOfDayPicker:(id)sender
{
    NSLog(@"DetailViewController - TimeOfDay Set");

    timeOfDayPickerView.hidden = NO;
    toolbar.hidden = NO;
    
    [self hidePickerViews:self];
    
    [UIView animateWithDuration:0.0
                     animations:^{
                         self.embedView.frame = CGRectMake(0, 61, 320, isIphone5 ? 414 : 323);
                     }
                     completion:^(BOOL success) {
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                              usingSpringWithDamping:500.0f
                               initialSpringVelocity:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              toolbar.frame = CGRectMake(0, isIphone5 ? 308 : 220, 320, 44);
                                              timeOfDayPickerView.frame = CGRectMake(0, isIphone5 ? 352 : 264, 320, 216);
                                              
                                              if (!isIphone5) {
                                                  self.embedView.frame = CGRectMake(0, 15, 320, 323);
                                              }
                                          }
                                          completion:nil];
                     }];
    
    [timeOfDayPickerView setDatePickerMode:UIDatePickerModeTime];
    [timeOfDayPickerView setDate:[run timeOfDay] animated:NO];
    
    [timeOfDayPickerView addTarget:self action:@selector(changeTimeOfDay:) forControlEvents:UIControlEventValueChanged];
    
    [UIView commitAnimations];
}
     
- (IBAction)changeTimeOfDay:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    NSString *TODString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[timeOfDayPickerView date]]];
    [timeOfDayField setText:TODString];
    
    [run setTimeOfDay:[dateFormatter dateFromString:TODString]];
    NSLog(@"DetailViewController - Time Of Day: %@", [run timeOfDay]);
}

#pragma mark - Custom Date Methods

// Show DateChange pickerView
- (IBAction)changeDate:(id)sender
{
    NSLog(@"DetailViewController - Changing date.");
    
    [self hidePickerViews:self];
    
    [UIView animateWithDuration:0.0
                     animations:^{
                         self.embedView.frame = CGRectMake(0, 61, 320, isIphone5 ? 414 : 323);
                     } completion:^(BOOL success) {
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                              usingSpringWithDamping:500.0f
                               initialSpringVelocity:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.datePicker.frame = CGRectMake(0, isIphone5 ? 352 : 264, 320, 216);
                                              toolbar.frame = CGRectMake(0, isIphone5 ? 308 : 220, 320, 44);
                                              
                                              self.embedView.frame = CGRectMake(0, isIphone5 ? 0 : -80, 320, isIphone5 ? 414 : 323);
                                          }
                                          completion:nil];
                     }];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[run dateCreated] animated:NO];
    
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [UIView commitAnimations];
}

- (void)dateChange:(id)sender
{
    // Change date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[datePicker date]]];
    [dateButton setTitle:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[datePicker date]]] forState:UIControlStateNormal];
    
    [run setDateCreated:[dateFormatter dateFromString:dateString]];
    NSLog(@"Date String: %@", dateString);
}

#pragma mark - MPH Methods

- (float)calculateAveragePace
{
    NSString *timeString = [timeField text];
    NSLog(@"timeString = %@", timeString);
    
    NSString *fractionPart = @"00";
    float timeStringFloat;
    float fractionPartFloat;
    
    for (int x = 0; x < 10; x++) {
        for (int y = 0; y < 10; y++) {
            NSRange range = [timeString rangeOfString:[NSString stringWithFormat:@".%d%d", x, y]];
            NSLog(@".%d%d", x, y);
            
            
            if (range.location != NSNotFound) {
                fractionPart = [NSString stringWithFormat:@"%d%d", x, y];
                
                timeString = [timeString stringByReplacingCharactersInRange:range withString:@""];
                
                timeStringFloat = [timeString floatValue];
                fractionPartFloat = [fractionPart floatValue];
                
                NSLog(@"fractionPart = %f, wholeNumber = %f", fractionPartFloat, timeStringFloat);
            } else {
                NSLog(@"Not found!");
            }
        }
        
        NSRange range = [timeString rangeOfString:[NSString stringWithFormat:@".%d", x]];
        NSLog(@".%d", x);
        
        if (range.location != NSNotFound) {
            int zero = 0;
            
            fractionPart = [NSString stringWithFormat:@"%d%d", x, zero];
            
            timeString = [timeString stringByReplacingCharactersInRange:range withString:@""];
            
            timeStringFloat = [timeString floatValue];
            fractionPartFloat = [fractionPart floatValue];
        } else {
            NSLog(@"Not found!");
        }
    }
    
    float minutesSec = [timeString floatValue] * 60;
    float seconds = [fractionPart floatValue];
    float distance = [[distanceField text] floatValue];
    NSLog(@"distance floatValue = %f", distance);
    
    float averagePace = ((minutesSec + seconds)/distance)/60;
    
    NSLog(@"averagePace = %f", averagePace);
    
    [mphAverageLabel setText:[NSString stringWithFormat:@"%.2f", averagePace]];
    
    if ([[mphAverageLabel text] isEqualToString:@"nan"] || [[mphAverageLabel text] isEqualToString:@"inf"]) {
        [mphAverageLabel setText:@"0.00"];
    }
    
    return averagePace;
}

// Currently unused method...may use in future, so I will keep it.
/*- (float)calculateMph
{
    float miles = [[distanceField text] floatValue];
    float timeInMin = [[timeField text] floatValue];
    
    float time = timeInMin / 60;
    
    float mph = miles / time;
    
    BOOL milesOrKilometers = [prefs boolForKey:@"miles_kilometers"];
    
    NSString *mphAvg = nil;
    
    if (milesOrKilometers) {
        mphAvg = [NSString stringWithFormat:@"%.2f MPH", mph];
    } else {
        mphAvg = [NSString stringWithFormat:@"%2.f KPH", mph];
    }
    
    [mphAverageLabel setText:mphAvg];
    
    if (milesOrKilometers) {
        if ([[mphAverageLabel text] isEqualToString:@"nan MPH"]) {
            [mphAverageLabel setText:@"0.00 MPH"];
            [run setAvgMph:0.00];
            return 0.00;
        } else if ([[mphAverageLabel text] isEqualToString:@"inf MPH"]) {
            [mphAverageLabel setText:@"0.00 MPH"];
            [run setAvgMph:0.00];
            return 0.00;
        }
    } else {
        if ([[mphAverageLabel text] isEqualToString:@"nan KPH"]) {
            [mphAverageLabel setText:@"0.00 KPH"];
            [run setAvgMph:0.00];
            return 0.00;
        }else if ([[mphAverageLabel text] isEqualToString:@"inf KPH"]) {
            [mphAverageLabel setText:@"0.00 KPH"];
            [run setAvgMph:0.00];
            return 0.00;
        }
    }
    
    [run setAvgMph:mph];
    
    return mph;
}*/

#pragma mark - Other Methods

- (IBAction)backgroundTapped:(id)sender
{
    NSLog(@"DetailViewController - Background Tapped");
    
    // Hide all pickerviews/toolbars
    [self hidePickerViews:self];
    
    // End all editing
    [runTypeField endEditing:YES];
    [temperatureField endEditing:YES];
    [timeField endEditing:YES];
    [distanceField endEditing:YES];
    [titleField endEditing:YES];
    [pickerView endEditing:YES];
    [temperatureField endEditing:YES];
    [timeOfDayPickerView endEditing:YES];
    
    // Set the run distance/time for the entity
    [run setTime:[[timeField text] floatValue]];
    [run setSpeed:[[distanceField text] floatValue]];
    
    // Set the text field distance/time
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormat setMaximumFractionDigits:2];
    
    [timeField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run time]]]]];
    [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run speed]]]]];
    
    [UIView commitAnimations];
    [self calculateAveragePace];
}

- (IBAction)hidePickerViews:(id)sender
{
    NSLog(@"datePicker is not hidden");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    [UIView animateWithDuration:0.0
                     animations:nil
                     completion:^(BOOL success) {
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                              usingSpringWithDamping:500.0f
                               initialSpringVelocity:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.embedView.frame = CGRectMake(0, 61, 320, isIphone5 ? 414 : 323);
                                              toolbar.frame = CGRectMake(0, isIphone5 ? 568 : 480, 320, 44);
                                              datePicker.frame = CGRectMake(0, isIphone5 ? 612 : 524, 320, 216);
                                              pickerView.frame = CGRectMake(0, isIphone5 ? 612 : 524, 320, 216);
                                              timeOfDayPickerView.frame = CGRectMake(0, isIphone5 ? 612 : 524, 320, 216);
                                          }
                                          completion:nil];
                     }];
    
    [UIView commitAnimations];
}

#pragma mark - PickerView Methods/Delegate Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[ShadowRunStore sharedStore] allRunTypes] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *allTypes = [[ShadowRunStore sharedStore] allRunTypes];
    NSManagedObject *runType = [allTypes objectAtIndex:row];
    NSString *typeLabel = [runType valueForKey:@"label"];
    
    return typeLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *allTypes = [[ShadowRunStore sharedStore] allRunTypes];
    NSManagedObject *runType = [allTypes objectAtIndex:row];
    [run setType:runType];
    
    NSString *typeLabel = [[run type] valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = NSLocalizedString(@"No Run Type", @"No Run Type");
    }
    [runTypeField setText:[NSString stringWithFormat:@"%@", typeLabel]];
}

@end
