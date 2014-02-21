//
//  AlarmLengthViewController.m
//  ShadowRun
//
//  Created by The Doctor on 12/10/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "AlarmLengthViewController.h"

@interface AlarmLengthViewController ()

@end

@implementation AlarmLengthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self = [super initWithNibName:@"AlarmLengthViewController~5" bundle:nil];
    } else {
        self = [super initWithNibName:@"AlarmLengthViewController~4" bundle:nil];
    }
    
    if (self) {
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int number = [prefs integerForKey:@"alarm_number"];
    [slider setValue:number animated:YES];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    int rounded = sender.value;
    [sender setValue:rounded animated:YES];
    
    NSLog(@"Slider Value: %f", sender.value);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:slider.value forKey:@"alarm_number"];
    [prefs synchronize];
}

- (IBAction)saveAndClose:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:slider.value forKey:@"alarm_number"];
    [prefs synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
