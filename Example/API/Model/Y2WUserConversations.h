//
//  Y2WUserConversations.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUserConversationsDelegate.h"
#import "Y2WUserConversation.h"
@class Y2WCurrentUser;
@class Y2WUserConversationsRemote;

@interface Y2WUserConversations : NSObject

/**
 *  当前生命周期所维持的当前登录用户
 */
@property (nonatomic, weak) Y2WCurrentUser *user;

/**
 *  用户回话同步时间戳
 */
@property (nonatomic, strong) NSString *updatedAt;

/**
 *  远程方法封装对象
 */
@property (nonatomic, strong) Y2WUserConversationsRemote *remote;





/**
 *  初始化用户会话管理对象
 *
 *  @param user 引用此对象的当前用户对象
 *
 *  @return 对象实例
 */
- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user;



/**
 *  添加委托对象（此对象需要实现Y2WUserConversationsDelegate协议）
 *
 *  @param delegate 委托对象
 */
- (void)addDelegate:(id<Y2WUserConversationsDelegate>)delegate;



/**
 *  移除委托对象
 *
 *  @param delegate 委托对象
 */
- (void)removeDelegate:(id<Y2WUserConversationsDelegate>)delegate;



/**
 *  通过目标ID和会话类型获取一个会话对象
 *
 *  @param targetId 目标ID
 *  @param type     会话类型
 *
 *  @return 会话对象实例
 */
- (Y2WUserConversation *)getUserConversationWithTargetId:(NSString *)targetId
                                                    type:(NSString *)type;

/**
 *  获取所有用户会话
 *
 *  @return 返回获取所有用户会话
 */
- (NSArray *)getUserConversations;

@end




@interface Y2WUserConversationsRemote : NSObject

/**
 *  初始化一个用户会话远程管理对象
 *
 *  @param userConversations 引用此对象的当前用户
 *
 *  @return 对象实例
 */
- (instancetype)initWithUserConversations:(Y2WUserConversations *)userConversations;

- (void)sync;

/**
 *  删除用户会话
 *
 *  @param userConversation 需要删除的用户会话对象
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */
- (void)deleteUserConversation:(Y2WUserConversation *)userConversation
                       success:(void(^)(void))success
                       failure:(void(^)(NSError *error))failure;



/**
 *  更新一个用户会话
 *
 *  @param userConversation 需要更新的用户会话
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */
- (void)updateUserConversation:(Y2WUserConversation *)userConversation
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *))failure;
@end
