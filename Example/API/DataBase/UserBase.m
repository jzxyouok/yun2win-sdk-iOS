//
//  UserBase.m
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "UserBase.h"

@implementation UserBase

- (instancetype)initWithValue:(id)value
{
    self = [super init];
    if (self) {
        _userId     = [value[@"id"] uppercaseString];
        _name       = value[@"name"];
        _pinyin     = [value[@"pinyin"] componentsJoinedByString:@","];
        _account    = value[@"email"];
        _avatarUrl  = value[@"avatarUrl"];
        _createdAt  = value[@"createdAt"];
        _updatedAt  = value[@"updatedAt"];
    }
    return self;
}

+ (NSString *)primaryKey
{
    return @"userId";
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
