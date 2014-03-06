//
//  ShadowRun.h
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShadowRun : NSManagedObject

@property (nonatomic) float avgMph;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * nameLabel;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSString * runNotes;
@property (nonatomic, retain) NSString * runTitle;
@property (nonatomic) double speed;
@property (nonatomic) double time;
@property (nonatomic, retain) NSManagedObject *type;
@property (nonatomic, retain) NSDate * timeOfDay;
@property (nonatomic) float temperature;
@property (nonatomic, retain) NSString * mileKilos;
@property (nonatomic, retain) NSString * degreesCelcius;
@property (nonatomic, retain) NSDate * alarmDate;

@end
