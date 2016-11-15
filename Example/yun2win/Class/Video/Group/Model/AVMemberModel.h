//
//  AVMemberModel.h
//  yun2win
//
//  Created by QS on 16/9/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AgoraRtcVideoCanvas;
@class AVMemberModel;

typedef NS_ENUM(NSInteger, AVMemberType) {
    AVMemberTypeAudio,      //音频
    AVMemberTypeVideo,      //视频
    AVMemberTypeNone,       //未接听
};

typedef NS_ENUM(NSInteger, AVMemberStatus) {
    AVMemberStatusAnswered,      //已接听
    AVMemberStatusWait,          //等待接听
    AVMemberStatusEnd,           //已结束
};

@protocol AVMemberModelDelegate <NSObject>

- (void)waitEnd:(AVMemberModel *)model;

@end


@interface AVMemberModel : NSObject

@property (assign, nonatomic) NSInteger                  uid;           //视频uid
@property (assign, nonatomic) AVMemberType               dataType;      //数据类型
@property (assign, nonatomic) BOOL                       isLocalVideo;  //是否为本地视频
@property (assign, nonatomic) BOOL                       isEnableVideo; //是否开启视频
@property (assign, nonatomic) AVMemberStatus             AVStatus;      //状态
@property (strong, nonatomic) Y2WUser                    *user;          //用户model
@property (assign, nonatomic) BOOL                       isInvitation;   //是否属于被邀请的
@property (weak, nonatomic) id<AVMemberModelDelegate>    AVMemberDelegate; //代理

@end
