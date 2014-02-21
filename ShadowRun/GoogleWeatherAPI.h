//
//  GoogleWeatherAPI.h
//  ShadowRun
//
//  Created by The Doctor on 2/20/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleWeatherAPI : NSObject
{
    NSString *condition, *location;
    NSURL *conditionImageURL;
    NSInteger currentTemp, lowTemp, highTemp;
}

@property (nonatomic, retain) NSString *condition, *location;
@property (nonatomic, retain) NSURL *conditionImageURL;
@property (nonatomic) NSInteger currentTemp, lowTemp, highTemp;

- (GoogleWeatherAPI *)initWithQuery:(NSString *)query;

@end
