//
//  ShadowRunViewController.h
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShadowRunItemCell.h"

@class ShadowRun;

@interface ShadowRunViewController : UITableViewController <UIAlertViewDelegate, UINavigationBarDelegate>
{
    ShadowRun *run;
    NSUserDefaults *prefs;
    
    UIRefreshControl *refreshControl;
}

- (IBAction)addNewRun:(id)sender;

@end
