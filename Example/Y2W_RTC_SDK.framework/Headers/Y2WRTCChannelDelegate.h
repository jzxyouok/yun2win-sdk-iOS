//
//  Y2WRTCChannelDelegate.h
//  SIPDEMO
//
//  Created by QS on 16/4/25.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Y2WRTCChannel,Y2WRTCMember;
@protocol Y2WRTCChannelDelegate <NSObject>
@optional
/**
 *  有成员加入此频道
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didJoinMember:(Y2WRTCMember *)member;

/**
 *  有成员离开此频道
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didLeaveMember:(Y2WRTCMember *)member;



/**
 *  有成员开启了音频
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didOpenAudioOfMember:(Y2WRTCMember *)member;

/**
 *  有成员关闭了音频
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didCloseAudioOfMember:(Y2WRTCMember *)member;

/**
 *  有成员关闭或开启了麦克风
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didSwitchMuteAudioOfMember:(Y2WRTCMember *)member;

/**
 *  音频连接出现错误
 *
 *  @param channel 频道对象
 *  @param error   错误对象
 */
- (void)channel:(Y2WRTCChannel *)channel onAudioError:(NSError *)error;



/**
 *  有成员开启了视频
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didOpenVideoOfMember:(Y2WRTCMember *)member;

/**
 *  有成员关闭了视频
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didCloseVideoOfMember:(Y2WRTCMember *)member;

/**
 *  视频连接出现错误
 *
 *  @param channel 频道对象
 *  @param error   错误对象
 */
- (void)channel:(Y2WRTCChannel *)channel onVideoError:(NSError *)error;



/**
 *  有成员开启了屏幕共享
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didOpenScreenOfMember:(Y2WRTCMember *)member;

/**
 *  有成员关闭了屏幕共享
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didCloseScreenOfMember:(Y2WRTCMember *)member;

/**
 *  屏幕共享连接出现错误
 *
 *  @param channel 频道对象
 *  @param error   错误对象
 */
- (void)channel:(Y2WRTCChannel *)channel onScreenError:(NSError *)error;

@end
