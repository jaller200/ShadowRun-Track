//
//  ShadowClocksViewController.h
//  ShadowRun
//
//  Created by The Doctor on 2/14/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShadowClocksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *itemsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
