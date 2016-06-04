//
//  Y2WRTCVideoView.h
//  Y2W_RTC_SDK
//
//  Created by QS on 16/4/29.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Y2WRTCVideoViewFillMode) {
    Y2WRTCVideoViewFillModeScaleAspectFill, // 裁剪
    Y2WRTCVideoViewFillModeScaleAspectFit,  // 居中
    Y2WRTCVideoViewFillModeScaleToFill      // 拉伸
};


@class Y2WRTCVideoView, Y2WRTCVideoTrack;
@protocol Y2WRTCVideoViewDelegate<NSObject>

- (void)videoView:(Y2WRTCVideoView *)videoView didChangeVideoSize:(CGSize)size;

@end




@interface Y2WRTCVideoView : UIView

@property (nonatomic, weak) Y2WRTCVideoTrack *videoTrack;

@property (nonatomic, assign) id<Y2WRTCVideoViewDelegate>delegate;

@property (nonatomic, assign) Y2WRTCVideoViewFillMode fillMode;  // 默认 Y2WRTCVideoViewFillModeScaleAspectFill

@property (nonatomic, assign) UIImage *snapshot;

@end
