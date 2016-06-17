//
//  ContactBase.m
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ContactBase.h"

@implementation ContactBase

- (instancetype)initWithValue:(id)value
{
    self = [super init];
    if (self) {
        _contactId      = value[@"id"];
        _userId         = value[@"userId"];
        _name           = value[@"name"];
        _pinyin         = [value[@"pinyin"] componentsJoinedByString:@","];
        _title          = value[@"title"];
        _titlePinyin    = [value[@"titlePinyin"] componentsJoinedByString:@","];
        _remark         = value[@"remark"];
        _isDelete       = [value[@"isDelete"] boolValue];
        _createdAt      = value[@"createdAt"];
        _updatedAt      = value[@"updatedAt"];
        _avatarUrl      = value[@"avatarUrl"];
    }
    return self;
}

+ (NSString *)primaryKey
{
    return @"contactId";
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
