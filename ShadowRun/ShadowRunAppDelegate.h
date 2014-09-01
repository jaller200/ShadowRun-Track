//
//  ShadowRunAppDelegate.h
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadowRunViewController.h"

@interface ShadowRunAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    ShadowRunViewController *shadowRunViewController;
    UITabBarController *tabBarControllerView;
    UINavigationController *navController;
}

@property (strong, nonatomic) UIWindow *window;

// iCloud Key-Value Storage
@property (strong, nonatomic) NSUbiquitousKeyValueStore *keyStore;

@end
