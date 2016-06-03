//
//  SingleCommunicationCallingView.m
//  API
//
//  Created by ShingHo on 16/5/9.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "SingleCommunicationCallingView.h"

#define CLOSEDBTNTAG 100
#define ANSWERBTNTAG 101

@interface SingleCommunicationCallingView()

/**
 *  挂断按钮
 */
@property (nonatomic, strong) UIButton *closedButton;
@property (nonatomic, strong) UILabel *closedLabel;
/**
 *  接听按钮
 */
@property (nonatomic, strong) UIButton *answerbutton;
@property (nonatomic, strong) UILabel *answerLabel;

/**
 *  音视频发起者
 *  是否是我
 */
@property (nonatomic, assign) BOOL isMe;

@end

@implementation SingleCommunicationCallingView

- (instancetype)initWithFrame:(CGRect)frame senderIsMe:(BOOL)isMe
{
    if (self = [super initWithFrame:frame]) {
        self.isMe = isMe;
        [self addSubview:self.closedButton];
        [self addSubview:self.closedLabel];
        [self addSubview:self.answerbutton];
        [self addSubview:self.answerLabel];
        
        if (isMe) {
            self.answerLabel.hidden = YES;
            self.answerbutton.hidden = YES;
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.isMe) {
        self.closedLabel.bottom = self.height - 20;
        self.closedLabel.centerX = self.width/2;
        self.closedButton.bottom = self.closedLabel.top - 6;
        self.closedButton.centerX = self.width/2;
    }
    else
    {
        self.closedLabel.bottom = self.height - 20;
        self.closedLabel.centerX = self.width/4;
        self.closedButton.bottom = self.closedLabel.top - 6;
        self.closedButton.centerX = self.width/4;
        
        self.answerLabel.bottom = self.height - 20;
        self.answerLabel.centerX = self.width/4*3;
        self.answerbutton.bottom = self.closedLabel.top - 6;
        self.answerbutton.centerX = self.width/4*3;
    }
}

#pragma mark - Action
- (void)clickBtn:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onClickBtn:)]) {
        [self.delegate onClickBtn:sender.tag];
    }
}

#pragma mark - Setter and Getter
- (UIButton *)closedButton
{
    if (!_closedButton) {
        _closedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closedButton.tag = CLOSEDBTNTAG;
        [_closedButton setImage:[UIImage imageNamed:@"音视频个人_挂断_默认"] forState:UIControlStateNormal];
        [_closedButton setImage:[UIImage imageNamed:@"音视频个人_挂断_点击"] forState:UIControlStateHighlighted];
        [_closedButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _closedButton.width = 60;
        _closedButton.height = 60;
    }
    return _closedButton;
}

- (UILabel *)closedLabel
{
    if (!_closedLabel) {
        _closedLabel = [[UILabel alloc]init];
        _closedLabel.font = [UIFont systemFontOfSize:12];
        _closedLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _closedLabel.text = @"挂断";
        _closedLabel.textAlignment = NSTextAlignmentCenter;
        _closedLabel.height = 15;
        _closedLabel.width = 30;
    }
    return _closedLabel;
}

- (UIButton *)answerbutton
{
    if (!_answerbutton) {
        _answerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _answerbutton.tag = ANSWERBTNTAG;
        [_answerbutton setImage:[UIImage imageNamed:@"音视频个人_接听_默认"] forState:UIControlStateNormal];
        [_answerbutton setImage:[UIImage imageNamed:@"音视频个人_接听_点击"] forState:UIControlStateHighlighted];
        _answerbutton.width = 60;
        _answerbutton.height = 60;
    }
    return _answerbutton;
}

- (UILabel *)answerLabel
{
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc]init];
        _answerLabel.font = [UIFont systemFontOfSize:12];
        _answerLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _answerLabel.text = @"接听";
        _answerLabel.textAlignment = NSTextAlignmentCenter;
        _answerLabel.height = 15;
        _answerLabel.width = 30;
    }
    return _answerLabel;
}

@end
