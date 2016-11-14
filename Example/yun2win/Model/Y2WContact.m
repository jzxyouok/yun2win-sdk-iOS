//
//  Y2WContact.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WContact.h"

@implementation Y2WContact

- (instancetype)initWithContacts:(Y2WContacts *)contacts base:(ContactBase *)base {
    if (self = [super init]) {
        _contacts       = contacts;
        _ID             = base.ID;
        _userId         = base.userId;
        [self updateWithBase:base];
    }
    return self;
}

- (void)updateWithBase:(ContactBase *)base {
    _name        = base.name;
    _pinyin      = [base.pinyin componentsSeparatedByString:@","];
    _title       = base.title;
    _titlePinyin = [base.titlePinyin componentsSeparatedByString:@","];
    _remark      = base.remark;
    _avatarUrl   = base.avatarUrl;
    _createdAt   = base.createdAt.y2w_toString;
    _updatedAt   = base.updatedAt.y2w_toString;
    _isDelete    = base.isDelete;
    _user        = [[Y2WUsers getInstance] getUserWithContact:self];
}



- (NSString *)getName {
    if (self.title.length && ![self.title isEqualToString:@" "]) {
        return self.title;
    }
    return self.user.name;
}

- (NSString *)getAvatarUrl {
    if (_user) {
        return _user.avatarUrl;
    }
    return _avatarUrl;
}



- (Y2WUserConversation *)getUserConversation {
    NSArray *userConversations = [self.contacts.user.userConversations getUserConversations];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type LIKE[cd] %@ AND targetId LIKE[cd] %@",@"p2p",self.userId];
    return [userConversations filteredArrayUsingPredicate:predicate].firstObject;
}


- (void)getSessionDidCompletion:(void (^)(Y2WSession *, NSError *))block {
    if (!block) return;
    [self.contacts.user.sessions getSessionWithTargetId:self.userId type:@"p2p" success:^(Y2WSession *session) {
        block(session,nil);
        
    } failure:^(NSError *error) {
        block(nil,error);
    }];
}


#warning 联系人需要有获得名称和获取消息的方法。 名称优先title，再次user.name, 最后是name; 头像优先user.avatarUrl, 最后avatarUrl。
/*人名和头像客户端显示规则
 
 联系人显示规则
 名字：优先显示title，其次使用user.name
 头像：使用user.avatarUrl
 
 用户会话(group)、群显示规则
 名字 userConversation.name或userSession.name
 头像 userConversation.avatarUrl或userSession.avatarUrl
 
 群成员显示规则：
 名字：sessionMember.name
 头像：使用user.avatarUrl
 
 修改联系人title时，必须修改userconversation.name
 修改群内自己昵称时，修改sessionmember.name，并根据需要（假设群默认名字为前5个人姓名之和）修改session.name
 
 
 进入会话时
 p2p:标题及聊天相对方，依据联系人规则显示
 group:标题显示userConversation.name，聊天相对方依据群成员规则显示
 */

@end
