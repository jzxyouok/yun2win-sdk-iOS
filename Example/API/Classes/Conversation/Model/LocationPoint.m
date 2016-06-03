//
//  LocationPoint.m
//  API
//
//  Created by ShingHo on 16/4/13.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "LocationPoint.h"

@implementation LocationPoint

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate Title:(NSString *)title addressImage:(UIImage *)image imagePath:(NSString *)imagePath
{
    if (self = [super init]) {
        _coordinate = coordinate;
        _title = title;
        _addressImage = image;
        _imagePath = imagePath;
    }
    return self;
}

- (instancetype)initWithMessage:(Y2WBaseMessage *)message
{
    if (self = [super init]) {
        CLLocationCoordinate2D coodinate;
        coodinate.longitude = [message.content[@"longitude"] doubleValue];
        coodinate.latitude = [message.content[@"latitude"] doubleValue];
        _coordinate = coodinate;
        _addressImage = nil;
        _imagePath = @"";
//        _title = message.content[@"title"];
    }
    return self;
}

@end
