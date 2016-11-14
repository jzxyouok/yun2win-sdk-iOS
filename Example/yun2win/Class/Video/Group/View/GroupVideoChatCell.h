//
//  GroupVideoChatCell.h
//  videoTest
//
//  Created by duanhl on 16/9/21.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVMemberModel.h"

@interface GroupVideoChatCell : UICollectionViewCell

@property (nonatomic, strong) AVMemberModel         *userModel;         //用户
@property (nonatomic, strong) UIView                *videoView;         //视频view
@property (nonatomic, strong) UIImageView           *audioImageView;    //音频imageView

@end
