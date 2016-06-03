//
//  RTCVideoView.h
//  LYY
//
//  Created by QS on 16/1/4.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import "RTCEAGLVideoView.h"

@class RTCVideoTrack;
@interface RTCVideoView : RTCEAGLVideoView

@property (nonatomic, weak) UIImage *snapshot;

@property (nonatomic, weak) RTCVideoTrack *videoTrack;

- (void)rendingVideoTrack:(RTCVideoTrack *)track;

- (void)refresh;

@end
