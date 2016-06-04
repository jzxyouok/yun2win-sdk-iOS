//
//  MessageLocationBubbleView.m
//  API
//
//  Created by ShingHo on 16/4/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageLocationBubbleView.h"
#import "Y2WLocationMessage.h"

@interface MessageLocationBubbleView ()

@property (nonatomic, retain) MessageModel *model;

//@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation MessageLocationBubbleView

+ (instancetype)create
{
#warning 图片截取显示压缩
    MessageLocationBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    view.contentMode = UIViewContentModeCenter;
//    view.addressLabel.frame = CGRectMake(0, view.frame.size.height-50, view.frame.size.width, 50);
    [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    view.titleEdgeInsets = UIEdgeInsetsMake(100, -40, 0, 0);
    return view;
}

- (void)refreshData:(MessageModel *)data {
    _model = data;
    Y2WBaseMessage *temp_message = _model.message;
    Y2WLocationMessage *message = (Y2WLocationMessage *)temp_message;
    [self setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:message.thumImageUrl] placeholderImage:[UIImage imageNamed:@"输入框-图片"]];
    [super setTitle:message.title forState:UIControlStateNormal];
}

//- (UILabel *)addressLabel
//{
//    if (!_addressLabel) {
//        _addressLabel = [[UILabel alloc]init];
//        _addressLabel.font = [UIFont systemFontOfSize:12];
//        _addressLabel.tintColor = [UIColor lightGrayColor];
//        _addressLabel.textColor = [UIColor whiteColor];
//    }
//    return _addressLabel;
//}


@end
