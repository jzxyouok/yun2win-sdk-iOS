//
//  Y2WUserSessions.h
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUserSessionsDelegate.h"
#import "Y2WUserSession.h"

@class Y2WCurrentUser,Y2WUserSessionsRemote;
@interface Y2WUserSessions : NSObject

/**
 *  群组管理对象从属于某一用户，此处保存对用户的引用，通常为当前用户
 */
@property (nonatomic, weak) Y2WCurrentUser *user;

/**
 *  远程方法封装对象
 */
@property (nonatomic, strong) Y2WUserSessionsRemote *remote;

/**
 *  同步时间戳，同步时使用此时间戳获取之后的数据
 */
@property (nonatomic, copy) NSString *updatedAt;



/**
 *  初始化用户Session管理对象（群组）
 *
 *  @param user 引用此对象的当前用户
 *
 *  @return 对象实例
 */
- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user;



/**
 *  添加委托对象（此对象需要实现Y2WUserSessionsDelegate协议）
 *
 *  @param delegate 委托对象
 */
- (void)addDelegate:(id<Y2WUserSessionsDelegate>)delegate;



/**
 *  移除委托对象
 *
 *  @param delegate 委托对象
 */
- (void)removeDelegate:(id<Y2WUserSessionsDelegate>)delegate;


- (NSArray *)getUserSessionsWithKey:(NSString *)key;

/**
 *  获取用户群组列表
 *
 *  @return @[userSession1,userSession2];
 */
- (NSArray *)getUserSessions;

@end






@interface Y2WUserSessionsRemote : NSObject

/**
 *  初始化一个用户群组远程管理对象
 *
 *  @param userSessions 引用此对象的联系人管理对象
 *
 *  @return 对象实例
 */
- (instancetype)initWithUserSessions:(Y2WUserSessions *)userSessions;



/**
 *  激活用户群组同步
 */
- (void)sync;



/**
 *  添加群组（收藏session）
 *
 *  @param userSession 要添加的session对象
 *  @param success     请求成功的回调
 *  @param failure     请求失败的回调
 */
- (void)addUserSession:(Y2WUserSession *)userSession
               success:(void (^)(void))success
               failure:(void (^)(NSError *error))failure;



/**
 *  删除群组（从收藏中移除）
 *
 *  @param userSession 要删除的session对象
 *  @param success     请求成功的回调
 *  @param failure     请求失败的回调
 */
- (void)deleteUserSession:(Y2WUserSession *)userSession
                  success:(void(^)(void))success
                  failure:(void (^)(NSError *error))failure;

@end
