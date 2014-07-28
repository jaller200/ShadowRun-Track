//
//  NSMutableArray+MoveArray.m
//  ShadowRun
//
//  Created by Jonathan Hart on 7/20/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import "NSMutableArray+MoveArray.h"

@implementation NSMutableArray (MoveArray)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self objectAtIndex:from];
        [self removeObjectAtIndex:from];
        
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
    }
}

@end
