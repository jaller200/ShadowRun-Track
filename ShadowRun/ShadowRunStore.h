//
//  ShadowRunStore.h
//  ShadowRun
//
//  Created by The Doctor on 8/30/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShadowRun;
@class Laps;

@interface ShadowRunStore : NSObject
{
    NSMutableArray *allRuns;
    NSMutableArray *allRunTypes;
    NSMutableArray *allLaps;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (ShadowRunStore *)sharedStore;

- (void)removeRun:(ShadowRun *)run;

- (NSArray *)allRuns;
- (ShadowRun *)createRun;
- (ShadowRun *)createRun:(NSString *)time;

- (NSString *)runArchivePath;
- (BOOL)saveChanges;

- (void)loadAllRuns;
- (NSArray *)allRunTypes;


// ShadowRun Track 2.1.0 - Lap Functionality
- (void)loadAllLaps;
- (NSArray *)allLaps;

- (void)removeAllLaps;
- (Laps *)createLap:(NSString *)time;

@end
