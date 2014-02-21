//
//  StopwatchViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/24/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke.
//

#import "StopwatchViewController.h"
#import "ShadowRun.h"
#import "ShadowRunStore.h"
#import "DetailViewController.h"
#import "ShadowRunViewController.h"

//#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

@implementation StopwatchViewController
@synthesize run;
@synthesize dismissBlock;
@synthesize totalTime;
@synthesize runTimeString;
@synthesize runTime;
//@synthesize startDate;

#pragma mark - INIT Methods

- (id)initFromInfo:(BOOL)info
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self = [super initWithNibName:@"StopwatchViewController~5" bundle:nil];
    } else {
        self = [super initWithNibName:@"StopwatchViewController~4" bundle:nil];
    }
    
    if (self) {
        if (info) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        } else {
            UITabBarItem *tbi = [self tabBarItem];
            
            [tbi setTitle:@"Stopwatch"];
            [tbi setImage:[UIImage imageNamed:@"Time.png"]];
        }
        
        NSDate *startDate = [NSDate date];
        pauseTimeInterval = [startDate timeIntervalSinceDate:[NSDate date]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        
        stopwatchString = [dateFormatter stringFromDate:startDate];
        
        watchStart = NO;
        pauseTimeInterval = 0.0;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initFromInfo:"
                                 userInfo:nil];
    return nil;
}

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    [[self view] setFrame:CGRectMake(0, -100, 320, 367)];
    
    UIColor *clr = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
    [[self view] setAlpha:0.85];
    [[self view] setBackgroundColor:clr];
    
    [[self stopButton] setEnabled:NO];
    [[self stopButtonItem] setEnabled:NO];
    
    [[self stopwatchLabel] setText:[NSString stringWithFormat:@"00:00:00.000"]];
    
    //[[self toolbar] setHidden:YES];
    
    pauseTimeInterval = 0.0;
}

#pragma mark - Stopwatch Methods

- (IBAction)startStopwatch:(id)sender
{
    NSLog(@"Stopwatch Started");
    
    //[self setStartDate:[NSDate date]];
    //[self setStopWatchTimer:[NSTimer scheduledTimerWithTimeInterval:1.0 / 10.0
                                                             //target:self
                                                           //selector:@selector(updateTimer)
                                                           //userInfo:nil
                                                            //repeats:YES]];
    watchStart = YES;
    self.startDate = [NSDate date];
    self.startDate = [self.startDate dateByAddingTimeInterval:((-1)*(pauseTimeInterval))];
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/1000.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    [[self startButton] setEnabled:NO];
    [[self stopButton] setEnabled:YES];
    [[self startButtonItem] setEnabled:NO];
    [[self stopButtonItem] setEnabled:YES];
}

- (IBAction)stopStopwatch:(id)sender
{
    NSLog(@"Stopwatch Stopped");
    
    //[[self stopWatchTimer] invalidate];
    //[self setStopWatchTimer:nil];
    //[self updateTimer];
    
    watchStart = NO;
    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
    [self updateTimer];
    
    [[self stopButton] setEnabled:NO];
    [[self startButton] setEnabled:YES];
    
    [[self startButtonItem] setEnabled:YES];
    [[self stopButtonItem] setEnabled:NO];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSLog(@"runTimeString = %@", runTimeString);
}

- (IBAction)resetStopwatch:(id)sender
{
    NSLog(@"Stopwatch Reset");
    
    [[self stopWatchTimer] invalidate];
    [self setStopWatchTimer:nil];
    [self updateTimer];
    
    [[self stopwatchLabel] setText:@"00:00:00.000"];
    
    [[self startButton] setEnabled:YES];
    [[self stopButton] setEnabled:NO];
    [[self startButtonItem] setEnabled:YES];
    [[self stopButtonItem] setEnabled:NO];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    stopwatchString = [dateFormatter stringFromDate:[NSDate date]];
    
    pauseTimeInterval = 0.0;
    watchStart = NO;
    
    [[self btnStartPauseItem] setTitle:@"Start Timer"];
}

#pragma mark - CreateRun Methods

- (IBAction)createRun:(id)sender
{
    NSLog(@"StopwatchViewController - Create Run");
    NSLog(@"StopwatchViewController - This button does absolutely nothing right now.");
    
    ShadowRun *newRun = [[ShadowRunStore sharedStore] createRun:runTimeString];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewRun:YES isFromStopwatch:YES];
    
    detailViewController.stopwatchTimeString = runTimeString;
    
    [detailViewController setRun:newRun];
    [detailViewController setSpeed:(float)*(runTime)];
    
    [detailViewController setDismissBlock:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:navController animated:YES completion:nil];
    
    NSLog(@"This is so far working...");
}

#pragma mark - Custom Methods

- (void)updateTimer
{
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:[self startDate]];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    runTime = &timeInterval;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    [[self stopwatchLabel] setText:timeString];
    pauseTimeInterval = timeInterval;
    
    runTimeString = timeString;
    
    NSLog(@"StopwatchViewController - timeString: %@", timeString);
    NSLog(@"StopwatchViewController - runTimeString: %@", runTimeString);
}

- (void)done:(id)sender
{
    NSLog(@"StopwatchViewController - Done Pressed");
}

- (void)cancel:(id)sender
{
    NSLog(@"StopwatchViewController - Cancel Pressed");
}

- (IBAction)btnStartPause:(id)sender
{
    if (watchStart == NO) {
        watchStart = YES;
        self.startDate = [NSDate date];
        self.startDate = [self.startDate dateByAddingTimeInterval:((-1)*(pauseTimeInterval))];
        self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        
        [[self btnStartPauseItem] setTitle:@"Pause Timer"];
    } else {
        watchStart = NO;
        [self.stopWatchTimer invalidate];
        self.stopWatchTimer = nil;
        [self updateTimer];
        
        if (pauseTimeInterval == 0.0) {
            [[self btnStartPauseItem] setTitle:@"Start Timer"];
        } else {
            [[self btnStartPauseItem] setTitle:@"Resume Timer"];
            NSLog(@"StopwatchViewController - pauseTimeInterval = %f", pauseTimeInterval);
        }
    }
}

@end
