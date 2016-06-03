//
//  Y2WUserSession.h
//  API
//
//  Created by QS on 16/3/30.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WSession.h"

@class Y2WUserSessions;
@interface Y2WUserSession : NSObject

/**
 *  会话从属于会话管理对象，此处保存对其的引用
 */
@property (nonatomic, weak) Y2WUserSessions *userSessions;

/**
 *  群组ID
 */
@property (nonatomic, copy) NSString *userSessionId;

/**
 *  会话ID
 */
@property (nonatomic, copy) NSString *sessionId;

/**
 *  群组名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  头像地址
 */
@property (nonatomic, copy) NSString *avatarUrl;

/**
 *  会话创建时间
 */
@property (nonatomic, copy) NSString *createdAt;

/**
 *  会话更新时间
 */
@property (nonatomic, copy) NSString *updatedAt;

/**
 *  删除标志
 */
@property (nonatomic, assign) BOOL isDelete;




/**
 *  初始化一个Y2WUserSession对象
 *
 *  @param userSessions 会话集合管理器
 *  @param dict         会话信息
 *
 *  @return 对象实例
 */
- (instancetype)initWithUserSessions:(Y2WUserSessions *)userSessions
                                dict:(NSDictionary *)dict;



/**
 *  获取此群组的用户会话
 *
 *  @return 用户会话对象（没有则返回nil）
 */
- (Y2WUserConversation *)getUserConversation;



/**
 *  获取此群组的session
 *
 *  @param block 结束的回调
 */
- (void)getSessionDidCompletion:(void(^)(NSError *error, Y2WSession *session))block;


/**
 *  转换成REST接口需要的结构,方便请求时调用
 */
- (NSDictionary *)toParameters;

@end
