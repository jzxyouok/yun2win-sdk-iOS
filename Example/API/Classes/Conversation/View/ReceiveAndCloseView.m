//
//  ReceiveAndCloseView.m
//  API
//
//  Created by ShingHo on 16/5/12.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ReceiveAndCloseView.h"

@interface ReceiveAndCloseView()

@property (nonatomic, assign) BOOL isSender;

@end

@implementation ReceiveAndCloseView

- (instancetype)initWithIsSender:(BOOL)isSender
{
    if (self = [super init]) {
        self.isSender = isSender;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.closedButton];
        [self addSubview:self.closedLabel];
        [self addSubview:self.receivedButton];
        [self addSubview:self.receivedLabel];
        if (self.isSender) {
            self.receivedLabel.hidden = YES;
            self.receivedButton.hidden = YES;
        }
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.isSender) {
        self.closedButton.height = self.closedButton.width = 60;
        self.closedButton.centerX = self.width/2;
        self.closedButton.bottom = self.closedLabel.bottom - 33;
        
        self.closedLabel.bottom = self.height - 10;
        self.closedLabel.centerX = self.width/2;
        self.closedLabel.height = 15;
        self.closedLabel.width = 30;
        
    }
    else
    {
        self.closedButton.height = self.closedButton.width = 60;
        self.closedButton.centerX = self.width/4;
        self.closedButton.bottom = self.closedLabel.bottom - 33;
        
        self.closedLabel.bottom = self.height - 10;
        self.closedLabel.centerX = self.width/4;
        self.closedLabel.height = 15;
        self.closedLabel.width = 30;
        
        self.receivedButton.height = self.closedButton.width = 60;
        self.receivedButton.centerX = self.width/4*3;
        self.receivedButton.bottom = self.receivedLabel.bottom - 33;
        
        self.receivedLabel.bottom = self.height - 10;
        self.receivedLabel.centerX = self.width/4*3;
        self.receivedLabel.height = 15;
        self.receivedLabel.width = 30;
    }
}

- (void)clickButton:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(onClickButton:)]) {
        [self.delegate onClickButton:sender];
    }
}

- (UIButton *)closedButton
{
    if (!_closedButton) {
        _closedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closedButton setImage:[UIImage imageNamed:@"音视频个人_挂断_默认"] forState:UIControlStateNormal];
        [_closedButton setImage:[UIImage imageNamed:@"音视频个人_挂断_点击"] forState:UIControlStateHighlighted];
        _closedButton.tag = 101;
        [_closedButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
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
    }
    return _closedLabel;
}

- (UIButton *)receivedButton
{
    if (!_receivedButton) {
        _receivedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_receivedButton setImage:[UIImage imageNamed:@"音视频个人_接听_默认"] forState:UIControlStateNormal];
        [_receivedButton setImage:[UIImage imageNamed:@"音视频个人_接听_点击"] forState:UIControlStateHighlighted];
        _receivedButton.height = _receivedButton.width = 60;
        _receivedButton.tag = 102;
        [_receivedButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receivedButton;
}

- (UILabel *)receivedLabel
{
    if (!_receivedLabel) {
        _receivedLabel = [[UILabel alloc]init];
        _receivedLabel.font = [UIFont systemFontOfSize:12];
        _receivedLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _receivedLabel.text = @"接听";
        _receivedLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _receivedLabel;
}


@end
