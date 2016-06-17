//
//  Y2WRTCChannel.h
//  SIPDEMO
//
//  Created by QS on 16/4/22.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Y2W_RTC_SDK/Y2WRTCChannelDelegate.h>
#import <Y2W_RTC_SDK/Y2WRTCMember.h>

@interface Y2WRTCChannel : NSObject

@property (nonatomic, copy) NSString *channelId;                           // 频道ID

@property (nonatomic, weak) Y2WRTCMember *currentMember;                   // 当前成员

@property (nonatomic, weak) id<Y2WRTCChannelDelegate> delegate;            // 委托对象





#pragma mark - ———— 频道 ———— -

/**
 *  获取频道内的当前成员
 *
 *  @return 成员数组
 */
- (NSArray<Y2WRTCMember *> *)getMembers;


/**
 *  加入频道
 */
- (void)join;

/**
 *  离开频道
 */
- (void)leave;




#pragma mark - ———— 音频 ———— -

/**
 *  开启音频功能
 */
- (void)openAudio;

/**
 *  关闭音频功能（关闭后无法发送和接受音频）
 */
- (void)closeAudio;


/**
 *  是否开启扬声器
 *
 *  @param speaker bool
 */
- (void)setSpeaker:(BOOL)speaker;

/**
 *  当前是否使用的扬声器
 *
 *  @return bool
 */
- (BOOL)speakerEnabled;


/**
 *  是否设置麦克风静音
 *
 *  @param mute bool
 */
- (void)setMicMute:(BOOL)mute;

/**
 *  麦克风是否静音状态
 *
 *  @return bool
 */
- (BOOL)micMuteEnabled;






#pragma mark - ———— 视频 ———— -

/**
 *  开启视频功能
 */
- (void)openVideo;

/**
 *  关闭视频功能
 */
- (void)closeVideo;


/**
 *  切换前后摄像头
 *
 *  @param use YES为使用后置摄像头
 */
- (void)useBackCamera:(BOOL)use;

/**
 *  当前是否使用的后置摄像头
 *
 *  @return YES为后置摄像头，NO为前置摄像头
 */
- (BOOL)isUseBackCamera;






//#pragma mark - ———— 屏幕共享 ———— -
//
///**
// *  开启屏幕共享
// */
//- (void)openScreen;
//
///**
// *  关闭屏幕共享
// */
//- (void)closeScreen;

@end
