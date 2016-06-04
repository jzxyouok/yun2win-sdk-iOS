//
//  UserConversationBase.h
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserConversationBase : RLMObject

/**
 *  用户会话ID
 */
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
 *  用户会话未读消息数
 */
//@property (nonatomic, assign) int unRead;

/** 
 *  用户会话创建时间
 */
@property (nonatomic, copy) NSString *createdAt;

/**
 *  用户会话的更新时间
 */
@property (nonatomic, copy) NSString *updatedAt;

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
@end

// This protocol enables typed collections. i.e.:
// RLMArray<UserConversationBase>
RLM_ARRAY_TYPE(UserConversationBase)
