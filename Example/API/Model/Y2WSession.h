//
//  Y2WSession.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WMessages.h"
#import "Y2WSessionMembers.h"

@class Y2WCurrentUser;
@class Y2WSessions;

@interface Y2WSession : NSObject

/**
 *  会话从属于会话管理对象，此处保存对其的引用
 */
@property (nonatomic, weak) Y2WSessions *sessions;

/**
 *  用于本地查找
 */
@property (nonatomic, copy) NSString *targetID;

/**
 *  会话唯一标识码
 */
@property (nonatomic, copy) NSString *sessionId;

/**
 *  会话名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  会话类型
 */
@property (nonatomic, copy) NSString *type;

/**
 *  会话的头像地址
 */
@property (nonatomic, copy) NSString *avatarUrl;

/**
 *  会话中会话成员创建时间
 */
@property (nonatomic, copy) NSString *createMTS;

/**
 *  会话中会话成员更新时间
 */
@property (nonatomic, copy) NSString *updateMTS;

/**
 *  会话创建时间
 */
@property (nonatomic, copy) NSString *createdAt;

/**
 *  会话更新时间
 */
@property (nonatomic, copy) NSString *updatedAt;

/**
 *  消息管理对象
 */
@property (nonatomic, strong) Y2WMessages *messages;

/**
 *  会话成员管理对象
 */
@property (nonatomic, strong) Y2WSessionMembers *members;


/**
 *  初始化session
 *
 *  @param sessions 会话集合管理器
 *  @param dict     会话信息
 *
 *  @return 初始化session
 */
- (instancetype)initWithSessions:(Y2WSessions *)sessions dict:(NSDictionary *)dict;

/**
 *  更新session
 *
 *  @param session <#session description#>
 */
- (void)updateWithSession:(Y2WSession *)session;

@end

