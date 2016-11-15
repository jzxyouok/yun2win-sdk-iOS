//
//  VideoStatusManager.h
//  yun2win
//
//  Created by duanhl on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VideoActionType) {
    VideoActionTypeCall,            //呼叫
    VideoActionTypeReject,          //拒接或挂断
    VideoActionTypeBusy,            //忙
    VideoActionTypeCancel,          //取消
};

typedef NS_ENUM(NSInteger, VideoDataType) {
    VideoDataTypeAudio,            //音频
    VideoDataTypeVideo,            //视频
};

//typedef NS_ENUM(NSInteger, VideoChatType) {
//    VideoChatTypeP2P,               //单聊
//    VideoChatTypeGroup,             //群聊
//};

@interface VideoStatusManager : NSObject

//返回拼装好的数据
+ (NSDictionary *)sendChannelId:(NSString *)channelId sessionId:(NSString *)sessionid mediaType:(VideoDataType)mediaType videoActionType:(VideoActionType)actionType videoChatType:(NSString *)chatType formUid:(NSString *)formUid toUids:(NSArray<NSString *> *)uids;

//发送操作数据
+ (void)sendChannelId:(NSString *)channelId mediaType:(VideoDataType)mediaType videoActionType:(VideoActionType)actionType formUid:(NSString *)formUid toUids:(NSArray<NSString *> *)uids sessionId:(NSString *)sessionid videoChatType:(NSString *)type;


//发送页面消息数据
+ (void)sendMessageTargetUserId:(NSString *)uid mediaType:(VideoDataType)mediaType messageText:(NSString *)text;

@end
