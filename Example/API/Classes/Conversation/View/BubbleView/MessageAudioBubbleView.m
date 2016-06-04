//
//  MessageAudioBubbleView.m
//  API
//
//  Created by ShingHo on 16/4/21.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageAudioBubbleView.h"
#import "Y2WAudioMessage.h"

@interface MessageAudioBubbleView()

@property (nonatomic ,strong) MessageModel *model;

@end

@implementation MessageAudioBubbleView

+ (instancetype)create {
    MessageAudioBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    return view;
}



- (void)refreshData:(MessageModel *)data {
    _model = data;
    Y2WBaseMessage *temp_message = _model.message;
    Y2WAudioMessage *message = (Y2WAudioMessage *)temp_message;
    if (_model.isMe) {
        self.backgroundColor = [UIColor colorWithHexString:@"6ce5dc"];
        [self setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:message.audioUrl] placeholderImage:[UIImage imageNamed:@"voice_white_play_0"]];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:message.audioUrl] placeholderImage:[UIImage imageNamed:@"voice_green_play_0"]];
    }
}



@end
