//
//  MessageBase.m
//  API
//
//  Created by ShingHo on 16/5/23.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageBase.h"

@implementation MessageBase

- (instancetype)initWithValue:(id)value
{
    self = [super init];
    if (self) {
//        _content = value[@"content"];
        _text = value[@"text"];
        _sessionId = value[@"sessionId"];
        _messageId = value[@"messageId"];
        _sender = value[@"sender"];
        _type = value[@"type"];
        _status = value[@"status"];
        _createdAt = value[@"createdAt"];
        _updatedAt = value[@"updatedAt"];
//        _isDelete = [value[@"isDelete"] boolValue];
    }
    return self;
}


+(NSString *)primaryKey
{
    return @"messageId";
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
