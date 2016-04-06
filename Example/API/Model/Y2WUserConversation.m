//
//  Y2WUserConversation.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WUserConversation.h"
#import "Y2WSession.h"

@implementation Y2WUserConversation

- (instancetype)initWithDict:(NSDictionary *)dict userConversations:(Y2WUserConversations *)userConversations {
    
    if (self = [super init]) {
        _userConversations  = userConversations;
        _userConversationId = dict[@"id"];
        _name               = dict[@"name"];
        _type               = dict[@"type"];
        _avatarUrl          = dict[@"avatarUrl"];
        _targetId           = dict[@"targetId"];
        _unRead             = [dict[@"unread"] integerValue];
        _isDelete           = [dict[@"isDelete"] boolValue];
        _createdAt          = dict[@"createdAt"];
        _updatedAt          = dict[@"updatedAt"];
        _visiable           = [dict[@"visiable"] boolValue];
        _top                = [dict[@"top"] boolValue];
        
        NSDictionary *messageDict = dict[@"lastMessage"];
        if (messageDict) {
            _lastMessage    = [[Y2WMessage alloc] initWithValue:messageDict];
        }
    }
    return self;
}

- (void)updateWithUserConversation:(Y2WUserConversation *)conversation {
    _userConversationId = conversation.userConversationId;
    _lastMessage        = conversation.lastMessage;
    _name               = conversation.name;
    _type               = conversation.type;
    _avatarUrl          = conversation.avatarUrl;
    _targetId           = conversation.targetId;
    _unRead             = conversation.unRead;
    _isDelete           = conversation.isDelete;
    _createdAt          = conversation.createdAt;
    _updatedAt          = conversation.updatedAt;
    _visiable           = conversation.visiable;
    _top                = conversation.top;
}



- (NSString *)getName
{
    

    if ([self.type isEqualToString:@"p2p"]) {

        #warning p2p用户会话名称显示规则：如果有联系人，优先用联系人title,无则用联系人name,如果没联系人则使用用户会话的name 风险10000
        Y2WContact *contact = [[Y2WUsers getInstance].getCurrentUser.contacts getContactWithUID:self.targetId];
        if (contact.title.length) return contact.title;
        return self.name;
    }
    else
    {
//        Y2WSession *session = [Y2WUsers getInstance].getCurrentUser.sessions getSessionWithTargetId:<#(NSString *)#> type:<#(NSString *)#> success:<#^(Y2WSession *session)success#> failure:<#^(NSError *error)failure#>
            return self.name;
    }
}

- (NSString *)getAvatarUrl
{
    if ([self.type isEqualToString:@"p2p"]) {
        
        #warning 用户会话头像显示规则：查看有无此用户，如有，则使用用户的头像，否则使用用户会话头像。
//        RLMResults *model = [Y2WUser objectsWithPredicate:[NSPredicate predicateWithFormat:@"userId = %@",self.targetId]];
//        if (model.count) {
//            Y2WUser *user = [model objectAtIndex:0];
//            return user.avatarUrl;
//        }
//        else
        
            return self.avatarUrl;
    }
    else
    {
//        RLMResults *model = [Y2WSession objectsWithPredicate:[NSPredicate predicateWithFormat:@"sessionId = %@",self.targetId]];
//        if (model.count) {
//            Y2WSession *session = [model objectAtIndex:0];
//            return session.avatarUrl;
//        }
//        else
            return self.avatarUrl;
    }
}

- (void)getSessionDidCompletion:(void (^)(Y2WSession *, NSError *))block {
    if (!block) return;
    if (!self.userConversations.user) return block(nil,[NSError errorWithDomain:@"用户会话" code:0 userInfo:@{@"错误":@{AFNetworkingOperationFailingURLResponseDataErrorKey:@"用户换了"}}]);
    
    [self.userConversations.user.sessions getSessionWithTargetId:self.targetId type:self.type success:^(Y2WSession *session) {
        block(session,nil);
        
    } failure:^(NSError *error) {
        block(nil,error);
    }];
}

- (void)syncMessagesForSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure
{
    
}

- (void)syncLastMessageForSuccess:(void (^)(id))success failure:(void (^)(NSString *))failure
{
    
}






- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Y2WUserConversation class]]) return NO;
    return [self.userConversationId isEqual:[(Y2WUserConversation *)object userConversationId]];
}

@end
