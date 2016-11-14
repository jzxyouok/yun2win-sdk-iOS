//
//  VideoAnsweringView.h
//  yun2win
//
//  Created by duanhl on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//  视频接听页面

#import <UIKit/UIKit.h>
@class VideoAnsweringView;

@protocol VideoAnsweringDelegate <NSObject>

//点击挂断按钮
- (void)VideoAnsweringView:(VideoAnsweringView *)videoAnsweringView clickRejectionBut:(UIButton *)rejectonBut;

//点击接听按钮
- (void)VideoAnsweringView:(VideoAnsweringView *)videoAnsweringView clickAnswerBut:(UIButton *)answerBut;

@end


@interface VideoAnsweringView : UIView

+ (VideoAnsweringView *)instanceVideoAnsweringView;

- (void)playMusic;
- (void)stopMusic;

@property (nonatomic, weak) id <VideoAnsweringDelegate> delegate;
//详细信息
@property (nonatomic, strong) NSDictionary  *infoDic;

@end
