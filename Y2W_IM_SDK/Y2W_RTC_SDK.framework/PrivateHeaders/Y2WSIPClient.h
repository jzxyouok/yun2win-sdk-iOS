//
//  Y2WSIPClient.h
//  SIPDEMO
//
//  Created by QS on 16/4/25.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WSIPClientConfig.h"

@class Y2WSIPClient;


typedef NS_OPTIONS(NSUInteger, Y2WSIPClientStatus) {
    Y2WSIPClientStatusNone = 0,     // 未开始服务
    Y2WSIPClientStatusStarted,      // 服务已开始
    Y2WSIPClientStatusCalling,      // 正在呼叫中
    Y2WSIPClientStatusImcoming,     // 正在被叫中
    Y2WSIPClientStatusCalled        // 呼叫已接通
};


@protocol Y2WSIPClientDelegate <NSObject>

/**
 *  出现错误的回调
 *
 *  @param client SIP管理单例对象
 *  @param error  错误对象
 */
- (void)sipClient:(Y2WSIPClient *)client onError:(NSError *)error;

/**
 *  SIP状态的回调
 *
 *  @param client SIP管理单例对象
 *  @param status 当前状态
 */
- (void)sipClient:(Y2WSIPClient *)client clientStatus:(Y2WSIPClientStatus)status;

@end




@interface Y2WSIPClient : NSObject

@property (nonatomic, assign) id<Y2WSIPClientDelegate> delegate;


/**
 *  全局单例对象
 *
 *  @return 对象实例
 */
+ (instancetype)sharedInstance;


/**
 *  添加配置
 *
 *  @param config 配置对象
 */
- (void)setConfig:(Y2WSIPClientConfig *)config;


/**
 *  呼叫
 *
 *  @param address 被叫方的账号
 */
- (void)callAddress:(NSString *)address;


/**
 *  挂断
 */
- (void)hangup;



/**
 *  设置当前频道是否静音语音
 *
 *  @param mute 是否开启语音静音
 *
 *  @return 开启语音静音是否成功
 *
 *  @discussion 切换音视频模式将丢失该设置
 */
- (BOOL)setAudioMute:(BOOL)mute;


/**
 *  查询当前频道是否静音了语音
 *
 *  @return 语音是否静音
 */
- (BOOL)audioMuteEnabled;


/**
 *  设置当前频道扬声器模式
 *
 *  @param useSpeaker 是否开启扬声器
 *
 *  @return 开启扬声器是否成功
 *
 *  @discussion 切换音视频模式将丢失该设置
 */
- (BOOL)setSpeaker:(BOOL)useSpeaker;


/**
 *  查询当前频道是否开启了扬声器输出
 *
 *  @return 扬声器输出是否已开启
 */
- (BOOL)speakerEnabled;

@end