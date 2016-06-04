//
//  SessionBase.m
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "SessionBase.h"

@implementation SessionBase

- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value]) {
        _sessionId = value[@"id"];
        _type      = value[@"type"];
        _name      = value[@"name"];
        _avatarUrl = value[@"avatarUrl"];
        _createMTS = value[@"createMTS"];
        _updateMTS = value[@"updateMTS"];
        _createdAt = value[@"createdAt"];
        _updatedAt = value[@"updatedAt"];
    }
    return self;
}

+ (NSString *)primaryKey
{
    return @"sessionId";
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
