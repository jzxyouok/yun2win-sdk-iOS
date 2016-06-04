//
//  MessageVideoBubbleView.m
//  API
//
//  Created by ShingHo on 16/4/15.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageVideoBubbleView.h"
#import "Y2WVideoMessage.h"

@interface MessageVideoBubbleView ()

@property (nonatomic, retain) MessageModel *model;
@end

@implementation MessageVideoBubbleView

+ (instancetype)create {
    MessageVideoBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    return view;
}



- (void)refreshData:(MessageModel *)data {
    _model = data;
    Y2WBaseMessage *temp_message = _model.message;
    Y2WVideoMessage *message = (Y2WVideoMessage *)temp_message;
    [self setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:message.thumImageUrl] placeholderImage:[UIImage imageNamed:@"输入框-图片"]];
}

@end
