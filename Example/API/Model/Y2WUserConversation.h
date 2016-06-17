//
//  Y2WUserConversation.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUser.h"
@class Y2WUserConversations;

@interface Y2WUserConversation : NSObject

/**
 *  用户会话唯一标识码
 *  用户会话从属于用户会话管理对象，此处保存对其的引用
 */
//
@property (nonatomic, weak) Y2WUserConversations *userConversations;


// 用户会话ID
@property (nonatomic, copy) NSString *userConversationId;


/**
 *  用户会话名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  用户会话头像的地址
 */
@property (nonatomic, copy) NSString *avatarUrl;

/**
 *  用户会话类型
 *  例如："p2p", "single", "group","assistant"
 */
@property (nonatomic, copy) NSString *type;

/**
 *  会话目标ID, type为p2p时为对方UserId,type为group时为群组的Id
 */
@property (nonatomic, copy) NSString *targetId;

/**
 *  用户会话创建时间
 */
@property (nonatomic, copy) NSString *createdAt;

/**
 *  用户会话的更新时间
 */
@property (nonatomic, copy) NSString *updatedAt;

/**
 *  用户会话未读消息数
 */
@property (nonatomic, assign) NSUInteger unRead;

/**
 *  最新一条消息
 */
@property (nonatomic, retain) Y2WBaseMessage *lastMessage;

/**
 *  如果为YES, 表示服务器已删除了此实体，同步时请在客户端也删除
 */
@property (nonatomic, assign) BOOL isDelete;

/**
 *  是否显示
 */
@property (nonatomic, assign) BOOL visiable;

/**
 *  置顶标志
 */
@property (nonatomic, assign) BOOL top;


/**
 *  初始化一个用户会话对象
 *
 *  @param dict              所有属性的字典
 *  @param userConversations 引用此对象的会话管理对象
 *
 *  @return 对象实例
 */
- (instancetype)initWithDict:(NSDictionary *)dict
           userConversations:(Y2WUserConversations *)userConversations;

/**
 *  更新用户会话对象的属性
 *
 *  @param conversation 带有新值的会话对象
 */
- (void)updateWithUserConversation:(Y2WUserConversation *)conversation;

/**
 *  获取用户会话的名称
 *
 *  @return 返回名称
 */
- (NSString *)getName;

/**
 *  获取用户会话的头像地址
 *
 *  @return 返回头像地址
 */
- (NSString *)getAvatarUrl;

/**
 *  获取此用户会话的session
 *
 *  @param block 结束的回调
 */
- (void)getSessionDidCompletion:(void(^)(Y2WSession *session, NSError *error))block;

/**
 *  同步消息
 *
 *  @param success 成功时的回调
 *  @param failure 失败时的回调
 */
- (void)syncMessagesForSuccess:(void(^)(id data))success failure:(void(^)(NSString *msg))failure;

/**
 *  同步最后一条消息
 *
 *  @param success 成功时的回调
 *  @param failure 失败时的回调
 */
- (void)syncLastMessageForSuccess:(void(^)(id data))success failure:(void(^)(NSString *msg))failure;





#pragma mark - ———— 构造方法 ———— -

/**
 *  转换成REST接口需要的结构,方便请求时调用
 */
- (NSDictionary *)toParameters;

@end

