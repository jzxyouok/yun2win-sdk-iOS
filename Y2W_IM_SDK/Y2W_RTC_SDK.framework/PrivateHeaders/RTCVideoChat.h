//
//  RTCVideoChat.h
//  LYY
//
//  Created by QS on 16/1/5.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Y2W_RTC_SDK/RTCPair.h>
#import <Y2W_RTC_SDK/RTCVideoView.h>
#import <Y2W_RTC_SDK/RTCICEServer.h>
#import <Y2W_RTC_SDK/RTCAudioTrack.h>
#import <Y2W_RTC_SDK/RTCVideoTrack.h>
#import <Y2W_RTC_SDK/RTCMediaStream.h>
#import <Y2W_RTC_SDK/RTCICECandidate.h>
#import <Y2W_RTC_SDK/RTCStatsDelegate.h>
#import <Y2W_RTC_SDK/RTCEAGLVideoView.h>
#import <Y2W_RTC_SDK/RTCPeerConnection.h>
#import <Y2W_RTC_SDK/RTCMediaConstraints.h>
#import <Y2W_RTC_SDK/RTCSessionDescription.h>
#import <Y2W_RTC_SDK/RTCPeerConnectionFactory.h>
#import <Y2W_RTC_SDK/RTCAVFoundationVideoSource.h>
#import <Y2W_RTC_SDK/RTCPeerConnectionInterface.h>
#import <Y2W_RTC_SDK/RTCSessionDescriptionDelegate.h>

typedef void (^VideoTrackBlock) (RTCVideoTrack *videoTrack);


@interface RTCVideoChat : NSObject

@property (nonatomic, copy) NSString *stun;
@property (nonatomic, copy) NSString *turn;


@property (nonatomic, retain) RTCVideoTrack *localVideoTrack;
@property (nonatomic, retain) RTCVideoTrack *remoteVideoTrack;

@property(nonatomic, assign) BOOL useBackCamera;

- (void)createOfferHandler:(void (^) (NSString *string))offerBlock;
- (void)gotICECandidateHandler:(void (^) (NSDictionary *dict))candidateBlock
        localVideoTrackHandler:(VideoTrackBlock)localBlock
       remoteVideoTrackHandler:(VideoTrackBlock)remoteBlock;

- (void)setRemoteDescription:(NSString *)sdpStr;
- (void)addICECandidate:(NSDictionary *)candidate;

- (void)close;




/**
 *  关闭本地视频
 */
- (void)muteVideoIn;

/**
 *  开启本地视频
 */
- (void)unmuteVideoIn;

/**
 *  关闭麦克风
 */
- (void)muteAudioIn;

/**
 *  开启麦克风
 */
- (void)unmuteAudioIn;

/**
 *  关闭扬声器
 */
- (void)disableSpeaker;

/**
 *  开启扬声器
 */
- (void)enableSpeaker;

@end
