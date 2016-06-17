//
//  RTCVideoDelegate.h
//  LYY
//
//  Created by QS on 16/1/22.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RTCVideoInterface;

@class RTCVideoTrack;
@protocol RTCVideoDelegate <NSObject>

/**
 *  本地SDP创建完成
 *
 *  @param video  连接管理对象
 *  @param sdp SDP
 */
- (void)video:(id <RTCVideoInterface>)video didCreateSessionDescription:(NSString *)sdp;

/**
 *  收集到本地ICECandidate
 *
 *  @param video     连接管理对象
 *  @param candidate ICECandidate
 */
- (void)video:(id <RTCVideoInterface>)video gotICECandidate:(NSDictionary *)candidate;

/**
 *  视频追踪将要开始
 *
 *  @param video      连接管理对象
 *  @param videoTrack 视频追踪
 */
- (void)video:(id <RTCVideoInterface>)video willVideoTrack:(RTCVideoTrack *)videoTrack;

/**
 *  视频追踪已经开始
 *
 *  @param video      连接管理对象
 *  @param videoTrack 视频追踪
 */
- (void)video:(id <RTCVideoInterface>)video didVideoTrack:(RTCVideoTrack *)videoTrack;


/**
 *  连接已经关闭
 *
 *  @param video 连接管理对象
 *  @param local 是否本地主动断开
 */
- (void)video:(id <RTCVideoInterface>)video didCloseFromLocal:(BOOL)local;

/**
 *  连接失败（返回错误）
 *
 *  @param video      连接管理对象
 *  @param videoTrack 视频追踪
 */
- (void)video:(id <RTCVideoInterface>)video didFailWithError:(NSError *)error;


@end
