//
//  ShadowRunItemCell.h
//  ShadowRun
//
//  Created by The Doctor on 8/31/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke
//

#import <Foundation/Foundation.h>

@interface ShadowRunItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *runTitle;
@property (weak, nonatomic) IBOutlet UILabel *mphTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedTitle;
@property (weak, nonatomic) IBOutlet UILabel *runTypeTitle;

@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

@end
