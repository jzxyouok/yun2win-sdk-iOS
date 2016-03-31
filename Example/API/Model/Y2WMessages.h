//
//  Y2WMessages.h
//  API
//
//  Created by ShingHo on 16/3/2.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WMessagesDelegate.h"
#import "Y2WMessagesPage.h"
#import "Y2WBridge.h"
#import "Y2WMessage.h"

@class Y2WSession,Y2WMessagesRemote;
@interface Y2WMessages : NSObject

/**
 *  消息管理对象从属于某一会话，此处保存对会话的引用
 */
@property (nonatomic, weak) Y2WSession *session;

/**
 *  远程方法封装对象
 */
@property (nonatomic, retain) Y2WMessagesRemote *remote;

/**
 *  同步时间戳，同步时使用此时间戳获取之后的数据
 */
@property (nonatomic, copy) NSString *updateAt;

/**
 *  消息数量
 */
@property (nonatomic, assign, readonly) NSUInteger count;


/**
 *  初始化一个消息管理对象
 *
 *  @param session 需要管理消息的session
 *
 *  @return 消息管理对象实例
 */
- (instancetype)initWithSession:(Y2WSession *)session;



/**
 *  添加委托对象
 *
 *  @param delegate 委托对象
 */
- (void)addDelegate:(id<Y2WMessagesDelegate>)delegate;



/**
 *  移除委托对象
 *
 *  @param delegate 委托对象
 */
- (void)removeDelegate:(id<Y2WMessagesDelegate>)delegate;



/**
 *  加载消息
 *
 *  @param page 页数管理器（传nil加载最新消息，传入上次回调得到的则加载上一页）
 */
- (void)loadMessageWithPage:(Y2WMessagesPage *)page;



/**
 *  发送消息
 *
 *  @param message 有发送的消息对象
 */
- (void)sendMessage:(Y2WMessage *)message;



/**
 *  重新发送消息
 *
 *  @param message 要重发的消息对象
 */
- (void)resendMessage:(Y2WMessage *)message;








- (Y2WMessage *)messageWithText:(NSString *)text;

- (Y2WMessage *)messageWithImage:(UIImage *)image;

@end






@interface Y2WMessagesRemote : NSObject

/**
 *  消息远程方法管理对象
 *
 *  @param messages 创建该对象的消息管理对象
 *
 *  @return 远程管理对象实例
 */
- (instancetype)initWithMessages:(Y2WMessages *)messages;



/**
 *  从服务器同步消息
 */
- (void)sync;



/**
 *  保存一条消息到服务器
 *
 *  @param message 需要保存的消息
 *  @param success 保存成功后更新的消息
 *  @param failure 保存失败的错误回调
 */
- (void)storeMessages:(Y2WMessage *)message
              success:(void (^)(Y2WMessage *message))success
              failure:(void (^)(NSError *error))failure;



/**
 *  从服务端获取最新的20条消息
 *
 *  @param success   请求成功的回调
 *  @param failure   请求失败的回调
 */
- (void)getLastMessageDidCompletionBlock:(void (^)(NSArray *messageList))success
                                 failure:(void (^)(NSError *error))failure;

@end