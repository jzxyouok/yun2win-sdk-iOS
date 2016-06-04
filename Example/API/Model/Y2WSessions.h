//
//  Y2WSessions.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WSession.h"

@class Y2WCurrentUser;
@class Y2WSessionsRemote;

@interface Y2WSessions : NSObject

/**
 *  群组管理对象从属于某一用户，此处保存对用户的引用，通常为当前用户
 */
@property (nonatomic, weak)Y2WCurrentUser *user;

/**
 *  远程方法封装对象
 */
@property (nonatomic, retain) Y2WSessionsRemote *remote;


/**
 *  初始化一个Session管理对象
 *
 *  @param currentUser 引用此对象的当前用户
 *
 *  @return 对象实例
 */
- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)currentUser;

/**
 *  根据条件获取一个Session对象
 *
 *  @param targetId 会话目标ID
 *  @param type     Session类型
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
- (void)getSessionWithTargetId:(NSString *)targetId
                          type:(NSString *)type
                       success:(void(^)(Y2WSession *session))success
                       failure:(void(^)(NSError *error))failure;

@end







@interface Y2WSessionsRemote : NSObject

/**
 *  初始化一个Session管理对象
 *
 *  @param currentUser 引用此对象的当前用户
 *
 *  @return 对象实例
 */
- (instancetype)initWithSessions:(Y2WSessions *)sessions;

/**
 *  创建一个session
 *
 *  @param name       自定义名字
 *  @param type       类型（三种可选类型：@"p2p", @"single", @"group"）
 *  @param secureType 安全类型（两种类型：@"public", @"private"）
 *  @param avatarUrl  头像地址（可以是绝对地址也可以是相对地址，便于服务器维护）
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)addWithName:(NSString *)name
               type:(NSString *)type
         secureType:(NSString *)secureType
          avatarUrl:(NSString *)avatarUrl
            success:(void(^)(Y2WSession *session))success
            failure:(void(^)(NSError *error))failure;


- (void)updateWithName:(NSString *)name
                  type:(NSString *)type
            secureType:(NSString *)secureType
             avatarUrl:(NSString *)avatarUrl
               session:(Y2WSession *)session
               success:(void(^)(Y2WSession *session))success
               failure:(void(^)(NSError *error))failure;
@end
