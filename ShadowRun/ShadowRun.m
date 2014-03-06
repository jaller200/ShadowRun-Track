//
//  ShadowRun.m
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "ShadowRun.h"


@implementation ShadowRun

@dynamic avgMph;
@dynamic dateCreated;
@dynamic nameLabel;
@dynamic orderingValue;
@dynamic runNotes;
@dynamic runTitle;
@dynamic speed;
@dynamic time;
@dynamic type;
@dynamic timeOfDay;
@dynamic temperature;
@dynamic mileKilos;
@dynamic degreesCelcius;
@dynamic alarmDate;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *t = [NSDate date];
    [self setDateCreated:t];
    
    NSDate *tod = [NSDate date];
    [self setTimeOfDay:tod];
}

@end
