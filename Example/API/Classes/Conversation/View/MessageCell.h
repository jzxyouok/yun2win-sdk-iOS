//
//  MessageCell.h
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBubbleInterface.h"
#import "TimeStampLabel.h"
#import "MessageModel.h"


@class MessageCell;
@protocol MessageCellDelegate <NSObject>

//- (void)messageCell:()

@end

@interface MessageCell : UITableViewCell<MessageCellModelInterface>

@property (nonatomic, retain) TimeStampLabel *timeLabel;                          // 时间标签
@property (nonatomic, retain) UIImageView *headImageView;                         // 头像
@property (nonatomic, retain) UILabel *nameLabel;                                 // 姓名（群显示 个人不显示）
@property (nonatomic, retain) UIView<MessageBubbleInterface> *bubbleView;         // 内容区域
@property (nonatomic, retain) UIActivityIndicatorView *indicator;  // 发送loading
@property (nonatomic, retain) UIButton *retryButton;                              // 重试

//@property (nonatomic, weak)   id<NIMMessageCellDelegate> messageDelegate;

@end
