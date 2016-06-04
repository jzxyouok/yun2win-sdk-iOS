//
//  SessionBase.h
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Realm/Realm.h>

@interface SessionBase : RLMObject
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
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SessionBase>
RLM_ARRAY_TYPE(SessionBase)
