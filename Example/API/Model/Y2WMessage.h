//
//  Y2WMessage.h
//  API
//
//  Created by ShingHo on 16/3/2.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Y2WMessages;

@interface Y2WMessage : NSObject

/**
 *  消息对象从属于消息管理对象，此处保存对其的引用
 */
@property (nonatomic, weak) Y2WMessages *messages;

/**
 *  消息内容
 */
@property (nonatomic, retain) NSDictionary *content;

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
@property (nonatomic, assign) BOOL isDelete;



- (instancetype)initWithValue:(id)value;

/**
 *  更新消息
 *
 *  @param dict 消息信息
 */
- (void)updateWithDict:(NSDictionary *)dict;

/**
 *  更新消息
 *
 *  @param message 消息尸体
 *
 *  @return 
 */
- (instancetype)updateWithMessage:(Y2WMessage *)message;

@end
