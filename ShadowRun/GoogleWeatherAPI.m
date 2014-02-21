//
//  GoogleWeatherAPI.m
//  ShadowRun
//
//  Created by The Doctor on 2/20/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import "GoogleWeatherAPI.h"

@implementation GoogleWeatherAPI

@synthesize currentTemp, condition, conditionImageURL, location, lowTemp, highTemp;

- (GoogleWeatherAPI *)initWithQuery:(NSString *)query
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

@end
