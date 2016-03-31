//
//  Y2WSessionMember.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WSessionMember.h"

@implementation Y2WSessionMember

- (instancetype)initWithValue:(id)value
{
    self = [super init];
    if (self) {
        _sessionMemberId    = value[@"id"];
        _userId             = value[@"userId"];
        _name               = value[@"name"];
        _pinyin             = value[@"pinyin"];
        _createdAt          = value[@"createdAt"];
        _updatedAt          = value[@"updatedAt"];
        _isDelete           = [value[@"isDelete"] boolValue];
        _role               = value[@"role"];
        _status             = value[@"status"];
    }
    return self;
}

- (void)updateSessionMember:(Y2WSessionMember *)member
{
    
    _sessionMemberId    = member.sessionMemberId;
    _userId             = member.userId;
    _name               = member.name;
    _pinyin             = member.pinyin;
    _createdAt          = member.createdAt;
    _updatedAt          = member.updatedAt;
    _isDelete           = member.isDelete;
    _role               = member.role;
    _status             = member.status;
}

@end
