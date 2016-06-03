//
//  Y2WCurrentUser.h
//  API
//
//  Created by ShingHo on 16/3/3.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WUser.h"
#import "Y2WContacts.h"
#import "Y2WUserSessions.h"
#import "Y2WSessions.h"
#import "Y2WUserConversations.h"
#import "Y2WBridge.h"

@class Y2WCurrentUserRemote;

@interface Y2WCurrentUser : Y2WUser

/**
 *  用于连接Api平台的AppKey
 */
@property (nonatomic, strong) NSString *appKey;

/**
 *  用于连接Api平台的有期限密钥
 */
@property (nonatomic, strong) NSString *secret;

/**
 *  返回可访问的token值
 */
@property (nonatomic, strong) NSString *token;

/**
 *  获取pushServer的token
 */
@property (nonatomic, strong) NSString *imToken;

/**
 *  密码MD5hash值
 */
@property (nonatomic, strong) NSString *passwordHash;

/**
 *  绑定联系人集合管理器
 */
@property (nonatomic, strong) Y2WContacts *contacts;

/**
 *  绑定会话集合管理器
 */
@property (nonatomic, strong) Y2WSessions *sessions;

/**
 *  绑定用户群组集合管理器
 */
@property (nonatomic, strong) Y2WUserSessions *userSessions;

/**
 *  绑定用户会话集合管理器
 */
@property (nonatomic, strong) Y2WUserConversations *userConversations;

/**
 *  负责与服务器交互的对象
 */
@property (nonatomic, strong) Y2WCurrentUserRemote *remote;

/**
 *  负责与推送服务链接的中间联系桥
 */
@property (nonatomic, strong) Y2WBridge *bridge;


- (instancetype)initWithValue:(id)value;

@end






@interface Y2WCurrentUserRemote : NSObject

/**
 *  初始化一个当前用户的远程管理对象
 *
 *  @param currentUser 引用此对象的当前用户
 *
 *  @return 对象实例
 */
- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)currentUser;

/**
 *  同步Token
 */
- (void)syncTokenDidCompletion:(void (^)(NSError *error))block;

/**
 *  同步IMToken
 */
- (void)syncIMTokenDidCompletion:(void (^)(NSError *error))block;

@end