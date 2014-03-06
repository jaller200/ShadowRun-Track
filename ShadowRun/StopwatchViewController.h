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
}

// IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *stopwatchLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStartPauseItem;

// Timer Declerations
@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSDate *startDate;
@property (assign, nonatomic) double totalTime;

@property (nonatomic) double *runTime;

// ShadowRun
@property (strong, nonatomic) ShadowRun *run;
@property (copy, nonatomic) void (^dismissBlock)(void);

// Time String - For creating new run
@property (nonatomic) NSString *runTimeString;

// Actions
- (IBAction)resetStopwatch:(id)sender;
- (IBAction)createRun:(id)sender;

- (IBAction)btnStartPause:(id)sender;

- (id)initFromInfo:(BOOL)info;

@end
