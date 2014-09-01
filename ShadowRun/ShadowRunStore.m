//
//  ShadowRunStore.m
//  ShadowRun
//
//  Created by The Doctor on 8/30/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "ShadowRunStore.h"
#import "ShadowRun.h"
#import "Laps.h"
#import "NSMutableArray+MoveArray.h"

@implementation ShadowRunStore

+ (ShadowRunStore *)sharedStore
{
    static ShadowRunStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [self runArchivePath];
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"runs" ofType:@"momd"];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        //NSURL *storeURL = [NSURL fileURLWithPath:[self runArchivePath]];
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSDictionary *storeOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:storeOptions
                                       error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        [context setUndoManager:nil];
        
        [self loadAllRuns];
        [self loadAllLaps];
    }
    
    return self;
}

- (NSArray *)allRuns
{
    return allRuns;
}

- (ShadowRun *)createRun
{
    double order;
    if ([allRuns count] == 0) {
        order = 1.0;
    } else {
        order = [[allRuns lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order %.2f", (unsigned long)[allRuns count], order);
    
    ShadowRun *p = [NSEntityDescription insertNewObjectForEntityForName:@"ShadowRun" inManagedObjectContext:context];
    
    [p setOrderingValue:order];
    
    [allRuns addObject:p];
    
    return p;
}

- (ShadowRun *)createRun:(NSString *)time
{
    double order;
    if ([allRuns count] == 0) {
        order = 1.0;
    } else {
        order = [[allRuns lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order %.2f", (unsigned long)[allRuns count], order);
    
    ShadowRun *p = [NSEntityDescription insertNewObjectForEntityForName:@"ShadowRun" inManagedObjectContext:context];
    
    [p setOrderingValue:order];
    [p setTime:[time doubleValue]];
    
    [allRuns addObject:p];
    
    return p;
}

- (void)removeRun:(ShadowRun *)run
{
    [context deleteObject:run];
    [allRuns removeObjectIdenticalTo:run];
}

- (NSString *)runArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"runs.data"];
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

- (void)loadAllRuns
{
    //if (!allRuns) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"ShadowRun"];
        [request setEntity:e];
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO];
        NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"runTitle" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObjects:sd, sd2, nil]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        allRuns = [[NSMutableArray alloc] initWithArray:result];
    //}
}

- (NSArray *)allRunTypes
{
    if (!allRunTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"RunType"];
        
        [request setEntity:e];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!request) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        allRunTypes = [result mutableCopy];
        
        NSMutableArray *allRunTypesMutable = [[NSMutableArray alloc] initWithArray:allRunTypes];
        
        int index = 0;
        
        for (NSManagedObject *obj in allRunTypes) {
            if ([[obj valueForKey:@"label"] isEqualToString:@"No Run Type"]) {
                [allRunTypesMutable moveObjectFromIndex:index toIndex:0];
            } else {
                index++;
            }
        }
        
        allRunTypes = allRunTypesMutable;
    }
    
    if ([allRunTypes count] == 0) {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"RunType" inManagedObjectContext:context];
        [type setValue:NSLocalizedString(@"Tempo Run", @"Tempo Run") forKey:@"label"];
        [allRunTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"RunType" inManagedObjectContext:context];
        [type setValue:NSLocalizedString(@"Distance Run", @"Distance Run") forKey:@"label"];
        [allRunTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"RunType" inManagedObjectContext:context];
        [type setValue:NSLocalizedString(@"Strength Run", @"Strength Run") forKey:@"label"];
        [allRunTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"RunType" inManagedObjectContext:context];
        [type setValue:NSLocalizedString(@"Easy Run", @"Easy Run") forKey:@"label"];
        [allRunTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"RunType" inManagedObjectContext:context];
        [type setValue:NSLocalizedString(@"No Run Type", @"No Run Type") forKey:@"label"];
        [allRunTypes insertObject:type atIndex:0];
    }
    
    if ([allRunTypes count] == 4) {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"RunType" inManagedObjectContext:context];
        [type setValue:NSLocalizedString(@"No Run Type", @"No Run Type") forKey:@"label"];
        [allRunTypes insertObject:type atIndex:0];
    }
    
    return allRunTypes;
}

#pragma mark - Lap Functionality

- (void)loadAllLaps
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Laps"];
        [request setEntity:e];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObjects:sd, nil]];
        
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    }
        
    allLaps = [[NSMutableArray alloc] initWithArray:result];
}

- (NSArray *)allLaps
{
    return allLaps;
}

- (void)removeAllLaps
{
    NSLog(@"allLaps count = %lu", (unsigned long)[allLaps count]);
    
    for (NSManagedObject *object in allLaps) {
        [context deleteObject:object];
    }
    
    NSError *error;
    [context save:&error];
}

- (Laps *)createLap:(NSString *)time
{
    double order;
    if ([allLaps count] == 0) {
        order = 1.0;
    } else {
        order = [[allLaps lastObject] orderValue] + 1.0;
    }
    
    NSLog(@"Adding after %lu items, order %.2f", (unsigned long)[allLaps count], order);
    
    Laps *lap = [NSEntityDescription insertNewObjectForEntityForName:@"Laps" inManagedObjectContext:context];
    
    [lap setLapTime:time];
    
    double lapNumber = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lapNumber"];
    
    if (lapNumber == 0) {
        lapNumber++;
    }
    
    [lap setNumber:lapNumber];
    
    lapNumber++;
    
    [[NSUserDefaults standardUserDefaults] setDouble:lapNumber forKey:@"lapNumber"];
    
    [allLaps addObject:lap];
    
    return lap;
}

@end
