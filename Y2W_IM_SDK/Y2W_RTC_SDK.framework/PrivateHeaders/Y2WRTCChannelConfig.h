//
//  Y2WRTCChannelConfig.h
//  Y2W_RTC
//
//  Created by QS on 16/4/27.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Y2WRTCChannelConfig : NSObject

// 频道id
@property (nonatomic, copy) NSString *channelId;

// socket
@property (nonatomic, copy) NSString *webSocketUrl;

// 音频
@property (nonatomic, copy) NSString *audioServerAddr;
@property (nonatomic, copy) NSString *audioServerPort;
@property (nonatomic, copy) NSString *audioServerPassword;

// 视频
@property (nonatomic, copy) NSString *videoServerAddr;
@property (nonatomic, copy) NSString *videoServerPort;
@property (nonatomic, copy) NSString *videoStunServerAddr;
@property (nonatomic, copy) NSString *videoStunServerPort;
@property (nonatomic, copy) NSString *videoTurnServerAddr;
@property (nonatomic, copy) NSString *videoTurnServerPort;
@property (nonatomic, copy) NSString *videoTurnUserName;
@property (nonatomic, copy) NSString *videoTurnPassword;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end
