//
//  ShadowRunAppDelegate.h
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke.
//

#import <UIKit/UIKit.h>
#import "ShadowRunViewController.h"

@interface ShadowRunAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    ShadowRunViewController *shadowRunViewController;
    UITabBarController *tabBarController;
}

@property (strong, nonatomic) UIWindow *window;

@end
