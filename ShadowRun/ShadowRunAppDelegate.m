//
//  ShadowRunAppDelegate.m
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke.
//

#import "ShadowRunAppDelegate.h"
#import "ShadowRunStore.h"
#import "ShadowRun.h"
#import "ShadowRunViewController.h"
#import "StopwatchViewController.h"
#import "MusicViewController.h"
#import "CreditsHelpViewController.h"
#import "AlarmViewController.h"
#import "SettingsViewController.h"
#import "ShadowRunTabBarViewController.h"
//#import "TestFlight.h"

@implementation ShadowRunAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"ShadowRunDelegate - Application Started...");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // TestFlight
    //[TestFlight takeOff:@"9eece788-ced9-4cdc-a987-a9cff474e6de"];
    
    // Override point for customization after application launch.
    shadowRunViewController = [[ShadowRunViewController alloc] init];
    StopwatchViewController *stopwatchViewController = [[StopwatchViewController alloc] initFromInfo:NO];
    MusicViewController *musicViewController = [[MusicViewController alloc] init];
    CreditsHelpViewController *creditsHelpViewController = [[CreditsHelpViewController alloc] init];
    AlarmViewController *alarmViewController = [[AlarmViewController alloc] init];
    //SettingsViewController *settings = [[SettingsViewController alloc] init];
    
    NSLog(@"ShadowRunDelegate - Loading User Preferences...");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //BOOL manualSettings = [prefs boolForKey:@"manual_settings"];
    BOOL milesOrKilometers = [prefs boolForKey:@"miles_kilometers"];
    
    // Don't need this yet...
    // BOOL stopwatchEnabled = [prefs boolForKey:@"stopwatch_enabled"];
    // BOOL intervalsEnabled = [prefs boolForKey:@"intervals_enabled"];
    
    NSLog(@"ShadowRunDelegate - Loading UINavigationController...");
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:shadowRunViewController];
    
    NSLog(@"ShadowRunDelegate - Loading UITabBarItems...");
    
    UITabBarItem *tbi = [navController tabBarItem];
    
    [tbi setTitle:@"ShadowRun"];
    [tbi setImage:[UIImage imageNamed:@"ShadowRuns.png"]];
    
    tabBarController = [[UITabBarController alloc] init];
    //tabBarController.delegate = self;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithObjects:navController, nil];
    [viewControllers addObject:stopwatchViewController];
    [viewControllers addObject:musicViewController];
    [viewControllers addObject:alarmViewController];
    [viewControllers addObject:creditsHelpViewController];
    
    NSLog(@"ShadowRunDelegate - Applying User Preferences...");
    
    /*if (manualSettings == YES) {
        NSLog(@"ShadowRunDelegate - manualSettings: YES");
        [viewControllers addObject:settings];
    } else {
        NSLog(@"ShadowRunDelegate - manualSettings: NO");
    }*/
    
    if (milesOrKilometers == YES) {
        NSLog(@"ShadowRunDelegate - miles_kilometers: YES");
    } else {
        NSLog(@"ShadowRunDelegate - miles_kilometer: NO");
    }
    
    //BOOL intervalsEnabledBOOL = YES;
    
    /*if (stopwatchEnabled) {
        //NSLog(@"ShadowRunDelegate - StopwatchEnabled: YES");
        
        if (intervalsEnabledBOOL) {
            [viewControllers insertObject:stopwatchViewController atIndex:1];
        } else {
            [viewControllers insertObject:stopwatchViewController atIndex:1];
        }
    }*/
    
    
    
    [tabBarController setViewControllers:viewControllers];
    
    NSLog(@"ShadowRunDelegate - Settings Root View Controller...");
    
    [[self window] setRootViewController:tabBarController];
    
    tabBarController.moreNavigationController.navigationItem.rightBarButtonItem.enabled = false;
    
    NSLog(@"ShadowRunDelegate - Finishing Up...");
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
    NSLog(@"ShadowRunDelegate - Success! Application fully loaded.");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"ShadowRunDelegate - Application entered \"Inactive State\"");
    BOOL success = [[ShadowRunStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"ShadowRunDelegate - Saved all runs.");
    } else {
        NSLog(@"ShadowRunDelegate - Could not save runs.");
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"ShadowRunDelegate - Application entered \"Inactive State\"");
    BOOL success = [[ShadowRunStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"ShadowRunDelegate - Saved all runs.");
    } else {
        NSLog(@"ShadowRunDelegate - Could not save runs.");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"ShadowRunDelegate - Application entered Foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[shadowRunViewController tableView] reloadData];
    
    NSLog(@"ShadowRunDelegate - Application became Active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"ShadowRunDelegate - Application terminating");
    BOOL success = [[ShadowRunStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"ShadowRunDelegate - Saved all runs.");
    } else {
        NSLog(@"ShadowRunDelegate - Could not save runs.");
    }
}

@end
