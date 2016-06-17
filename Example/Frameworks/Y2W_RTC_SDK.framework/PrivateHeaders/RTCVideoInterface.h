//
//  RTCVideoInterface.h
//  LYY
//
//  Created by QS on 16/1/22.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "RTCConstraint.h"
#import "RTCICEServer.h"
#import "RTCVideoTrack.h"
#import "RTCMediaStream.h"
#import "RTCICECandidate.h"
#import "RTCPeerConnection.h"
#import "RTCSessionDescription.h"
#import "RTCPeerConnectionFactory.h"
#import "RTCAVFoundationVideoSource.h"

#import "RTCSessionDescriptionDelegate.h"
#import "RTCPeerConnectionDelegate.h"
#import "RTCStatsDelegate.h"
#import "RTCVideoDelegate.h"



typedef NS_ENUM(NSInteger, RTCCodecType) {
    RTCCodecTypeVP8 = 0,
    RTCCodecTypeVP9
};



@protocol RTCVideoInterface <NSObject>

@property (nonatomic, copy) NSString *stunServerAddr;
@property (nonatomic, copy) NSString *stunServerPort;
@property (nonatomic, copy) NSString *turnServerAddr;
@property (nonatomic, copy) NSString *turnServerPort;
@property (nonatomic, copy) NSString *turnUserName;
@property (nonatomic, copy) NSString *turnPassword;
@property (nonatomic, assign) RTCCodecType codecType;


@property (nonatomic, assign) id<RTCVideoDelegate> delegate;
@property (nonatomic, retain) RTCVideoTrack *videoTrack;

- (void)start;
- (void)close;

- (void)setRemoteDescription:(NSString *)sdpStr;
- (void)addICECandidate:(NSDictionary *)candidate;

@end
