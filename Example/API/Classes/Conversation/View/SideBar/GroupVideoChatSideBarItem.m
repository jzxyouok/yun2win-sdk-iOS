//
//  GroupVideoChatSideBarItem.m
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "GroupVideoChatSideBarItem.h"

@implementation GroupVideoChatSideBarItem

- (BOOL)selected
{
    if (!_selected) {
        _selected = NO;
    }
    return _selected;
}

@end
