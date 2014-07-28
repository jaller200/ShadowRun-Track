//
//  NSMutableArray+MoveArray.h
//  ShadowRun
//
//  Created by Jonathan Hart on 7/20/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MoveArray)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end
