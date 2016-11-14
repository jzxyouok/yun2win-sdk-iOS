//
//  GroupVideoChatCell.m
//  videoTest
//
//  Created by duanhl on 16/9/21.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import "GroupVideoChatCell.h"

@interface GroupVideoChatCell ()

@property (strong, nonatomic) UILabel       *nickName;
@property (strong, nonatomic) UIImageView   *iconImage;
@property (strong, nonatomic) UIImageView   *bgImageView;

@end


@implementation GroupVideoChatCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        _bgImageView.image = [UIImage y2w_imageNamed:@"黑色透明渐变"];
        
        _nickName = [[UILabel alloc] init];
        _nickName.backgroundColor = [UIColor clearColor];
        _nickName.textColor = [UIColor whiteColor];
        _nickName.textAlignment = NSTextAlignmentLeft;
        _nickName.font = [UIFont systemFontOfSize:12.0f];
        _nickName.numberOfLines = 1;
        
        _iconImage = [[UIImageView alloc] init];
        _iconImage.backgroundColor = [UIColor clearColor];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
        _iconImage.image = [UIImage y2w_imageNamed:@"打开状态_"];
        
        _videoView = [[UIView alloc] init];
        _videoView.backgroundColor = [UIColor clearColor];
        _videoView.hidden = YES;
        
        _audioImageView = [[UIImageView alloc] init];
        _audioImageView.contentMode = UIViewContentModeScaleAspectFill;
        _audioImageView.hidden = YES;
        
        self.contentView.layer.masksToBounds = YES;
        [self.contentView addSubview:_audioImageView];
        [self.contentView addSubview:_videoView];
        [self.contentView addSubview:_bgImageView];
        [self.contentView addSubview:_nickName];
        [self.contentView addSubview:_iconImage];
    }
    return self;
}

- (void)setUserModel:(AVMemberModel *)userModel
{
    _userModel = userModel;
    NSString *userStr = [NSString stringWithFormat:@"%ld",(long)userModel.uid];
    Y2WUser *model = [[Y2WUsers getInstance] getUserById:userStr];
    self.nickName.text = model.name;
    
    self.audioImageView.backgroundColor = [UIColor colorWithUID:userStr];
    [self.audioImageView y2w_setImageWithY2WURLString:model.avatarUrl placeholderImage:[UIImage y2w_imageNamed:@"默认个人头像"]];
    
    if (userModel.dataType == AVMemberTypeAudio) {
        self.videoView.hidden = YES;
        self.audioImageView.hidden = NO;
    }else if (userModel.dataType == AVMemberTypeVideo) {
        if (userModel.AVStatus == AVMemberStatusAnswered) {
            self.videoView.hidden = NO;
            self.audioImageView.hidden = YES;
        }else{
            self.videoView.hidden = YES;
            self.audioImageView.hidden = NO;
        }
    }else {
        self.videoView.hidden = YES;
        self.audioImageView.hidden = NO;
    }
}





//- (void)setUserModel:(AVMemberModel *)userModel
//{
//    _userModel = userModel;
//    NSString *userStr = [NSString stringWithFormat:@"%ld",(long)userModel.uid];
//    Y2WUser *model = [[Y2WUsers getInstance] getUserById:userStr];
//    self.nickName.text = model.name;
//    
//    self.audioImageView.backgroundColor = [UIColor colorWithUID:userStr];
//    [self.audioImageView y2w_setImageWithY2WURLString:model.avatarUrl placeholderImage:[UIImage y2w_imageNamed:@"默认个人头像"]];
//    
//    if (userModel.dataType == AVMemberTypeAudio) {
//        self.videoView.hidden = YES;
//    }else if (userModel.dataType == AVMemberTypeVideo) {
//        self.videoView.hidden = NO;
//    }else {
//        self.videoView.hidden = YES;
//    }
//}

#pragma mark 自动布局
- (void)layoutSubviews
{
    [super layoutSubviews];

    self.videoView.frame = self.contentView.bounds;
    self.audioImageView.frame = self.contentView.bounds;
    self.bgImageView.frame = CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 25);
    
    self.nickName.frame = CGRectMake(5.0f, self.contentView.frame.size.height - 25.0f, self.contentView.frame.size.width / 2.0f + 20.0f, 25.0f);
    self.iconImage.frame = CGRectMake(self.contentView.frame.size.width - 25.0f, self.nickName.frame.origin.y + 2.0f, 22.0f, 22.0f);
    
}


@end
