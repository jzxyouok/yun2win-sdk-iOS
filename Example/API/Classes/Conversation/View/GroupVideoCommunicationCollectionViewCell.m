//
//  GroupVideoCommunicationCollectionViewCell.m
//  API
//
//  Created by ShingHo on 16/5/10.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "GroupVideoCommunicationCollectionViewCell.h"
#import "GroupVideoCommunicationMemberViewCellModel.h"
#import <Y2W_RTC_SDK/Y2WRTCVideoView.h>

@interface GroupVideoCommunicationCollectionViewCell()

@property (nonatomic, strong) UIButton *avatarImageView;

@property (nonatomic, strong) Y2WRTCVideoView *videoView;

@end

@implementation GroupVideoCommunicationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"2a2a2a"];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.videoView];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.videoView.frame = self.bounds;
}

#pragma mark - Setter and Getter
- (void)setModel:(GroupVideoCommunicationMemberViewCellModel *)model
{
    _model = model;
    [self.avatarImageView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_model.sessionMember.avatarUrl] placeholderImage:[UIImage imageNamed:@"默认个人头像"]];
//    [self.avatarImageView setImage:[UIImage imageNamed:@"File_audio"] forState:UIControlStateNormal];
    self.videoView.videoTrack = _model.isScreen ? model.member.screenTrack : model.member.videoTrack;
}

- (UIButton *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIButton alloc]init];
        _avatarImageView.height = _avatarImageView.width = self.contentView.width;
        _avatarImageView.top = (self.contentView.height - self.contentView.width)/2;
    }
    return _avatarImageView;
}

- (Y2WRTCVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[Y2WRTCVideoView alloc] init];
        
    }
    return _videoView;
}

@end
