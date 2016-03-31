//
//  Y2WBridge.h
//  API
//
//  Created by ShingHo on 16/3/10.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Y2W_IM_SDK/IMClient.h>
#import <Y2W_IM_SDK/OnConnectionStatusChanged.h>
#import "IMSession.h"
#import "IMMessage.h"

@class Y2WSession;

@class OnMessage;
@interface Y2WBridge : NSObject<OnConnectionStatusChanged>

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, weak) id<OnConnectionStatusChanged> statusChanged;

@property (nonatomic, strong) OnMessage *message;

- (instancetype)initWithAppKey:(NSString *)appkey Token:(NSString *)token UserId:(NSString *)userId OnConnectionStatusChanged:(id<OnConnectionStatusChanged>)onConnectionStatusChanged OnMessage:(OnMessage *)message;


- (void)connectBeforeCheck:(Y2WBridge *)opts;

/**
 *  pushServer推送
 *
 *  @param session 推送的目的会话
 *  @param content 推送消息体 
 *  @discuss content由SendMessageSyncTypes中的某种类型构成
 */
- (void)sendMessageWithSession:(Y2WSession *)session Content:(NSArray *)content;

/**
 *  pushServer同步会话
 *
 *  @param session 推送的目的会话
 */
- (void)updateSessionWithSession:(Y2WSession *)session;
@end

/**
 *  消息变更通知
 */
FOUNDATION_EXPORT NSString *const Y2WMessageDidChangeNotification;

/**
 *  用户会话变更通知
 */
FOUNDATION_EXPORT NSString *const Y2WUserConversationDidChangeNotification;