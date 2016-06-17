//
//  Y2WUserSessions.m
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WUserSessions.h"
#import "MulticastDelegate.h"
#import "Y2WServiceConfig.h"

@interface Y2WUserSessions ()

/**
 *  多路委托对象
 */
@property (nonatomic, retain) MulticastDelegate<Y2WUserSessionsDelegate> *delegates;

@property (nonatomic, strong) NSMutableArray *userSessionsList;

@end



@implementation Y2WUserSessions

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user {
    if (self = [super init]) {
        self.user = user;
        self.remote = [[Y2WUserSessionsRemote alloc] initWithUserSessions:self];
        MulticastDelegate *delegates = [[MulticastDelegate alloc] init];
        self.delegates = (MulticastDelegate<Y2WUserSessionsDelegate> *)delegates;
    }
    return self;
}



#pragma mark - ———— Y2WUserSessionsRemote调用此方法 ———— -

- (void)userSessionsRemote:(Y2WUserSessionsRemote *)remote
           addUserSessions:(NSArray *)addUserSessions
        deleteUserSessions:(NSArray *)deleteUserSessions
        updateUserSessions:(NSArray *)updateUserSessions
      didCompleteWithError:(NSError *)error {
    
    if ([self.delegates respondsToSelector:@selector(userSessionsWillChangeContent:)]) {
        [self.delegates userSessionsWillChangeContent:self];
    }
    
    if ([self.delegates respondsToSelector:@selector(userSessions:onAdduserSession:)]) {
        for (Y2WUserSession *userSession in addUserSessions) {
            [self.delegates userSessions:self onAdduserSession:userSession];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(userSessions:onDeleteuserSession:)]) {
        for (Y2WUserSession *userSession in deleteUserSessions) {
            [self.delegates userSessions:self onDeleteuserSession:userSession];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(userSessions:onUpdateuserSession:)]) {
        for (Y2WUserSession *userSession in updateUserSessions) {
            [self.delegates userSessions:self onUpdateuserSession:userSession];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(userSessionsDidChangeContent:)]) {
        [self.delegates userSessionsDidChangeContent:self];
    }
}




#pragma mark - ———— Y2WUserSessionsDelegateInterface ———— -

- (void)addDelegate:(id<Y2WUserSessionsDelegate>)delegate {
    
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<Y2WUserSessionsDelegate>)delegate {
    
    [self.delegates removeDelegate:delegate];
}

@end







@interface Y2WUserSessionsRemote ()

@property (nonatomic, weak) Y2WUserSessions *userSessions;

@end


@implementation Y2WUserSessionsRemote

- (instancetype)initWithUserSessions:(Y2WUserSessions *)userSessions {
    
    if (self = [super init]) {
        self.userSessions = userSessions;
    }
    return self;
}




- (void)sync {
    
    [HttpRequest GETWithURL:[Y2WServiceConfig.baseUrl stringByAppendingFormat:@""] parameters:@{} success:^(id data) {
        
    } failure:^(id msg) {
        
    }];
}




- (void)addUserSession:(Y2WUserSession *)userSession
               success:(void (^)(void))success
               failure:(void (^)(NSError *error))failure {
    
//    [HttpRequest POSTWithURL:[URL acquireContacts]
//                  parameters:@{@"userId":contact.userId,@"name":contact.name}
//                     success:^(id data) {
//                         
//                         // 添加成功启动同步
//                         [self sync];
//                         if (success) success();
//                         
//                     } failure:failure];
}




- (void)deleteUserSession:(Y2WUserSession *)userSession
                  success:(void(^)(void))success
                  failure:(void (^)(NSError *error))failure {
    
}

@end
