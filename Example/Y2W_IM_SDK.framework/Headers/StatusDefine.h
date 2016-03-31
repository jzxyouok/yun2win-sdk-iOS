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

//#pragma mark - ConnectErrorCode - 建立连接返回的错误码
//typedef NS_ENUM(NSInteger,ConntectErrorCode){
//    NET_DISCONNECT = 1000
//};
//
//#pragma mark - TokenIncorrectStatus - token状态信息
//typedef NS_ENUM(NSInteger,TokenIncorrectStatus) {
//    TOKEN_OVERDUE = -1,
//    TOKEN_DISABLE = 0,
//    TOKEN_LOSE = 1
//};
//
//#pragma mark － NetworkStatus - 当前所处的网络
//typedef NS_ENUM(NSInteger,NetworkStatus) {
//    NotReachable = 0,
//    Reachable_WIFI = 1,
//    Reachable_3G = 2,
//    Reachable_4G = 3
//};
//
//#pragma mark - SDKRunningMode - SDK当前所处的状态
///**
// *  SDK当前所处的状态
// */
//typedef NS_ENUM(NSUInteger, SDKRunningMode) {
//
//    SDKRunningMode_Backgroud = 0,
//};
//
//#pragma mark - ConversationType - 会话类型
///**
// *  会话类型
// */
//typedef NS_ENUM(NSInteger,ConversationType) {
//    /**
//     *  单聊
//     */
//    ConversationType_p2p = 0,
//    /**
//     *  群聊
//     */
//    ConversationType_group,
//    /**
//     *  帮助
//     */
//    ConversationType_assistant
//};
//
//#pragma mark - SecureType - 安全类型
///**
// *  安全类型
// */
//typedef NS_ENUM(NSInteger,SecureType) {
//    /**
//     *  公开
//     */
//    SecureType_Public = 0,
//    /**
//     *  私有
//     */
//    SecureType_Private
//};
//
//#pragma mark - GroupType - 群组类型
///**
// *  群组类型
// */
//typedef NS_ENUM(NSInteger, GroupType) {
//    /**
//     *  公开群
//     */
//    GroupType_Public = 0,
//    /**
//     *  私有群
//     */
//    GroupType_Private
//};
//
//#pragma mark - GroupRole - 群组用户角色
///**
// *  群组用户角色
// */
//typedef NS_ENUM(NSInteger, GroupRole) {
//    /**
//     *  群主
//     */
//    GroupRole_Master = 0,
//    /**
//     *  群管理员
//     */
//    GroupRole_Admin,
//    /**
//     *  群用户
//     */
//    GroupRole_user
//};
//
//#pragma mark - GroupMemberStatus - 群组用户状态
///**
// *  群组成员状态
// */
//typedef NS_ENUM(NSInteger, GroupMemberStatus) {
//    /**
//     *  有效
//     */
//    GroupMemberStatus_Active = 0,
//    /**
//     *  封禁
//     */
//    GroupMemberStatus_Inactive
//};
//
//#pragma mark - Messagetype - 消息类型
///**
// *  消息类型
// */
//typedef NS_ENUM(NSInteger, MessageType) {
//    /**
//     *  文本类型
//     */
//    Messagetype_Text = 0,
//    /**
//     *  图片类型
//     */
//    MessageType_Image,
//    /**
//     *  文件类型
//     */
//    MessageType_File
//};
//
//#pragma mark - MessagePersistent - 消息的存储策略
///**
// *  消息的存储策略
// */
//typedef NS_OPTIONS(NSUInteger, MessagePersistent) {
//    
//    MessagePersistent_NONE = 0
//    
//};
//
//#pragma mark - MessageDirection - 消息的方向
///**
// *  消息的方向
// */
//typedef NS_ENUM(NSUInteger, MessageDirection) {
//    /**
//     *  发送
//     */
//    MessageDirection_SEND = 1,
//    /**
//     *  接受
//     */
//    MessageDirection_RECEIVE
//};
//
//#pragma mark - ErrorCode - 具体业务错误码
///**
// *
// */
//typedef NS_ENUM(NSInteger,ErrorCode) {
//
//    ERRORCODE_UNKNOWN = -1
//};
//
//#pragma mark - SentStatus - 消息的发送状态
///**
// *  消息发送状态
// */
//typedef NS_ENUM(NSUInteger, SentStatus) {
//
//    SentStatus_SENDING = 10
//};
//
//#pragma mark - MediaType - 消息内容中多媒体文件的类型
///**
// *  消息内容中多媒体文件的类型
// */
//typedef NS_ENUM(NSUInteger, MediaType) {
//    /**
//     *  图片
//     */
//    MediaType_IMAGE = 1,
//    /**
//     *  语音
//     */
//    MediaType_AUDIO,
//    /**
//     *  视频
//     */
//    MediaType_VIDEO,
//    /**
//     *  其他文件
//     */
//    MediaType_FILE = 100
//};
//
//#pragma mark - ReceivedStatus - 消息的接收状态
///**
// *  消息的接收状态
// */
//typedef NS_ENUM(NSUInteger, ReceivedStatus) {
//    /**
//     *
//     */
//    ReceivedStatus_UNREAD = 0
//};
//
//#pragma mark - ConversationNotificationStatus - 会话提醒状态
//typedef NS_ENUM(NSInteger,ConversationNotificationStatus) {
//    
//    DO_NOT_DISTURB
//};
#endif /* StatusDefine_h */
