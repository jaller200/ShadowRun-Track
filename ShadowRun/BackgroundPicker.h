//
//  BackgroundPicker.h
//  ShadowRun
//
//  Created by Jonathan on 5/18/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundPicker : UITableViewController
{
    NSUserDefaults *prefs;
}

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
