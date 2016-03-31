//
//  Y2WContact.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WContact.h"

@implementation Y2WContact

- (instancetype)initWithValue:(id)value
{
    self = [super init];
    if (self) {
        _contactId       = value[@"id"];
        _userId         = value[@"userId"];
        _name           = value[@"name"];
        _pinyin         = value[@"pinyin"];
        _title          = value[@"title"];
        _titlePinyin    = value[@"titlePinyin"];
        _remark         = value[@"remark"];
        _isDelete       = [value[@"isDelete"] boolValue];
        _createdAt      = value[@"createdAt"];
        _updatedAt      = value[@"updatedAt"];
        _avatarUrl      = value[@"avatarUrl"];
    }
    return self;
}

- (void)updateWithContact:(Y2WContact *)contact {
    _contacts       = contact.contacts;
    _userId         = contact.userId;
    _name           = contact.name;
    _pinyin         = contact.pinyin;
    _title          = contact.title;
    _titlePinyin    = contact.titlePinyin;
    _remark         = contact.remark;
    _isDelete       = contact.isDelete;
    _createdAt      = contact.createdAt;
    _updatedAt      = contact.updatedAt;
    _avatarUrl      = contact.avatarUrl;
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
 
 contact,user conversation,session,session member,user session本地保存
 进入app后先同步并显示user conversation，其次同步contact和usersession
 点击进入会话时，如果本地不存在session，同步session及sessionmember
 
 本地如果没有user，第一次初始化由user conversation(p2p),sessionMember(group)或contact完成，
 初始化时必须提供id,name和avatarUrl
 后续同步只能由user本身(在点击用户头像)去获取，不允许由其它对象覆盖
 user实体保存到客户端
 
 联系人显示规则
 名字：优先显示title，其次使用user.name
 头像：使用user.avatarUrl
 
 用户会话(p2p)
 使用联系人规则显示
 
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
 group:标题显示userConversation.name，聊天相对方依据群成员规则显示*/

@end
