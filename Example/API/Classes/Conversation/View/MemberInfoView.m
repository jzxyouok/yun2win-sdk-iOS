//
//  MemberInfoView.m
//  API
//
//  Created by ShingHo on 16/5/26.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MemberInfoView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define multiplied(float) (WIDTH/375)*float
@interface MemberInfoView()

@property (nonatomic, strong) UIButton *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *invitingLabel;

@property (nonatomic, strong) UIImageView *commTypeView;

@end

@implementation MemberInfoView

 - (instancetype)init
{
    if (self = [super initWithImage:[UIImage imageNamed:@"音视频_背景图"]]) {
        [self addSubview:self.avatarView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.commTypeView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    self.avatarView.top = multiplied(80);
    self.avatarView.centerX = self.centerX;
    
    self.nameLabel.top = self.avatarView.bottom + multiplied(15);
    self.nameLabel.centerX = self.centerX;
    
    self.commTypeView.top = self.nameLabel.bottom + multiplied(60);
    self.commTypeView.centerX = self.centerX;
}

-(void)setAvatarUrl:(NSString *)avatarUrl
{
    _avatarUrl = avatarUrl;
    [self.avatarView setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_avatarUrl] placeholderImage:[UIImage imageNamed:@"默认群头像"]];
}

-(void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;
}

- (void)setVideoMode:(BOOL)videoMode
{
    _videoMode = videoMode;
    self.commTypeView.highlighted = _videoMode;
}

#pragma mark - Setter
- (UIButton *)avatarView
{
    if (!_avatarView) {
        _avatarView = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.2].CGColor;
        _avatarView.layer.borderWidth = 10;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = multiplied(70);
        _avatarView.width = _avatarView.height = multiplied(140);
    }
    return _avatarView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:24];
        _nameLabel.textColor = [UIColor  colorWithHexString:@"ffffff"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.height = 25;
        _nameLabel.width = self.width;
    }
    return _nameLabel;
}

- (UIImageView *)commTypeView
{
    if (!_commTypeView) {
        _commTypeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"音视频_语音通话提示图"] highlightedImage:[UIImage imageNamed:@"音视频_视频通话提示图"]];
        
    }
    return _commTypeView;
}

@end
