//
//  Laps.h
//  ShadowRun
//
//  Created by Jonathan Hart on 8/24/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Laps : NSManagedObject

@property (nonatomic, retain) NSString * lapTime;
@property (nonatomic) double orderValue;
@property (nonatomic) double number;

@end
