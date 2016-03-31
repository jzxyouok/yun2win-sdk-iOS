//
//  SessionMemberModel.m
//  API
//
//  Created by QS on 16/3/24.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "SessionMemberModel.h"

@implementation SessionMemberModel
@synthesize name = _name;
@synthesize uid = _uid;
@synthesize imageUrl = _imageUrl;
@synthesize image = _image;
@synthesize rowHeight = _rowHeight;
@synthesize sortKey = _sortKey;
@synthesize groupTitle = _groupTitle;



- (instancetype)initWithSessionMember:(Y2WSessionMember *)sessionMember {
    if (self = [super init]) {
        _name = sessionMember.name;
        _uid = sessionMember.userId.uppercaseString;
        _imageUrl = sessionMember.avatarUrl;
        _image = [UIImage imageNamed:@"默认个人头像"];
        _rowHeight = 50;
        _sortKey = sessionMember.name;
        _groupTitle = [[[sessionMember.pinyin firstObject] first] uppercaseString];
        _sessionMember = sessionMember;
    }
    return self;
}
@end
