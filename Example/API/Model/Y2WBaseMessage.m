//
//  Y2WBaseMessage.m
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WBaseMessage.h"
#import "Y2WTextMessage.h"
#import "Y2WImageMessage.h"
#import "Y2WFileMessage.h"
#import "Y2WVideoMessage.h"
#import "Y2WLocationMessage.h"
#import "Y2WSystemMessage.h"
#import "Y2WAudioMessage.h"
@implementation Y2WBaseMessage

+ (instancetype)createMessageWithDict:(NSDictionary *)dict
{
    if ([dict[@"type"] isEqualToString:@"text"]) {
        return [[Y2WTextMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"image"])
    {
        return [[Y2WImageMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"file"])
    {
        return [[Y2WFileMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"video"] || [dict[@"type"] isEqualToString:@"movie"])
    {
        return [[Y2WVideoMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"system"])
    {
        return [[Y2WSystemMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"location"])
    {
        return [[Y2WLocationMessage alloc]initWithValue:dict];
    }
    else if ([dict[@"type"] isEqualToString:@"audio"])
    {
        return [[Y2WAudioMessage alloc]initWithValue:dict];
    }
    return nil;
}

- (instancetype)initWithValue:(id)value
{
    self = [super init];
    if (self) {
        [self updateWithDict:value];
    }
    return self;
}


- (void)updateWithDict:(NSDictionary *)dict {
    _messageId  = dict[@"id"];
    _sender     = dict[@"sender"];
    _type       = dict[@"type"];
    _createdAt  = dict[@"createdAt"];
    _updatedAt  = dict[@"updatedAt"];
    _isDelete   = [dict[@"isDelete"] boolValue];
    
}

- (instancetype)updateWithMessage:(Y2WBaseMessage *)message {
    _sessionId = message.sessionId;
    _messageId = message.messageId;
    _sender    = message.sender;
    _type      = message.type;
    _createdAt = message.createdAt;
    _updatedAt = message.updatedAt;
    _isDelete  = message.isDelete;
    _content   = message.content;
    _status    = message.status;
    
    return self;
}


- (BOOL)isEqual:(id)object {
    
    if (![object isKindOfClass:[Y2WBaseMessage class]])
        return NO;
    if ([[[(Y2WBaseMessage *)object messageId] uppercaseString] isEqualToString:self.messageId.uppercaseString])
        return YES;
    return NO;
}

@end
