//
//  SessionMemberPickerConfig.m
//  API
//
//  Created by ShingHo on 16/5/11.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "SessionMemberPickerConfig.h"

@implementation SessionMemberPickerConfig
@synthesize alreadySelectedMemberIds = _alreadySelectedMemberIds;
@synthesize filterIds = _filterIds;

- (instancetype)initWithSession:(Y2WSession *)session
{
    if (self = [super init]) {
        self.session = session;
    }
    return self;
}

- (UserPickerType)type {
    return UserPickerTypeSessionMember;
}

- (NSString *)title{
    return @"选择群成员";
}

- (BOOL)isMutiSelected {
    return YES;
}

- (NSInteger)maxSelectedNum{
    return 1000;
}

- (NSString *)selectedOverFlowTip{
    return @"选择超限";
}


- (NSArray *)alreadySelectedMemberIds {
    if (!_alreadySelectedMemberIds) {
        _alreadySelectedMemberIds = @[];
    }
    return _alreadySelectedMemberIds;
}

- (NSArray *)filterIds {
    if (!_filterIds) {
        _filterIds = @[];
    }
    return _filterIds;
}

@end
