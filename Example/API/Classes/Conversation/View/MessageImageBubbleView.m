//
//  MessageImageBubbleView.m
//  API
//
//  Created by QS on 16/3/16.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageImageBubbleView.h"

@interface MessageImageBubbleView ()
@property (nonatomic, retain) MessageModel *model;
@end
@implementation MessageImageBubbleView

+ (instancetype)create {
    MessageImageBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    return view;
}



- (void)refreshData:(MessageModel *)data {
    _model = data;
    
    [self setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_model.message.content[@"thumbnail"] attachmentUrl]] placeholderImage:[UIImage imageNamed:@"输入框-图片"]];
    
    NSLog(@"%@",[URL attachmentsWithContent:[_model.message.content[@"thumbnail"] attachmentUrl]]);
}

@end
