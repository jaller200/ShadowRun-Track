//
//  LapTableViewCell.h
//  ShadowRun
//
//  Created by Jonathan Hart on 8/24/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LapTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lapNumberLabel;

@end
