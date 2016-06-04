//
//  Y2WRTCManager.h
//  SIPDEMO
//
//  Created by QS on 16/4/22.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Y2W_RTC_SDK/Y2WRTCChannel.h>

@interface Y2WRTCManager : NSObject

@property (nonatomic, copy) NSString *channelId;        // 频道ID，发起方会自动获取，加入时需要填入发起方获取的ID
@property (nonatomic, copy) NSString *token;            // 用户token
@property (nonatomic, copy) NSString *memberId;         // 频道连接中的成员ID
@property (nonatomic, copy) NSString *memberName;       // 成员名
@property (nonatomic, copy) NSString *memberAvatarUrl;  // 成员头像


/**
 *  创建频道
 *
 *  @param block 创建失败会返回错误对象，成功返回频道对象，使用此对象进行操作和监听回调
 */
- (void)createChannel:(void(^)(NSError *error, Y2WRTCChannel *channel))block;

/**
 *  获取频道
 *
 *  @param block 获取失败会返回错误对象，成功返回频道对象，使用此对象进行操作和监听回调
 */
- (void)getChannel:(void(^)(NSError *error, Y2WRTCChannel *channel))block;

@end