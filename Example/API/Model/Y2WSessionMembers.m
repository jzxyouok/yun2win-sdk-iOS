//
//  Y2WSessionMembers.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WSessionMembers.h"
#import "Y2WSession.h"
#import "MulticastDelegate.h"

@interface Y2WSessionMembers ()

/**
 *  多路委托对象
 */
@property (nonatomic, retain) MulticastDelegate<Y2WSessionMembersDelegate> *delegates;

@property (nonatomic, strong) NSMutableArray *sessionMemberList;

@end

@implementation Y2WSessionMembers

- (instancetype)initWithSession:(Y2WSession *)session
{
    if (self = [super init]) {
        _session = session;
        _remote = [[Y2WSessionMembersRemote alloc] initWithSessionMembers:self];
        MulticastDelegate *delegates = [[MulticastDelegate alloc] init];
        self.delegates = (MulticastDelegate<Y2WSessionMembersDelegate> *)delegates;
    }
    return self;
}



#pragma mark - ———— Y2WsessionMembersRemote调用此方法 ———— -

- (void)sessionMembersRemote:(Y2WSessionMembersRemote *)remote
           addSessionMembers:(NSArray *)addSessionMembers
        deleteSessionMembers:(NSArray *)deleteSessionMembers
        updateSessionMembers:(NSArray *)updateSessionMembers
        didCompleteWithError:(NSError *)error {

    if ([self.delegates respondsToSelector:@selector(sessionMembersWillChangeContent:)]) {
        [self.delegates sessionMembersWillChangeContent:self];
    }
    
    if ([self.delegates respondsToSelector:@selector(sessionMembers:onAddSessionMember:)]) {
        for (Y2WSessionMember *member in addSessionMembers) {
            [self.delegates sessionMembers:self onAddSessionMember:member];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(sessionMembers:onDeleteSessionMember:)]) {
        for (Y2WSessionMember *member in deleteSessionMembers) {
            [self.delegates sessionMembers:self onDeleteSessionMember:member];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(sessionMembers:onUpdateSessionMember:)]) {
        for (Y2WSessionMember *member in updateSessionMembers) {
            [self.delegates sessionMembers:self onUpdateSessionMember:member];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(sessionMembersDidChangeContent:)]) {
        [self.delegates sessionMembersDidChangeContent:self];
    }
}




#pragma mark - ———— Y2WsessionMembersDelegateInterface ———— -

- (void)addDelegate:(id<Y2WSessionMembersDelegate>)delegate {
    
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<Y2WSessionMembersDelegate>)delegate {
    
    [self.delegates removeDelegate:delegate];
}





- (Y2WSessionMember *)getMemberWithUserId:(NSString *)userId
{
 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId LIKE[cd] %@",userId];
    NSArray *tempArr = [self.sessionMemberList filteredArrayUsingPredicate:predicate];
    if (tempArr.count)  return tempArr.firstObject;
    return nil;
}

- (NSArray *)getMembers
{
    if (self.sessionMemberList.count) {
        return self.sessionMemberList;
    }
    return nil;
}

- (void)addSessionMember:(Y2WSessionMember *)member
{
    Y2WSessionMember *model = [self getMemberWithUserId:member.userId];
    if (model) [model updateSessionMember:member];
    [self.sessionMemberList addObject:member];
}

- (void)removeSessionMember:(Y2WSessionMember *)member {
    Y2WSessionMember *model = [self getMemberWithUserId:member.userId];
    if (model) [self.sessionMemberList removeObject:model];
}

- (NSMutableArray *)sessionMemberList
{
    if (!_sessionMemberList) {
        _sessionMemberList = [NSMutableArray array];
    }
    return _sessionMemberList;
}

@end






@interface Y2WSessionMembersRemote ()

@property (nonatomic, weak) Y2WSessionMembers *members;

@end


@implementation Y2WSessionMembersRemote

- (instancetype)initWithSessionMembers:(Y2WSessionMembers *)members {
    if (self = [super init]) {
        _members = members;
    }
    return self;
}


- (void)sync
{
#warning 同步流程，每个member.user不是直接从服务器取得的，而是本地的。如果本地没有，根据目前取下来的member的userid,name，头像生成用户.
    /*
     同步机制流程
     1,获得本地时间戳(如果没有,定为1900年1月1日 0时0分0秒)
     2,以此时间戳访问业务服务器取得数据
     3,将取得数据更新至本地(有三种情况:新增的,修改的,删除的)
     4,取此数据最大的updatedAt时间为新的本地时间戳,保存这个时间戳.
     5,判断是否取完,如果没有,重回第1步
     
     */
    NSString *timeStamp = self.members.session.updateMTS;
    if (!timeStamp.length) {
        timeStamp = @"1990-01-01T00:00:00";
    }
    [HttpRequest GETWithURL:[URL sessionMembers:self.members.session.sessionId] timeStamp:timeStamp parameters:@{@"limit":@"50"} success:^(id data) {

        NSInteger totle = [data[@"total_count"] integerValue];
        if (totle)
        {
            NSArray *tempArr_sessionMembers = data[@"entries"];
            
            NSMutableArray *addMembers = [NSMutableArray array];
            NSMutableArray *deleteMembers = [NSMutableArray array];
            NSMutableArray *updateMembers = [NSMutableArray array];
            
            
            for (NSDictionary *dic in tempArr_sessionMembers) {
                Y2WSessionMember *member = [[Y2WSessionMember alloc]initWithValue:dic];
                
                if (member.isDelete) {
                    [deleteMembers addObject:member];
                    [self.members removeSessionMember:member];
                    
                }else {
                    Y2WSessionMember *oldMember = [self.members getMemberWithUserId:member.userId];
                    if (oldMember) {
                        [updateMembers addObject:oldMember];
                        
                    }else {
                        [addMembers addObject:member];
                    }
                    [self.members addSessionMember:member];
                }
            }
            
            if ([self.members respondsToSelector:@selector(sessionMembersRemote:addSessionMembers:deleteSessionMembers:updateSessionMembers:didCompleteWithError:)]) {
                
                [self.members sessionMembersRemote:self addSessionMembers:addMembers
                              deleteSessionMembers:deleteMembers
                              updateSessionMembers:updateMembers
                              didCompleteWithError:nil];
            }
            
            if (totle<50) {
                NSDictionary *tempDic_sessionMember = tempArr_sessionMembers.lastObject;
                self.members.session.createMTS = tempDic_sessionMember[@"createdAt"];
                self.members.session.updateMTS = tempDic_sessionMember[@"updatedAt"];
                [[NSNotificationCenter defaultCenter]postNotificationName:Y2WSessionMemberDidChangeNotification object:nil userInfo:nil];
            }
            else
            {
                [self sync];
            }
        }
    } failure:^(id msg) {
        NSLog(@"sessionMembers error : %@",msg);
    }];
}


// 添加一个成员
- (void)addSessionMember:(Y2WSessionMember *)member
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] = member.name;
    parameters[@"userId"] = member.userId;
    parameters[@"role"] = member.role;
    parameters[@"status"] = member.status;
    parameters[@"avatarUrl"] = member.avatarUrl;

    [HttpRequest POSTWithURL:[URL sessionMembers:self.members.session.sessionId] parameters:parameters success:^(id data) {
        // 同步用户会话
        [self.members.session.sessions.user.userConversations.remote sync];
        // 同步消息
        [self.members.session.messages.remote sync];
        // 同步成员
        [self sync];
        
        if (success) success();
        
    } failure:failure];
}

// 添加多个成员
- (void)addSessionMembers:(NSArray<Y2WSessionMember *> *)members
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_semaphore_t dispatchSemaphore = dispatch_semaphore_create(0);
        __block NSError *failureError = nil;
        
        for (Y2WSessionMember *member in members) {
            
            [self addSessionMember:member success:^{
                
                dispatch_semaphore_signal(dispatchSemaphore);
                
            } failure:^(NSError *error) {
                failureError = error;
                dispatch_semaphore_signal(dispatchSemaphore);
            }];
            
            dispatch_semaphore_wait(dispatchSemaphore, DISPATCH_TIME_FOREVER);
            
            if (failureError) {
                if (failure) failure(failureError);
                return;
            }
        }
        
        if (success) success();
    });
}



- (void)deleteSessionMember:(Y2WSessionMember *)member
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure {
    
    [HttpRequest DELETEWithURL:[URL singleSessionMember:member.sessionMemberId
                                                Session:self.members.session.sessionId]
                    parameters:nil
                       success:^(id data) {
                           // 同步用户会话
                           [self.members.session.sessions.user.userConversations.remote sync];
                           // 同步消息
                           [self.members.session.messages.remote sync];
                           // 同步成员
                           [self sync];
                           
                           if (success) success();
    } failure:failure];
}

@end