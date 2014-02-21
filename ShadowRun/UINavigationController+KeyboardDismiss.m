//
//  UINavigationController+KeyboardDismiss.m
//  ShadowRun
//
//  Created by The Doctor on 1/15/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import "UINavigationController+KeyboardDismiss.h"

@implementation UINavigationController (KeyboardDismiss)

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return [self.topViewController disablesAutomaticKeyboardDismissal];
}

@end
