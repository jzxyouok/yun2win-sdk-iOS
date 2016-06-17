//
//  StatusDefine.h
//  API
//
//  Created by ShingHo on 15/12/29.
//  Copyright © 2015年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef StatusDefine_h
#define StatusDefine_h

#pragma mark - 错误相关

#pragma mark - ConnectionStatus - 网络连接状态码
/**
 *  网络连接状态码
 */
typedef NS_ENUM(NSInteger,ConnectionStatus) {
    /**
     *  正在连接
     */
    connecting          = 0,
    /**
     *  已连接
     */
    connected           = 1,
    /**
     *  重连
     */
    reconnecting        = 2,
    /**
     *  网络断开
     */
    networkDisconnected = 3,
    /**
     *  断开连接
     */
    disconnected        = 100
};

#pragma mark - ConnectionReturnCode - 连接状态
/**
 *  消息推送返回码
 */
typedef NS_ENUM(NSInteger,ConnectionReturnCode) {
    /**
     *  协议错误
     */
    unacceptableProtocolVersion = 3,
    /**
     *  用户ID无效
     */
    uidIsInvalid                = 4,
    /**
     *  imToken无效
     */
    tokenIsInvalid              = 5,
    /**
     *  imToken过期
     */
    tokenHasExpired             = 6,
    /**
     *  appkey无效
     */
    appKeyIsInvalid             = 7,
    /**
     *  被踢出，同类型设备重复登录时，之前设备收到提出信息
     */
    kicked                      = 10,
    /**
     *  服务器不可达
     */
    serverUnavailable           = 99,
    /**
     *  服务器内部错误
     */
    serverInternalError         = 100
};

#pragma mark - SendReturnCode - 发送消息的回执
/**
 *  发送消息的回执
 */
typedef NS_ENUM(NSInteger,SendReturnCode) {
    /**
     *  推送成功
     */
    success                      = 20,
    /**
     *  推送超时
     */
    timeout_sendMessage          = 21,
    /**
     *  推送命令无效
     */
    cmdIsInvalid                 = 22,
    /**
     *  会话无效
     */
    sessionIsInvalid             = 23,
    /**
     *  会话ID无效
     */
    sessionIdIsInvalid           = 24,
    /**
     *  会话成员时间戳无效
     */
    sessionMTSIsInvalid          = 25,
    /**
     *  推送服务器不存在此会话
     */
    sessionOnServerIsNotExist    = 26,
    /**
     *  客户端会话成员时间戳过期
     */
    sessionMTSOnClientHasExpired = 27,
    /**
     *  推送服务器会员时间戳过期
     */
    sessionMTSOnServerHasExpired = 28,
    /**
     *  推送服务器会话成员无效
     */
    sessionMembersIsInvalid      = 29,
    /**
     *  推送内容是无效的JSON格式
     */
    invalidFormatOfJSONContent   = 30,
    /**
     *  会话成员不存在
     */
    sessionMembersIsNull         = 31
};

#pragma mark - SendMessageSyncTypes - SendMessage的同步类型
typedef NS_ENUM(NSInteger,SendMessageSyncTypes) {
    userConversation = 0,
    message          = 1,
    contact          = 2,
    userSession      = 3
};

#endif /* StatusDefine_h */
