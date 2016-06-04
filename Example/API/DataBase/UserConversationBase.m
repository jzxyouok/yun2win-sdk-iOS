//
//  UserConversationBase.m
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "UserConversationBase.h"

@implementation UserConversationBase

- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value]) {
        _userConversationId = value[@"id"];
        _name               = value[@"name"];
        _type               = value[@"type"];
        _avatarUrl          = value[@"avatarUrl"];
        _targetId           = value[@"targetId"];
//        _unRead             = [value[@"unread"] intValue];
        _isDelete           = [value[@"isDelete"] boolValue];
        _createdAt          = value[@"createdAt"];
        _updatedAt          = value[@"updatedAt"];
        _visiable           = [value[@"visiable"] boolValue];
        _top                = [value[@"top"] boolValue];
    }
    return self;
}

+(NSString *)primaryKey
{
    return @"userConversationId";
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
