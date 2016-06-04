//
//  Y2WUser.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WUser.h"

@implementation Y2WUser

- (instancetype)initWithValue:(id)value
{
    self = [super init];
    if (self) {
        _userId     = [value[@"id"] uppercaseString];
        _name       = value[@"name"];
        _pinyin     = value[@"pinyin"];
        _account    = value[@"email"];
        _avatarUrl  = value[@"avatarUrl"];
        _createdAt  = value[@"createdAt"];
        _updatedAt  = value[@"updatedAt"];
    }
    return self;
}

@end
