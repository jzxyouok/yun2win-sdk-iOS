//
//  MessageTextCell.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageTextCell.h"
#import "MessageTextBubbleView.h"

@interface MessageTextCell ()
@property (nonatomic, retain) MessageTextBubbleView *bubbleView;                                 // 内容区域
@end


@implementation MessageTextCell
@synthesize bubbleView = _bubbleView;


- (void)refreshData:(MessageModel *)data {
    [super refreshData:data];
    [self.bubbleView refreshData:data];
    
//    self.backgroundColor = [UIColor colorWithUID:@(arc4random()).stringValue];
}



- (MessageTextBubbleView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [MessageTextBubbleView buttonWithType:UIButtonTypeCustom];
    }
    return _bubbleView;
}

@end
