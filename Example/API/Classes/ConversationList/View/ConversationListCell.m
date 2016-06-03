//
//  ConversationListCell.m
//  API
//
//  Created by ShingHo on 16/2/24.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ConversationListCell.h"

@implementation ConversationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.badgeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);

    self.avatarImageView.left = 10;
    self.avatarImageView.centerY = self.height/2;

    self.timeLabel.top = 12;
    [self.timeLabel sizeToFit];
    self.timeLabel.right = self.width - 10;
    
    self.titleLabel.top = 10;
    self.titleLabel.left = 65;
    self.titleLabel.width = self.timeLabel.left - self.titleLabel.left;
    
    self.messageLabel.left = 65;
    self.messageLabel.bottom = self.height-10;
    
    self.badgeView.width = 22;
    self.badgeView.height = 12;
    self.badgeView.top = self.timeLabel.top + self.timeLabel.height + 8;
    self.badgeView.right = self.width - 12;
}


- (void)setConversation:(Y2WUserConversation *)conversation {
    _conversation = conversation;
    
    self.avatarImageView.backgroundColor = [UIColor colorWithUID:_conversation.targetId];
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:_conversation.avatarUrl]
                         placeholderImage:[UIImage imageNamed:@"默认个人头像"]];
    
    self.titleLabel.text = _conversation.name;
    self.messageLabel.text = _conversation.lastMessage.text;
    NSDate *date = [NSDate dateWithString:_conversation.updatedAt formatString:@"yyyy-MM-dd'T'HH:mm:ss'.'SSSZ"];
    self.timeLabel.text = [NSDate timeAgoSinceDate:[date dateByAddingHours:-0]];
    self.badgeView.text = @(_conversation.unRead).stringValue;
    self.badgeView.hidden = !_conversation.unRead;
}





#pragma mark - ———— getter ———— -

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        _avatarImageView.layer.cornerRadius = 45.0/2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleRightMargin |
                                       UIViewAutoresizingFlexibleHeight;
        _titleLabel.textColor = [UIColor colorWithHexString:@"353535"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                         UIViewAutoresizingFlexibleRightMargin |
                                         UIViewAutoresizingFlexibleHeight;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _messageLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                      UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleHeight;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor colorWithHexString:@"CDCDCD"];
    }
    return _timeLabel;
}

- (UILabel *)badgeView {
    if (!_badgeView) {
        _badgeView = [[UILabel alloc] init];
        _badgeView.layer.cornerRadius = 6;
        _badgeView.layer.masksToBounds = YES;
        _badgeView.textAlignment = NSTextAlignmentCenter;
        _badgeView.backgroundColor = [UIColor colorWithHexString:@"FD6774"];
        _badgeView.font = [UIFont systemFontOfSize:9];
        _badgeView.textColor = [UIColor whiteColor];
    }
    return _badgeView;
}

@end
