//
//  DetailViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke.
//

#import "DetailViewController.h"
#import "ShadowRun.h"
#import "ShadowRunStore.h"
#import "RunTypePicker.h"
#import "ShadowRunViewController.h"
#import "NotesViewController.h"
#import "ILTranslucentView.h"

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
    NSDictionary *attrs = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize suffixSize = [suffix sizeWithAttributes:attrs];
    label.frame = CGRectMake(0, 0, suffixSize.width, self.frame.size.height);
    
    [self setRightView:label];
    [self setRightViewMode:UITextFieldViewModeAlways];
}

@end

@implementation DetailViewController

#pragma mark - Synthesize Methods
@synthesize dismissBlock, run, speed;
@synthesize datePicker, pickerView, timeOfDayPickerView;
@synthesize changeDateButton, notesButton;
@synthesize timeField = timeField;
@synthesize defaultToolbar;
@synthesize stopwatchTimeString;

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
            
            isMiles = YES;
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
        
    //UIColor *clr = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
    //[[self view] setBackgroundColor:clr];
    [[self view] setAlpha:0.85];
    
    if (IS_IPHONE_5) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lopez-4~5.png"]];
        [imageView setFrame:self.view.frame];
        
        [self.view insertSubview:imageView atIndex:0];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
        [imageView setFrame:self.view.frame];
    
        [self.view insertSubview:imageView atIndex:0];
    }
    
    [titleField setDelegate:self];

    [textViewView setDelegate:self];
    
    if ([[textViewView text] isEqualToString:@""]) {
        [textViewView setText:@"Notes..."];
        [textViewView setTextColor:[UIColor lightGrayColor]];
    } else {
        [textViewView setTextColor:[UIColor blackColor]];
        [textViewView setText:[run runNotes]];
    }
    
    if (isNewRun) {
        [mphAverageLabelLabel setHidden:YES];
        [mphAverageLabel setHidden:YES];
    }
    
    runTypeField.delegate = self;
    runTypeField.tag = 3005;
    timeOfDayField.delegate = self;
    timeOfDayField.tag = 30061;
    
    dateButton.titleLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //BOOL milesOrKm = [prefs boolForKey:@"miles_kilometers"];
    
    /*if (milesOrKm) {
        [distanceField setSuffixText:@"Miles"];
    } else {
        [distanceField setSuffixText:@"Kilometers"];
    }*/
    
    [distanceField setDelegate:self];
    [timeField setDelegate:self];
    
    [distanceField setTag:2013];
    [timeField setTag:2014];
    
    [timeField setSuffixText:@"Minutes"];
    
    [titleField setText:[run runTitle]];
    
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormat setMaximumFractionDigits:2];
    
    [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run speed]]]]];
    
    NSLog(@"%f", [run speed]);
    
    if (isFromStopwatchBOOL) {
        NSLog(@"DetailViewController - isFromStopwatchBOOL = YES");
        [timeField setText:[NSString stringWithFormat:@"%.2f", speed]];
    } else {
        NSLog(@"DetailViewController - isFromStopwatchBOOL = NO");
        //[timeField setText:[NSString stringWithFormat:@"%.2f", [run time]]];
        [timeField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run time]]]]];
    }
    
    [numFormat setMaximumFractionDigits:1];
    
    float runTemp = [run temperature];
    
    if (runTemp == 0) {
        [temperatureField setText:@""];
    } else {
        [temperatureField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run temperature]]]]];
    }
    
    /*if (![[temperatureField text] isEqualToString:@""]) {
        NSString *tempString = temperatureField.text;
        NSRange range = [tempString rangeOfString:@"°"];
        
        if (range.location == NSNotFound) {
            temperatureField.text = [tempString stringByAppendingString:@" °F"];
        }
    }*/
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [run dateCreated];
    [dateLabel setText:[dateFormatter stringFromDate:date]];
    [dateButton setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
    
    NSString *typeLabel = [[run type] valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = @"No Run Type";
    }
    [runTypeButton setTitle:[NSString stringWithFormat:@"Run Type: %@", typeLabel] forState:UIControlStateNormal];
    [runTypeField setText:[NSString stringWithFormat:@"%@", typeLabel]];
    
    if ([[textViewView text] isEqualToString:@""]) {
        [textViewView setText:@"Notes..."];
        [textViewView setTextColor:[UIColor lightGrayColor]];
    } else {
        [textViewView setTextColor:[UIColor blackColor]];
        [textViewView setText:[run runNotes]];
    }
    
    [self calculateMph];
    
    NSLog(@"DetailViewController - IsNewRun = %d", isNewRun);
    
    NSDateFormatter *todDateFormatter = [[NSDateFormatter alloc] init];
    [todDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [todDateFormatter setDateFormat:@"HH:mm:ss"];
    
    [todDateFormatter setDateFormat:@"h:mm a"];
    
    [timeOfDayField setText:[todDateFormatter stringFromDate:[run timeOfDay]]];
    
    if (isNewRun) {
        [run setMileKilos:@"miles"];
        [milesKilosButton setTitle:[NSString stringWithFormat:@"Miles"] forState:UIControlStateNormal];
    } else {
        NSString *milesKilos = [run mileKilos];
        
        if ([milesKilos isEqualToString:@"miles"]) {
            [milesKilosButton setTitle:@"Miles" forState:UIControlStateNormal];
        } else {
            [milesKilosButton setTitle:@"Kilometers" forState:UIControlStateNormal];
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
    
    [temperatureField setTag:2015];
    [temperatureField setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
    
    [run setRunTitle:[titleField text]];
    [run setSpeed:[[distanceField text] floatValue]];
    [run setTime:[[timeField text] floatValue]];
    [run setTemperature:[[temperatureField text] floatValue]];
    
    //[distanceField setText:[NSString stringWithFormat:@"%.2f", [run speed]]];
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormat setMaximumFractionDigits:2];
    
    [timeField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run time]]]]];
    [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run speed]]]]];
    
    [numFormat setMaximumFractionDigits:1];
    
    [temperatureField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run temperature]]]]];
    
    NSLog(@"%f", [run speed]);
    
    float avgMph = [self calculateMph];
    [run setAvgMph:avgMph];
    
    BOOL success = [[ShadowRunStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"DetailViewController - Saved Run");
    } else {
        NSLog(@"DetailViewController - Could not save run");
    }
    
    if ([[textViewView text] isEqualToString:@""]) {
        [textViewView setText:@"Notes..."];
        
        [textViewView setTextColor:[UIColor lightGrayColor]];
    } else {
        [textViewView setTextColor:[UIColor blackColor]];
        [textViewView setText:[run runNotes]];
    }
    
    // Alert view is not in the right place...Gonna fix this soon.....
    /*if ([[titleField text] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!"
                                                        message:@"The run does not have a name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }*/
    
    [datePicker setHidden:YES];
    [toolbar setHidden:YES];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (!parent) {
        NSLog(@"DetailViewController - Moving to Parent View Controller");
        ShadowRunViewController *shadowRunViewController = [[ShadowRunViewController alloc] init];
        [[shadowRunViewController view] setNeedsDisplay];
        [[shadowRunViewController tableView] reloadData];
    }
}

#pragma mark - TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    if (IS_IPHONE_5) {
        if (isNewRun) {
            self.view.frame = CGRectMake(0, -170, 320, 400);
        } else {
            self.view.frame = CGRectMake(0, -115, 320, 600);
        }
    } else {
        if (isNewRun) {
            self.view.frame = CGRectMake(0, -170, 320, 400);
        } else {
            self.view.frame = CGRectMake(0, -115, 320, 400);
        }
    }
    
    if ([[textViewView text] isEqualToString:@"Notes..."]) {
        [textViewView setText:@""];
        [textViewView setTextColor:[UIColor blackColor]];
    }
    [textViewView becomeFirstResponder];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([[textViewView text] isEqualToString:@""]) {
        [textViewView setTextColor:[UIColor lightGrayColor]];
        [textViewView setText:@"Notes..."];
    } else {
        [run setRunNotes:[textViewView text]];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    if (IS_IPHONE_5) {
        if (isNewRun) {
            self.view.frame = CGRectMake(0, 0, 320, 570);
        } else {
            self.view.frame = CGRectMake(0, 0, 320, 550);
        }
    } else {
        if (isNewRun) {
            self.view.frame = CGRectMake(0, 0, 320, 500);
        } else {
            self.view.frame = CGRectMake(0, 0, 320, 450);
        }
    }
    
    [textViewView resignFirstResponder];
    [UIView commitAnimations];
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
    //[textField becomeFirstResponder];
    
    if (textField.tag != 3005 || textField.tag != 30061) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        
        if (IS_IPHONE_5) {
            
        } else {
            self.view.frame = CGRectMake(0, 0, 320, 480);
        }
        
        [UIView commitAnimations];
        
        [pickerView endEditing:YES];
        [pickerView setHidden:YES];
        [toolbar setHidden:YES];
    }
    
    if (textField.tag == 2013) {
        [textField becomeFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        
        [pickerView setHidden:YES];
        [toolbar setHidden:YES];
        
        if (IS_IPHONE_5 == NO) {
            self.view.frame = CGRectMake(0, 0, 320, 480);
        }
        
        [UIView commitAnimations];
        
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
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        
        [pickerView setHidden:YES];
        [toolbar setHidden:YES];
        
        if (IS_IPHONE_5 == NO) {
            self.view.frame = CGRectMake(0, 0, 320, 480);
        }
        
        [UIView commitAnimations];
        
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
        NSLog(@"Cool");
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35];
        
        if (IS_IPHONE_5) {
            //self.view.frame = CGRectMake(0, -40, 320, 480);
            NSLog(@"YAY!");
        } else {
            self.view.frame = CGRectMake(0, -45, 320, 480);
        }
    
        [UIView commitAnimations];
        
        /*if (![[temperatureField text] isEqualToString:@""]) {
            NSString *tempString = temperatureField.text;
            NSRange range = [tempString rangeOfString:@" °F"];
            
            temperatureField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
        }*/
    }
    
    //[textField becomeFirstResponder];
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
        [UIView beginAnimations:Nil context:NULL];
        [UIView setAnimationDuration:0.35];
        
        if (IS_IPHONE_5 == NO) {
            self.view.frame = CGRectMake(0, 0, 320, 480);
        }
        
        [UIView commitAnimations];
    }
    
    if (textField.tag == 3005) {
        //[pickerView endEditing:YES];
        //[pickerView setHidden:YES];
        //[toolbar setHidden:YES];
    }
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
        if ([title isEqualToString:@"Yes"]) {
            [self afterConvert:self];
        } else {
            return;
        }
    }
    
    if (alertView.tag == 3002) {
        if ([title isEqualToString:@"Yes"]) {
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
        } else {
            return;
        }
    }
}

#pragma mark - Custom Methods

- (IBAction)convert:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL milesOrKilometers = [prefs boolForKey:@"miles_kilometers"];
    
    if (milesOrKilometers) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Convert"
                                                        message:@"Convert the current distance to Miles (rounded)?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        alertView.tag = 3001;
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Convert"
                                                            message:@"Convert the current distance to Kilometers (rounded)?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        alertView.tag = 3001;
        [alertView show];
    }
}

- (IBAction)afterConvert:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL milesOrKilometers = [prefs boolForKey:@"miles_kilometers"];
    
    if (milesOrKilometers) {
        NSLog(@"DetailViewController - Converting to Miles");
        
        float kilometers = [[distanceField text]  floatValue];
        
        float miles = kilometers * 0.621371;
        
        //[distanceField setText:[NSString stringWithFormat:@"%.2f", miles]];
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        [numFormat setMaximumFractionDigits:2];
        
        [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:miles]]]];
    } else {
        NSLog(@"DetailViewController - Converting to Kilometers");
        
        float miles = [[distanceField text] floatValue];
        
        float kilometers = miles * 1.60934;
        
        //[distanceField setText:[NSString stringWithFormat:@"%.2f", kilometers]];
        NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
        [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        [numFormat setMaximumFractionDigits:2];
        
        [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:kilometers]]]];
    }
}

- (void)save:(id)sender
{
    if ([[titleField text] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"You have not given this run a name. Would you like to proceed without one?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
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
    //NSLog(@"Changing to Kilos");
    
    NSString *milesKilos = [run mileKilos];
    
    if ([milesKilos isEqualToString:@"miles"]) {
        NSLog(@"DetailViewController - Changing to Kilos");
        [run setMileKilos:@"kilos"];
        [milesKilosButton setTitle:@"Kilometers" forState:UIControlStateNormal];
    } else if ([milesKilos isEqualToString:@"kilos"]) {
        NSLog(@"DetailViewController - Changing to Miles");
        [run setMileKilos:@"miles"];
        [milesKilosButton setTitle:@"Miles" forState:UIControlStateNormal];
    } else {
        NSLog(@"DetailViewController - Undefined value for mileKilos...Changing to \"Miles\"");
        [run setMileKilos:@"miles"];
        [milesKilosButton setTitle:@"Miles" forState:UIControlStateNormal];
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
    BOOL canResign = [runTypeField canResignFirstResponder];
    NSLog(@"canResign: %hhd", canResign);
    
    //[runTypeField endEditing:YES];
    //[runTypeField resignFirstResponder];
    
    //[[self view] endEditing:YES];
    [pickerView endEditing:YES];
    [pickerView setHidden:YES];
    [toolbar setHidden:YES];
    
    //[distanceField endEditing:YES];
    
    //[runTypeField endEditing:YES];
    //[titleField endEditing:YES];
    //[distanceField endEditing:YES];
    //[timeField endEditing:YES];
    //[titleField resignFirstResponder];
    //[distanceField resignFirstResponder];
    //[timeField resignFirstResponder];
    //[runTypeField resignFirstResponder];
    
    if (IS_IPHONE_5) {
        if (isNewRun) {
            NSLog(@"DetailViewController - IsNewRun");
            self.view.frame = CGRectMake(0, 0, 320, 600);
        } else {
            NSLog(@"DetailViewController - IsNotNewRun");
            self.view.frame = CGRectMake(0, 0, 320, 600);
        }
        
        if (isNewRun) {
            pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 352, 325, 300)];
        } else {
            pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 303, 325, 300)];
        }
        [pickerView setDataSource:self];
        [pickerView setDelegate:self];
        [pickerView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [pickerView setHidden:NO];
        
        if (isNewRun) {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 308, 320, 44)];
        } else {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 259, 320, 44)];
        }
        toolbar.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backgroundTapped:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = [NSArray arrayWithObjects:flexSpace, doneItem, nil];
        
        if ([[runTypeField text] isEqualToString:@"No Run Type"]) {
            [pickerView selectRow:2 inComponent:0 animated:YES];
        } else if ([[runTypeField text] isEqualToString:@"Easy Run"]) {
            [pickerView selectRow:0 inComponent:0 animated:YES];
        } else if ([[runTypeField text] isEqualToString:@"Strength Run (Hills)"]) {
            [pickerView selectRow:1 inComponent:0 animated:YES];
        } else if ([[runTypeField text] isEqualToString:@"Distance Run"]) {
            [pickerView selectRow:2 inComponent:0 animated:YES];
        } else if ([[runTypeField text] isEqualToString:@"Tempo Run"]) {
            [pickerView selectRow:3 inComponent:0 animated:YES];
        }
        
        //[runTypeButton setTitle:[NSString stringWithFormat:@"Run Type: Strength Run (Hills)"] forState:UIControlStateNormal];
    } else {
        if (isNewRun) {
            NSLog(@"DetailViewController - IsNewRun");
            self.view.frame = CGRectMake(0, -15, 320, 600);
        } else {
            NSLog(@"DetailViewController - IsNotNewRun");
            self.view.frame = CGRectMake(0, -35, 320, 500);
        }
        
        if (isNewRun) {
            pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 279, 325, 400)];
        } else {
            pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 275, 325, 400)];
        }
        [pickerView setDataSource:self];
        [pickerView setDelegate:self];
        [pickerView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [pickerView setHidden:NO];
        
        if (isNewRun) {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 235, 320, 44)];
        } else {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 231, 320, 44)];
        }
        
        [toolbar setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backgroundTapped:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = [NSArray arrayWithObjects:flexSpace, doneItem, nil];
        
        if ([[runTypeField text] isEqualToString:@"No Run Type"]) {
            [pickerView selectRow:2 inComponent:0 animated:YES];
        } else if ([[runTypeField text] isEqualToString:@"Easy Run"]) {
            [pickerView selectRow:0 inComponent:0 animated:YES];
        } else if ([[runTypeField text] isEqualToString:@"Strength Run (Hills)"]) {
            [pickerView selectRow:1 inComponent:0 animated:YES];
        } else if ([[runTypeField text] isEqualToString:@"Distance Run"]) {
            [pickerView selectRow:2 inComponent:0 animated:YES];
        } else if ([[runTypeField text] isEqualToString:@"Tempo Run"]) {
            [pickerView selectRow:3 inComponent:0 animated:YES];
        }
        
        //[runTypeButton setTitle:[NSString stringWithFormat:@"Run Type: Strength Run (Hills)"] forState:UIControlStateNormal];

    }
    
    [[self view] addSubview:toolbar];
    [[self view] addSubview:pickerView];
    
    NSTimeInterval animationDuration = 0.25;
    UIViewAnimationCurve animationCurve = 7;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [UIView commitAnimations];
    
    //[UIView beginAnimations:nil context:NULL];
    //NSTimeInterval animationDuration =
    
    /*RunTypePicker *runTypePicker = [[RunTypePicker alloc] init];
     [runTypePicker setRun:run];
     
     [[self navigationController] pushViewController:runTypePicker animated:YES];*/
}

#pragma mark - TimeOfDay Methods

- (IBAction)showTimeOfDayPicker:(id)sender
{
    NSLog(@"DetailViewController - TimeOfDay Set");
    
    [timeOfDayPickerView setHidden:YES];
    [toolbar setHidden:YES];
    [pickerView setHidden:YES];
    
    if (IS_IPHONE_5) {
        if (isNewRun) {
            NSLog(@"DetailViewController - IsNewRun");
            self.view.frame = CGRectMake(0, 0, 320, 600);
        } else {
            NSLog(@"DetailViewController - IsNotNewRun");
            self.view.frame = CGRectMake(0, 0, 320, 600);
        }
        
        if (isNewRun) {
            timeOfDayPickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 360, 325, 300)];
        } else {
            timeOfDayPickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 311, 325, 300)];
        }
        [timeOfDayPickerView setDatePickerMode:UIDatePickerModeTime];
        [timeOfDayPickerView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [timeOfDayPickerView setHidden:NO];
        [timeOfDayPickerView setDate:[run timeOfDay]];
        
        if (isNewRun) {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 316, 320, 44)];
        } else {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 267, 320, 44)];
        }
        toolbar.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backgroundTapped:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = [NSArray arrayWithObjects:flexSpace, doneItem, nil];
    } else {
        if (isNewRun) {
            NSLog(@"DetailViewController - IsNewRun");
            self.view.frame = CGRectMake(0, -50, 320, 600);
        } else {
            NSLog(@"DetailViewController - IsNotNewRun");
            self.view.frame = CGRectMake(0, -65
                                         , 320, 600);
        }
        
        if (isNewRun) {
            timeOfDayPickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 314, 325, 300)];
        } else {
            timeOfDayPickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 315, 325, 300)];
        }
        [timeOfDayPickerView setDatePickerMode:UIDatePickerModeTime];
        [timeOfDayPickerView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [timeOfDayPickerView setHidden:NO];
        [timeOfDayPickerView setDate:[run timeOfDay]];
        
        if (isNewRun) {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 270, 320, 44)];
        } else {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 271, 320, 44)];
        }
        toolbar.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backgroundTapped:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = [NSArray arrayWithObjects:flexSpace, doneItem, nil];
    }
    
    [[self view] addSubview:toolbar];
    
    [timeOfDayPickerView addTarget:self action:@selector(changeTimeOfDay:) forControlEvents:UIControlEventValueChanged];
    
    [[self view] addSubview:timeOfDayPickerView];
    
    NSTimeInterval animationDuration = 0.25;
    UIViewAnimationCurve animationCurve = 7;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [UIView commitAnimations];}

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

- (IBAction)changeDate:(id)sender
{
    NSLog(@"DetailViewController - Changing date.");
    
    [datePicker setHidden:YES];
    [toolbar setHidden:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    if (IS_IPHONE_5) {
        if (isNewRun) {
            NSLog(@"DetailViewController - IsNewRun");
            self.view.frame = CGRectMake(0, -65, 320, 600);
        } else {
            NSLog(@"DetailViewController - IsNotNewRun");
            self.view.frame = CGRectMake(0, -105, 320, 600);
        }
        
        if (isNewRun) {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 417, 325, 300)];
        } else {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 403, 325, 300)];
        }
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [datePicker setHidden:NO];
        [datePicker setDate:[run dateCreated]];
        
        if (isNewRun) {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 373, 320, 44)];
        } else {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 359, 320, 44)];
        }
        toolbar.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backgroundTapped:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = [NSArray arrayWithObjects:flexSpace, doneItem, nil];
    } else {
        if (isNewRun) {
            NSLog(@"DetailViewController - IsNewRun");
            self.view.frame = CGRectMake(0, -150, 320, 600);
        } else {
            NSLog(@"DetailViewController - IsNotNewRun");
            self.view.frame = CGRectMake(0, -195, 320, 580);
        }
        
        if (isNewRun) {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 414, 325, 400)];
        } else {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 410, 325, 400)];
        }
        
        [datePicker setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker setHidden:NO];
        [datePicker setDate:[run dateCreated]];
        
        if (isNewRun) {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 370, 320, 44)];
        } else {
            toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 371, 320, 44)];
        }
        
        [toolbar setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        //toolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backgroundTapped:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = [NSArray arrayWithObjects:flexSpace, doneItem, nil];
    }
    
    [[self view] addSubview:toolbar];
    
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    [[self view] addSubview:datePicker];
    
    [UIView commitAnimations];
}

- (IBAction)calculateTime:(id)sender
{
    NSLog(@"DetailViewController - Calculate Time...");
}

- (void)dateChange:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[datePicker date]]];
    [dateLabel setText:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[datePicker date]]]];
    [dateButton setTitle:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[datePicker date]]] forState:UIControlStateNormal];
    
    [run setDateCreated:[dateFormatter dateFromString:dateString]];
    NSLog(@"Date String: %@", dateString);
}

#pragma mark - MPH Methods

- (float)calculateMph
{
    float miles = [[distanceField text] floatValue];
    float timeInMin = [[timeField text] floatValue];
    
    float time = timeInMin / 60;
    
    float mph = miles / time;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
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
}

#pragma mark - Other Methods

- (IBAction)backgroundTapped:(id)sender
{
    NSLog(@"DetailViewController - Background Tapped");
    
    if (datePicker.hidden == NO || pickerView.hidden == NO)
    {
        //NSLog(@"datePicker is not hidden");
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.15];
        
        if (IS_IPHONE_5) {
            if (isNewRun) {
                NSLog(@"IsNew");
                self.view.frame = CGRectMake(0, 0, 320, 570);
            } else {
                NSLog(@"IsNotNew");
                self.view.frame = CGRectMake(0, 0, 320, 550);
            }
        } else {
            if (isNewRun) {
                NSLog(@"IsNew");
                self.view.frame = CGRectMake(0, 0, 320, 500);
            } else {
                NSLog(@"IsNotNew");
                self.view.frame = CGRectMake(0, 0, 320, 450);
            }
        }
        toolbar.hidden = YES;
        [datePicker setHidden:YES];
        [pickerView setHidden:YES];
        
        [UIView commitAnimations];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    
    [toolbar setHidden:YES];
    [runTypeField endEditing:YES];
    [runTypeField resignFirstResponder];
    
    [pickerView endEditing:YES];
    [datePicker setHidden:YES];
    [pickerView setHidden:YES];
    [temperatureField endEditing:YES];
    [timeOfDayPickerView endEditing:YES];
    [timeOfDayPickerView setHidden:YES];
    
    [timeField resignFirstResponder];
    [distanceField resignFirstResponder];
    [titleField resignFirstResponder];
    [textViewView resignFirstResponder];
    [pickerView resignFirstResponder];
    [temperatureField resignFirstResponder];
    [timeOfDayField resignFirstResponder];
    
    [run setTime:[[timeField text] floatValue]];
    [run setSpeed:[[distanceField text] floatValue]];
    
    //[timeField setText:[NSString stringWithFormat:@"%.2f", [run time]]];
    //[distanceField setText:[NSString stringWithFormat:@"%.2f", [run speed]]];
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormat setMaximumFractionDigits:2];
    
    [timeField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run time]]]]];
    [distanceField setText:[NSString stringWithFormat:@"%@", [numFormat stringFromNumber:[NSNumber numberWithFloat:[run speed]]]]];
    
    /*if (![[temperatureField text] isEqualToString:@""]) {
        NSString *tempString = temperatureField.text;
        NSRange range = [tempString rangeOfString:@"°"];
        
        if (range.location == NSNotFound) {
            temperatureField.text = [tempString stringByAppendingString:@" °F"];
        }
    }*/
    
    [UIView commitAnimations];
    
    [self calculateMph];
}

- (IBAction)hidePickerView:(id)sender
{
    NSLog(@"DetailViewController - End Picker View");
    [pickerView endEditing:YES];
    [pickerView resignFirstResponder];
    [pickerView setHidden:YES];
    toolbar.hidden = YES;
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
        typeLabel = @"No Run Type";
    }
    [runTypeButton setTitle:[NSString stringWithFormat:@"Run Type: %@", typeLabel] forState:UIControlStateNormal];
    [runTypeField setText:[NSString stringWithFormat:@"%@", typeLabel]];
}

@end
