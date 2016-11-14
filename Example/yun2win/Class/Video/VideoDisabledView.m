//
//  VideoDisabledView.m
//  yun2win
//
//  Created by duanhl on 16/9/29.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "VideoDisabledView.h"

@interface VideoDisabledView ()

@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation VideoDisabledView

+ (VideoDisabledView *)instanceVideoDisabledView
{
    NSArray *arrayView = [[NSBundle mainBundle] loadNibNamed:@"VideoDisabledView" owner:nil options:nil];
    VideoDisabledView *videoDisabledView = [arrayView firstObject];
    videoDisabledView.avatarView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    videoDisabledView.avatarView.layer.cornerRadius = 180 / 2.0f;
    videoDisabledView.avatarImage.layer.cornerRadius = 155 / 2.0f;
    
    Y2WUser *userModel = [[Y2WUsers getInstance] getCurrentUser];
    NSString *avatarUrl = userModel.avatarUrl;
    videoDisabledView.avatarImage.backgroundColor = [UIColor colorWithUID:userModel.ID];
    [videoDisabledView.avatarImage y2w_setImageWithY2WURLString:avatarUrl placeholderImage:[UIImage y2w_imageNamed:@"默认个人头像"]];
    videoDisabledView.nickNameLabel.text = userModel.name;
    
    return videoDisabledView;
}

@end
