//
//  Y2WSessions.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WSessions.h"

@interface Y2WSessions()

/**
 *  当前用户的session对象集合
 */
@property (nonatomic, strong) NSMutableSet *sessionList;

@end

@implementation Y2WSessions

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)currentUser {
    if (self = [super init]) {
        self.user = currentUser;
        self.remote = [[Y2WSessionsRemote alloc] initWithSessions:self];
    }
    return self;
}



- (void)getSessionWithTargetId:(NSString *)targetId type:(NSString *)type success:(void (^)(Y2WSession *))success failure:(void (^)(NSError *))failure {
    if (!success) return;;
    
    Y2WSession *session = [self getSessionWithTargetId:targetId type:type];
    
    if (session) return success(session);
    
    NSString *url = [self urlWithTargetId:targetId type:type];
    [self getSessionWithURLString:url success:^(NSDictionary *dict) {
        
        Y2WSession *session = [[Y2WSession alloc] initWithSessions:self dict:dict];
        session.targetID = targetId;
        [self addSession:session];
        
        [session.members.remote sync];
        success(session);
        
    } failure:failure];
}



#pragma mark - ———— 私有 ———— -

- (void)addSession:(Y2WSession *)session {
    //添加或更新一个session对象
    Y2WSession *oldSession = [self getSessionWithTargetId:session.sessionId type:session.type];
    if (oldSession) [oldSession updateWithSession:session];
    else [self.sessionList addObject:session];
}

- (Y2WSession *)getSessionWithTargetId:(NSString *)targetId type:(NSString *)type {
#warning 本地存储的Session具有属性sessionId&type两个属性吗？
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"targetID LIKE[CD] %@ AND type LIKE[CD] %@",targetId,type];
    NSSet *sessions = [self.sessionList filteredSetUsingPredicate:predicate];
    if (sessions.count) return sessions.anyObject;
    return nil;
}

- (void)getSessionWithURLString:(NSString *)url
                        success:(void (^)(NSDictionary *dict))success
                        failure:(void (^)(NSError *))failure {
    
    [HttpRequest GETWithURL:url parameters:nil success:success failure:^(id msg) {
        if (failure) failure([NSError errorWithDomain:msg code:0 userInfo:nil]);
    }];
}




#pragma mark - ———— Helper ———— -

- (NSString *)urlWithTargetId:(NSString *)targetId type:(NSString *)type {
    if ([type isEqualToString:@"p2p"]) return [URL p2pSessionWithUserA:self.user.userId andUserB:targetId];
    return [URL aboutSession:targetId];
}




#pragma mark - ———— getter ———— -

- (NSMutableSet *)sessionList {
    
    if (!_sessionList) {
        _sessionList = [NSMutableSet set];
    }
    return _sessionList;
}

@end









@interface Y2WSessionsRemote ()

/**
 *  反向获取Session所属的当前用户
 */
@property (nonatomic, weak)Y2WSessions *sessions;

@end

@implementation Y2WSessionsRemote

- (instancetype)initWithSessions:(Y2WSessions *)sessions {
    if (self = [super init]) {
        self.sessions = sessions;
    }
    return self;
}




- (void)addWithName:(NSString *)name
               type:(NSString *)type
         secureType:(NSString *)secureType
          avatarUrl:(NSString *)avatarUrl
            success:(void (^)(Y2WSession *))success
            failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] = name ?: @"群";
    parameters[@"nameChanged"] = name?@"true":@"false";
    parameters[@"type"] = type;
    parameters[@"secureType"] = secureType;
    parameters[@"avatarUrl"] = avatarUrl ?: @"哈哈哈";
    
    
    [HttpRequest POSTWithURL:[URL sessions] parameters:parameters success:^(id data) {
        
        Y2WSession *session = [[Y2WSession alloc] initWithSessions:self.sessions dict:data];
        [self.sessions addSession:session];
        
        Y2WCurrentUser *currentUser = self.sessions.user;
        Y2WSessionMember *member = [[Y2WSessionMember alloc] init];
        member.name = currentUser.name;
        member.userId = currentUser.userId;
        member.avatarUrl = currentUser.avatarUrl;
        member.role = @"master";
        member.status = @"active";
        
        __unsafe_unretained Y2WSession *weakSession = session;
        // 把当前用户添加到创建出的session并设置为群主
        [session.members.remote addSessionMember:member success:^{
            if (success) success(weakSession);
        } failure:failure];
    } failure:failure];
}

@end
