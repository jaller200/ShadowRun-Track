//
//  HeightAndWeightViewController.h
//  ShadowRun
//
//  Created by Jonathan on 5/14/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

//-- NOTE: This will be implemented later

#import <UIKit/UIKit.h>

@interface HeightAndWeightViewController : UIViewController <UITextFieldDelegate>
{
    long age;
    float weight;
    float height;
    NSString *gender;
}

@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;
@property (strong, nonatomic) IBOutlet UITextField *heightField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderOptions;
@property (strong, nonatomic) IBOutlet UIButton *weightUnitsButton;
@property (strong, nonatomic) IBOutlet UIButton *heightUnitsButton;

- (IBAction)changeGender:(id)sender;

- (IBAction)changeWeightUnits:(id)sender;
- (IBAction)changeHeightUnits:(id)sender;
- (IBAction)done:(id)sender;

- (IBAction)backgroundTapped:(id)sender;

@end
