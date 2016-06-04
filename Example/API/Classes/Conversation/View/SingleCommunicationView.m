//
//  SingleCommunicationView.m
//  API
//
//  Created by ShingHo on 16/5/9.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "SingleCommunicationView.h"

@interface SingleCommunicationView()

/**
 *  挂断按钮
 */
@property (nonatomic , strong) UIButton *closedButton;

/**
 *  静音按钮
 */
@property (nonatomic, strong) UIButton *muteButton;

/**
 *  免提按钮
 */
@property (nonatomic, strong) UIButton *handsfreeButton;



@property (nonatomic, assign) CommType type;

@end

@implementation SingleCommunicationView

- (instancetype)initWithCommType:(CommType)type
{
    if (self = [super init]) {
        self.type = type;
        [self addSubview:self.closedButton];
        [self addSubview:self.muteButton];
        [self addSubview:self.handsfreeButton];
        [self addSubview:self.videoChangedButton];
    }
    return self;
}

-(void)layoutSubviews
{
    self.closedButton.centerX = self.centerX;
    self.closedButton.bottom = self.height - 30;
    
    self.muteButton.left = (self.width/2 - 90)/3;
    self.muteButton.bottom = self.height - 30;
    
    self.handsfreeButton.right = self.width - (self.width/2 - 90)/3;
    self.handsfreeButton.bottom = self.height - 30;
    
    self.videoChangedButton.centerX = self.centerX;
    self.videoChangedButton.bottom = self.closedButton.top - 30;
}

#pragma mark - Action
- (void)onClickButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onTapButton:)]) {
        [self.delegate onTapButton:sender];
    }
}

#pragma mark - Setter and Getter
- (UIButton *)closedButton
{
    if (!_closedButton) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"音视频个人_挂断_默认"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"音视频个人_挂断_点击"] forState:UIControlStateHighlighted];
        [btn setTitle:@"挂断" forState:UIControlStateNormal];
        btn.tag = 110;
        [btn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.height = btn.width = 60;
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"ffffff"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"挂断";
        [btn addSubview:label];
        label.left = 0;
        label.top = btn.bottom + 6;
        label.height = 13;
        label.width = btn.width;
        _closedButton = btn;
    }
    return _closedButton;
}

- (UIButton *)muteButton
{
    if (!_muteButton) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"音视频个人_静音_默认"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"音视频个人_静音_点击"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"音视频个人_静音_点击"] forState:UIControlStateSelected];
        [btn setTitle:@"静音" forState:UIControlStateNormal];
        btn.tag = 111;
        [btn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.height = btn.width = 60;
        btn.selected = YES;
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"ffffff"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"静音";
        [btn addSubview:label];
        label.left = 0;
        label.top = btn.bottom + 6;
        label.height = 13;
        label.width = btn.width;
        
        _muteButton = btn;
    }
    return _muteButton;
}

- (UIButton *)handsfreeButton
{
    if (!_handsfreeButton) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"音视频个人_免提_默认"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"音视频个人_免提_点击"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"音视频个人_免提_点击"] forState:UIControlStateSelected];
        [btn setTitle:@"免提" forState:UIControlStateNormal];
        btn.tag = 112;
        [btn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.height = btn.width = 60;
        btn.selected = YES;
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"ffffff"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"免提";
        [btn addSubview:label];
        label.left = 0;
        label.top = btn.bottom + 6;
        label.height = 13;
        label.width = btn.width;
        
        _handsfreeButton = btn;
    }
    return _handsfreeButton;
}

- (UIButton *)videoChangedButton
{
    if (!_videoChangedButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"音视频_摄像头_默认"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"音视频_摄像头_点击"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"音视频_摄像头_点击"] forState:UIControlStateSelected];
        btn.tag = 113;
        [btn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.height = btn.width = 60;
        
        if (!self.type)
            btn.selected = NO;
        else
            btn.selected = YES;
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"ffffff"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"切换音视频";
        [btn addSubview:label];
        label.left = 0;
        label.top = btn.bottom + 6;
        label.height = 13;
        label.width = btn.width;
        
        _videoChangedButton = btn;
    }
    return _videoChangedButton;
}


@end
