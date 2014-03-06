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

@interface ShadowRunStore : NSObject
{
    NSMutableArray *allRuns;
    NSMutableArray *allRunTypes;
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

@end
