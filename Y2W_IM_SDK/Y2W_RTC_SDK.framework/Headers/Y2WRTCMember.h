//
//  Y2WRTCMember.h
//  SIPDEMO
//
//  Created by QS on 16/4/22.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Y2W_RTC_SDK/Y2WRTCVideoTrack.h>

@interface Y2WRTCMember : NSObject

@property (nonatomic, copy, readonly) NSString *uid;                        // 用户ID
@property (nonatomic, copy) NSString *name;                                 // 用户名
@property (nonatomic, copy) NSString *avatarUrl;                            // 用户头像

@property (nonatomic, retain, readonly) Y2WRTCVideoTrack *videoTrack;       // 视频数据流
@property (nonatomic, assign, readonly) BOOL audioOpened;                   // 是否开启了音频连接
@property (nonatomic, assign, readonly) BOOL audioMuted;                    // 是否开启了静音（关闭麦克风）
@property (nonatomic, assign, readonly) BOOL videoOpened;                   // 是否开启了视频连接

@end
