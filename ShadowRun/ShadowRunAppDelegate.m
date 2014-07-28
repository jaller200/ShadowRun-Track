//
//  ShadowRunAppDelegate.m
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
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
#import "HeightAndWeightViewController.h"

@implementation ShadowRunAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"ShadowRunDelegate - Application Started...");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    shadowRunViewController = [[ShadowRunViewController alloc] init];
     navController = [[UINavigationController alloc] initWithRootViewController:shadowRunViewController];
    
    StopwatchViewController *stopwatchViewController = [[StopwatchViewController alloc] initFromInfo:NO];
    UINavigationController *stopwatchNavController = [[UINavigationController alloc] initWithRootViewController:stopwatchViewController];
    
    MusicViewController *musicViewController = [[MusicViewController alloc] init];
    UINavigationController *musicNavController = [[UINavigationController alloc] initWithRootViewController:musicViewController];
    
    CreditsHelpViewController *creditsHelpViewController = [[CreditsHelpViewController alloc] init];
    UINavigationController *creditsNavController = [[UINavigationController alloc] initWithRootViewController:creditsHelpViewController];
    
    AlarmViewController *alarmViewController = [[AlarmViewController alloc] init];
    
    NSLog(@"ShadowRunDelegate - Loading User Preferences...");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL milesOrKilometers = [prefs boolForKey:@"miles_kilometers"];
    
    NSString *keyboardAppearance = [prefs stringForKey:@"keyboardAppearance"];
    
    if (!keyboardAppearance) {
        NSLog(@"ShadowRunDelegate - Keyboard Appearance not set...Setting to DEFAULT (Dark)");
        [prefs setObject:@"dark" forKey:@"keyboardAppearance"];
    }
    
    /*if (![keyboardAppearance isEqualToString:@"light"] || ![keyboardAppearance isEqualToString:@"dark"]) {
        NSLog(@"ShadowRunDelegate - Keyboard Appearance not set....Setting to DEFAULT (Dark)");
        [prefs setObject:@"dark" forKey:@"keyboardAppearance"];
    }*/
    
    NSLog(@"ShadowRunDelegate - Loading UINavigationController...");
    
    NSLog(@"ShadowRunDelegate - Loading UITabBarItems...");
    
    UITabBarItem *tbi = [navController tabBarItem];
    
    [tbi setTitle:@"ShadowRun"];
    [tbi setImage:[UIImage imageNamed:@"ShadowRuns.png"]];
    
    tabBarControllerView = [[UITabBarController alloc] init];
    tabBarControllerView.tabBar.translucent = YES;
    tabBarControllerView.tabBar.alpha = 0.94;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithObjects:navController, nil];
    [viewControllers addObject:stopwatchNavController];
    [viewControllers addObject:musicNavController];
    [viewControllers addObject:alarmViewController];
    [viewControllers addObject:creditsNavController];
    
    NSLog(@"ShadowRunDelegate - Applying User Preferences...");
    
    if (milesOrKilometers == YES) {
        NSLog(@"ShadowRunDelegate - miles_kilometers: YES");
    } else {
        NSLog(@"ShadowRunDelegate - miles_kilometer: NO");
    }
    
    [tabBarControllerView setViewControllers:viewControllers];
    
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    
    if (backgroundSelected == nil) {
        [prefs setObject:@"Default" forKey:@"backgroundSelected"];
    }
    
    NSLog(@"ShadowRunDelegate - Settings Root View Controller...");
    
    [[self window] setRootViewController:tabBarControllerView];
    
    tabBarControllerView.moreNavigationController.navigationItem.rightBarButtonItem.enabled = false;
    
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
