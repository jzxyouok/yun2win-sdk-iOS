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

@end
