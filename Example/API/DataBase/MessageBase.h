//
//  MessageBase.h
//  API
//
//  Created by ShingHo on 16/5/23.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Realm/Realm.h>

@interface MessageBase : RLMObject
/**
 *  消息内容
 */
//@property (nonatomic, retain) NSDictionary *content;

/**
 *  消息文字内容
 */
@property (nonatomic, copy) NSString *text;

/**
 *  会话的唯一标识符
 */
@property (nonatomic, copy) NSString *sessionId;

/**
 *  消息唯一的标示码
 */
@property (nonatomic, copy) NSString *messageId;

/**
 *  消息的发送者
 */
@property (nonatomic, copy) NSString *sender;

/**
 *  消息类型["text"|"image"|"video"|"audio"|"file"]
 */
@property (nonatomic, copy) NSString *type;

/**
 *  消息状态["storing"|"stored"|"storefailed"]
 */
@property (nonatomic, copy) NSString *status;

/**
 *  消息创建时间
 */
@property (nonatomic, copy) NSString *createdAt;

/**
 *  消息更新时间
 */
@property (nonatomic, copy) NSString *updatedAt;

/**
 *  删除标志
 */
//@property (nonatomic, assign) BOOL isDelete;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MessageBase>
RLM_ARRAY_TYPE(MessageBase)
