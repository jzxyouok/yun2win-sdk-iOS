//
//  IMClient.h
//  API
//
//  Created by ShingHo on 15/12/29.
//  Copyright © 2015年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StatusDefine.h"
#import "IMClientProtocol.h"

@protocol IMClientOnConnectionStatusChanged <NSObject>

- (void)onConnectionStatusChangedWithConnectionStatus:(ConnectionStatus)connectionStatus;

- (void)onConnectionStatusChangedWithConnectionStatus:(ConnectionStatus)connectionStatus
                                     connectionReturn:(ConnectionReturnCode)connectionReturnCode;

@end

@protocol IMClientReceiveMessageDelegate <NSObject>

/**
 *  传递发送消息后的回执信息
 *
 *  @param receiptMessage 回执信息
 */
- (void)getReceiptMessage:(NSDictionary *)receiptMessage;

@end

@interface IMClient : NSObject

/**
 *  连接协议
 */
@property (nonatomic, weak) id<IMClientOnConnectionStatusChanged> onConnectionDelegate;

/**
 *  接受消息协议
 */
@property (nonatomic, weak) id<IMClientReceiveMessageDelegate> receiptDelegate;


/**
 *  获取yun2winIMSDK的核心类
 *
 *  @return 获取yun2winIMSDK
 */
+ (instancetype)shareY2WIMClient;

/**
 *  初始化TOKEN和UID
 *
 *  @param token    从平台获取token
 *  @param uid      从平台获取uid
 *  @param appkey   从平台获取appkey
 */
- (void)registerWithToken:(NSString *)token UID:(NSString *)uid Appkey:(NSString *)appkey;

/**
 *  APNs(尚未实现)
 *
 *  @param token 从系统获取的设备token
 */
- (void)setDeviceToken:(NSString *)deviceToken;

/**
 *  与yun2win服务器建立连接
 */
- (void)connect;

/**
 *  与yun2win服务器重新建立连接
 */
- (void)reconnect;

/**
 *  与yun2win服务器断开连接
 */
- (void)disconnect;

/**
 *  推送消息
 *
 *  @param session 会话
 *  @param message 推送消息体
 */
- (void)sendMessageWithSession:(id<IMSessionProtocol>)session Message:(id<IMMessageProtocol>)message;

/**
 *  推送更新会话消息
 *
 *  @param session 对象IMSession
 *  @param message 对象IMMessage
 */
- (void)updateSessionWithSession:(id<IMSessionProtocol>)session Message:(id<IMMessageProtocol>)message;


#pragma mark - 工具类方法
/**
 *  获取SDK版本信息
 *
 *  @return
 */
- (NSString *)getSDKVersion;


@end


