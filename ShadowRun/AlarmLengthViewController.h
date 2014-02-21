//
//  AlarmLengthViewController.h
//  ShadowRun
//
//  Created by The Doctor on 12/10/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmLengthViewController : UIViewController
{
    IBOutlet UISlider *slider;
}

- (IBAction)saveAndClose:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

@end
