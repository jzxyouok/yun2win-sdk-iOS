//
//  VideoAnsweringView.m
//  yun2win
//
//  Created by duanhl on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "VideoAnsweringView.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoAnsweringView ()
{
    AVAudioPlayer *_ringPlayer;
}

@property (weak, nonatomic) IBOutlet UIView         *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView    *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel        *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *promptLabel;

@end

@implementation VideoAnsweringView

+ (VideoAnsweringView *)instanceVideoAnsweringView
{
    NSArray *arrayView = [[NSBundle mainBundle] loadNibNamed:@"VideoAnsweringView" owner:nil options:nil];
    VideoAnsweringView *videoAnsweringView = [arrayView firstObject];
    videoAnsweringView.avatarView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    videoAnsweringView.avatarView.layer.cornerRadius = 180 / 2.0f;
    videoAnsweringView.avatarImage.layer.cornerRadius = 155 / 2.0f;
    return videoAnsweringView;
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    _infoDic = infoDic;
    NSString *dataTypeStr = [infoDic objectForKey:@"mode"];
    self.promptLabel.text = [dataTypeStr isEqualToString:@"A"] ? @"邀请您语音通话..." : @"邀请您视频通话...";
    
    NSString *senderStr = [infoDic objectForKey:@"sender"];
    Y2WUser *userModel = [[Y2WUsers getInstance] getUserById:senderStr];
    NSString *avatarUrl = userModel.avatarUrl;
    self.avatarImage.backgroundColor = [UIColor colorWithUID:userModel.ID];
    [self.avatarImage y2w_setImageWithY2WURLString:avatarUrl placeholderImage:[UIImage y2w_imageNamed:@"默认个人头像"]];
    self.nickNameLabel.text = userModel.name;
}

- (void)playMusic
{
    [_ringPlayer stop];
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"bell1" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)stopMusic
{
    [_ringPlayer stop];
}

#pragma mark 按钮点击事件
//挂断
- (IBAction)rejectionAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(VideoAnsweringView:clickRejectionBut:)]) {
        [self stopMusic];
        [self.delegate VideoAnsweringView:self clickRejectionBut:sender];
    }
}

//接听
- (IBAction)answerAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(VideoAnsweringView:clickAnswerBut:)]) {
        [self stopMusic];
        [self.delegate VideoAnsweringView:self clickAnswerBut:sender];
    }
}

@end
