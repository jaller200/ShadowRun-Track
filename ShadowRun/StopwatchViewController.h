//
//  StopwatchViewController.h
//  ShadowRun
//
//  Created by The Doctor on 9/24/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShadowRun;

@interface StopwatchViewController : UIViewController
{
    NSString *stopwatchString;
    NSTimeInterval pauseTimeInterval;
    BOOL watchStart;
    
    __weak IBOutlet UIToolbar *defaultToolbar;
    __weak IBOutlet UILabel *stopwatchTitleLabel;
    
    // Update 2.1.0 will contain a tableview for laps
    NSMutableArray *laps;
    NSMutableArray *lapTimes;
    
    NSUserDefaults *prefs;
}

// IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *stopwatchLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStartPauseItem;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

// Timer Declerations
@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSDate *startDate;
@property (assign, nonatomic) double totalTime;

@property (nonatomic) double *runTime; // Unused right now

// ShadowRun - Currently not in use... Will use in later update, but going ahead and putting them in code
@property (strong, nonatomic) ShadowRun *run; // The current run selected
@property (copy, nonatomic) void (^dismissBlock)(void); // View dismissal action

// Time String - For creating new run
@property (nonatomic) NSString *runTimeString;

// Actions
- (IBAction)resetStopwatch:(id)sender;
- (IBAction)btnStartPause:(id)sender;

// Initializers
- (id)initFromInfo:(BOOL)info; // Not fully implemented yet, but is required to initalize

@end
