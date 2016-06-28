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

@property (nonatomic, strong) UIImageView *locaImg;

@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation MessageLocationBubbleView

+ (instancetype)create
{
    MessageLocationBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    
    
//    view.contentMode = UIViewContentModeCenter;
//    [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    view.titleEdgeInsets = UIEdgeInsetsMake(100, -40, 0, 0);
    
    view.locaImg = [[UIImageView alloc]init];
    view.locaImg.top = 0;
    view.locaImg.left = 0;
    view.locaImg.width = 200;
    view.locaImg.height = 120;
    [view addSubview:view.locaImg];
    
    view.addressLabel = [[UILabel alloc]init];
    view.addressLabel.textAlignment = NSTextAlignmentCenter;
    view.addressLabel.backgroundColor = [UIColor colorWithRed:53/255 green:53/255 blue:53/255 alpha:0.5];
    view.addressLabel.textColor = [UIColor whiteColor];
    view.addressLabel.font = [UIFont systemFontOfSize:12];
    view.addressLabel.left = 0;
    view.addressLabel.top = 90;
    view.addressLabel.width = 200;
    view.addressLabel.height = 30;
    [view addSubview:view.addressLabel];
        
    return view;
}

- (void)refreshData:(MessageModel *)data {
    _model = data;
    Y2WBaseMessage *temp_message = _model.message;
    Y2WLocationMessage *message = (Y2WLocationMessage *)temp_message;
    
    [self.locaImg setImageWithURL:[NSURL URLWithString:message.thumImageUrl] placeholderImage:[UIImage imageNamed:@"输入框-图片"]];
    self.addressLabel.text = message.title;
}

@end
