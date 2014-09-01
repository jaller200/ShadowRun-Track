//
//  StopwatchViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/24/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "StopwatchViewController.h"
#import "ShadowRun.h"
#import "ShadowRunStore.h"
#import "DetailViewController.h"
#import "ShadowRunViewController.h"
#import "Laps.h"
#import "UIImage+ImageEffects.h"
#import "LapTableViewCell.h"

static NSString *lapCellID = @"LapTableViewCellID";

@implementation StopwatchViewController
@synthesize run;
@synthesize dismissBlock;
@synthesize totalTime;
@synthesize runTimeString;
@synthesize runTime;
@synthesize backgroundView;
@synthesize lapTableView;
@synthesize lapButton;

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
            UIBarButtonItem *navDoneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
            [[self navigationItem] setRightBarButtonItem:navDoneItem];
            
            UIBarButtonItem *navCancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:navCancelItem];
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
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Stopwatch"];
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
    
    defaultToolbar.barStyle = UIBarStyleDefault;
    defaultToolbar.translucent = YES;
    defaultToolbar.alpha = 0.94;
    
    [[self stopwatchLabel] setText:[NSString stringWithFormat:@"00:00:00.000"]];
    pauseTimeInterval = 0.0;
    
    [UIView commitAnimations];
    
    laps = [[ShadowRunStore sharedStore] allLaps].mutableCopy;
    
    UINib *nib = [UINib nibWithNibName:@"LapTableViewCell" bundle:nil];
    [[self lapTableView] registerNib:nib forCellReuseIdentifier:lapCellID];
    
    [[self lapTableView] reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    prefs = [NSUserDefaults standardUserDefaults];
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    
    if (IS_IPHONE_5) {
        [backgroundView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-4-Inch.png", backgroundSelected]]];
    } else {
        [backgroundView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-3-5-Inch.png", backgroundSelected]]];
    }
    
    self.lapTableView.backgroundColor = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 253, 320, 222);
    blurView = [[UIToolbar alloc] initWithFrame:rect];
    blurView.barStyle = UIBarStyleDefault;
    [self.view insertSubview:blurView belowSubview:lapTableView];
    
    noLaps = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 94, 32)];
    noLaps.center = blurView.center;
    noLaps.text = @"No Laps";
    noLaps.font = [UIFont systemFontOfSize:25];
    noLaps.textColor = [UIColor darkGrayColor];
    [self.view insertSubview:noLaps aboveSubview:blurView];
    
    lapButton.enabled = watchStart;
    
    if ([laps count] == 0) {
        lapTableView.hidden = YES;
        noLaps.hidden = NO;
    } else {
        lapTableView.hidden = NO;
        noLaps.hidden = YES;
    }
}

#pragma mark - Stopwatch Methods

- (IBAction)resetStopwatch:(id)sender
{
    NSLog(@"Stopwatch Reset");
    
    [[self stopWatchTimer] invalidate];
    [self setStopWatchTimer:nil];
    [self updateTimer];
    
    [[self stopwatchLabel] setText:@"00:00:00.000"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    stopwatchString = [dateFormatter stringFromDate:[NSDate date]];
    
    pauseTimeInterval = 0.0;
    watchStart = NO;
    
    [[self btnStartPauseItem] setTitle:@"Start"];
    
    [[ShadowRunStore sharedStore] removeAllLaps];
    [[ShadowRunStore sharedStore] loadAllLaps];
    
    laps = [[ShadowRunStore sharedStore] allLaps].mutableCopy;
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"lapNumber"];
    
    self.lapTableView.hidden = YES;
    //blurView.hidden = YES;
    
    noLaps.hidden = NO;
    
    lapButton.enabled = NO;
    
    [self.lapTableView reloadData];
}

#pragma mark - CreateRun Methods

// Not in use yet, I will use in later version to create a run from the stopwatch time.
/* - (IBAction)createRun:(id)sender
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
}*/

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
        
        [[self btnStartPauseItem] setTitle:@"Pause"];
        
        self.lapButton.enabled = YES;
    } else {
        watchStart = NO;
        [self.stopWatchTimer invalidate];
        self.stopWatchTimer = nil;
        [self updateTimer];
        
        if (pauseTimeInterval == 0.0) {
            [[self btnStartPauseItem] setTitle:@"Start"];
        } else {
            [[self btnStartPauseItem] setTitle:@"Resume"];
            NSLog(@"StopwatchViewController - pauseTimeInterval = %f", pauseTimeInterval);
        }
        
        self.lapButton.enabled = NO;
    }
}

- (IBAction)lap:(id)sender
{
    Laps *lap = [[ShadowRunStore sharedStore] createLap:[[self stopwatchLabel] text]];
    NSLog(@"Created lap %@ with time: %@", lap, [[self stopwatchLabel] text]);
    
    [[ShadowRunStore sharedStore] loadAllLaps];
    NSLog(@"Laps: %@", [[ShadowRunStore sharedStore] allLaps]);
    
    laps = [[ShadowRunStore sharedStore] allLaps].mutableCopy;
    
    if ([laps count] != 0) {
        self.lapTableView.hidden = NO;
        blurView.hidden = NO;
        noLaps.hidden = YES;
    }
    
    [self.lapTableView reloadData];
    
    [[self view] setNeedsDisplay];
    
    [[ShadowRunStore sharedStore] saveChanges];
}

#pragma mark - Lap TableView DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [laps count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Laps *lap = [[[ShadowRunStore sharedStore] allLaps] objectAtIndex:[indexPath row]];
    
    LapTableViewCell *cell = [lapTableView dequeueReusableCellWithIdentifier:lapCellID];
    
    if (!cell) {
        cell = [[LapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lapCellID];
    }
    
    [[cell timeLabel] setText:[lap lapTime]];
    NSLog(@"lap time = %@", [lap lapTime]);
    cell.lapNumberLabel.text = [NSString stringWithFormat:@"Lap %0.f", [lap number]];
    NSLog(@"lap number = %f", [lap number]);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Laps";
}

@end
