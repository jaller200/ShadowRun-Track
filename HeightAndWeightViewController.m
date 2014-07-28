//
//  HeightAndWeightViewController.m
//  ShadowRun
//
//  Created by Jonathan on 5/14/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

//-- NOTE: This will be implemented later

#import "HeightAndWeightViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HeightAndWeightViewController ()

@end

@implementation HeightAndWeightViewController
@synthesize ageField, weightField, heightField;
@synthesize genderOptions;
@synthesize weightUnitsButton, heightUnitsButton;

- (id)init
{
    self = [super initWithNibName:@"HeightAndWeightViewController" bundle:nil];
    if (self) {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(done:)];
        [[self navigationItem] setRightBarButtonItem:saveItem];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger ageInt = [prefs integerForKey:@"age"];
    age = ageInt;
    weight = [prefs floatForKey:@"weight"];
    height = [prefs floatForKey:@"height"];
    
    gender = [prefs stringForKey:@"gender"];
    
    ageField.text = @"";
    weightField.text = @"";
    heightField.text = @"";
    
    if (gender == nil) {
        gender = @"Male";
        [prefs setObject:@"Male" forKey:@"gender"];
    }
    
    genderOptions.selectedSegmentIndex = 0;
    
    [prefs setObject:@"Kilograms" forKey:@"weightUnits"];
    [prefs setObject:@"Meters" forKey:@"heightUnits"];
    
    ageField.tag = 0;
    weightField.tag = 1;
    heightField.tag = 2;
    
    ageField.delegate = self;
    weightField.delegate = self;
    heightField.delegate = self;
    
    NSLog(@"BorderColor: %@", ageField.layer.borderColor);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            ageField.layer.cornerRadius = 8.0f;
            ageField.layer.masksToBounds = YES;
            ageField.layer.borderColor = [[UIColor clearColor] CGColor];
            ageField.layer.borderWidth = 1.0f;
            break;
        
        case 1:
            weightField.layer.cornerRadius = 8.0f;
            weightField.layer.masksToBounds = YES;
            weightField.layer.borderColor = [[UIColor clearColor] CGColor];
            weightField.layer.borderWidth = 1.0f;
            break;
            
        case 2:
            heightField.layer.cornerRadius = 8.0f;
            heightField.layer.masksToBounds = YES;
            heightField.layer.borderColor = [[UIColor clearColor] CGColor];
            heightField.layer.borderWidth = 1.0f;
            break;
            
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setInteger:[[ageField text] integerValue] forKey:@"age"];
    [prefs setFloat:[[weightField text] floatValue] forKey:@"weight"];
    [prefs setFloat:[[heightField text] floatValue] forKey:@"height"];
    [self changeGender:genderOptions];
}

- (IBAction)changeGender:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (genderOptions.selectedSegmentIndex == 0) {
        gender = @"Male;";
        [prefs setObject:@"Male" forKey:@"gender"];
        NSLog(@"Set to Male");
    } else if (genderOptions.selectedSegmentIndex == 1) {
        gender = @"Female";
        [prefs setObject:@"Female" forKey:@"gender"];
        NSLog(@"Set to Female");
    } else {
        gender = @"Male";
        [prefs setObject:@"Male" forKey:@"gender"];
        NSLog(@"Set to Male");
    }
}

- (IBAction)done:(id)sender
{
    if ([ageField.text isEqualToString:@""]) {
        ageField.layer.cornerRadius = 8.0f;
        ageField.layer.masksToBounds = YES;
        ageField.layer.borderColor = [[UIColor redColor] CGColor];
        ageField.layer.borderWidth = 1.0f;
    }
    
    if ([weightField.text isEqualToString:@""]) {
        weightField.layer.cornerRadius = 8.0f;
        weightField.layer.masksToBounds = YES;
        weightField.layer.borderColor = [[UIColor redColor] CGColor];
        weightField.layer.borderWidth = 1.0f;
    }
    
    if ([heightField.text isEqualToString:@""]) {
        heightField.layer.cornerRadius = 8.0f;
        heightField.layer.masksToBounds = YES;
        heightField.layer.borderColor = [[UIColor redColor] CGColor];
        heightField.layer.borderWidth = 1.0f;
    }
    
    if ([heightField.text isEqualToString:@""] || [weightField.text isEqualToString:@""] || [heightField.text isEqualToString:@""]) {
        return;
    } else {
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)backgroundTapped:(id)sender
{
    [heightField endEditing:YES];
    [weightField endEditing:YES];
    [ageField endEditing:YES];
}

- (void)changeHeightUnits:(id)sender
{
    NSLog(@"Changing Height Units");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *heightUnits = [prefs stringForKey:@"heightUnits"];
    
    if ([heightUnits isEqualToString:@"Meters"]) {
        [heightUnitsButton setTitle:@"Feet" forState:UIControlStateNormal];
        [prefs setObject:@"Feet" forKey:@"heightUnits"];
    } else {
        [heightUnitsButton setTitle:@"Meters" forState:UIControlStateNormal];
        [prefs setObject:@"Meters" forKey:@"heightUnits"];
    }
}

- (void)changeWeightUnits:(id)sender
{
    NSLog(@"Changing Weight Units");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *weightUnits = [prefs stringForKey:@"weightUnits"];
    
    if ([weightUnits isEqualToString:@"Kilograms"]) {
        [weightUnitsButton setTitle:@"Pounds" forState:UIControlStateNormal];
        [prefs setObject:@"Pounds" forKey:@"weightUnits"];
    } else {
        [weightUnitsButton setTitle:@"Kilograms" forState:UIControlStateNormal];
        [prefs setObject:@"Kilograms" forKey:@"weightUnits"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Recieved Memory Warning");
}

@end
