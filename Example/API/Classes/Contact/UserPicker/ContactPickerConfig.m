//
//  ContactPickerConfig.m
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ContactPickerConfig.h"

@implementation ContactPickerConfig
@synthesize alreadySelectedMemberIds = _alreadySelectedMemberIds;
@synthesize filterIds = _filterIds;

- (UserPickerType)type {
    return UserPickerTypeContact;
}

- (NSString *)title{
    return @"选择联系人";
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
