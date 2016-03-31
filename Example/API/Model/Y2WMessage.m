//
//  Y2WMessage.m
//  API
//
//  Created by ShingHo on 16/3/2.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WMessage.h"

@implementation Y2WMessage

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
    
    id content = dict[@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        content = [dict[@"content"] parseJsonString];
    }

    if ([content isKindOfClass:[NSDictionary class]]) {
        _content = content;
        
    }else if ([content isKindOfClass:[NSString class]]) {
        _content = @{@"text": content};

    }else {
        _content = @{@"text": dict[@"content"]};
    }
    
    _text = _content[@"text"];
}

- (instancetype)updateWithMessage:(Y2WMessage *)message {
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
    
    if (![object isKindOfClass:[Y2WMessage class]])
        return NO;
    if ([[[(Y2WMessage *)object messageId] uppercaseString] isEqualToString:self.messageId.uppercaseString])
        return YES;
    return NO;
}

@end
