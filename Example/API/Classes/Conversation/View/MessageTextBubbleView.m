//
//  MessageTextBubbleView.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageTextBubbleView.h"

@interface MessageTextBubbleView ()

@property (nonatomic, retain) MessageModel *model;

@property (nonatomic, retain) NSMutableDictionary *bubbleImages;

@end


@implementation MessageTextBubbleView

+ (instancetype)create {
    MessageTextBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.titleLabel.numberOfLines = 0;
    [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return view;
}


- (void)refreshData:(MessageModel *)data {
    _model = data;
    
    [self setTitleEdgeInsets:_model.contentViewInsets];
    [self.titleLabel setFont:[UIFont systemFontOfSize:_model.cellConfig.textFontSize]];
    [self setTitle:data.message.content[@"text"] forState:UIControlStateNormal];
    
    
    [self setBackgroundImage:[self chatBubbleImageForState:UIControlStateNormal outgoing:data.isMe] forState:UIControlStateNormal];
    [self setBackgroundImage:[self chatBubbleImageForState:UIControlStateHighlighted outgoing:data.isMe] forState:UIControlStateHighlighted];
    [self setNeedsLayout];
}



- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing{
    if (!_bubbleImages) _bubbleImages = [NSMutableDictionary dictionary];
    
    if (outgoing) {
        if (state == UIControlStateNormal)
        {
            UIImage *image = _bubbleImages[@"本方气泡-默认"];
            if (!image) {
                
                image = [[UIImage imageNamed:@"本方气泡-默认"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,15,14,22) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"本方气泡-默认"] = image;
            }
            return image;
            
        }else if (state == UIControlStateHighlighted)
        {
            UIImage *image = _bubbleImages[@"本方气泡-按下"];
            if (!image) {
                
                image = [[UIImage imageNamed:@"本方气泡-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,15,14,22) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"本方气泡-按下"] = image;
            }
            return image;
        }
        
    }else {
        if (state == UIControlStateNormal) {
            
            UIImage *image = _bubbleImages[@"对方气泡-默认"];
            if (!image) {
                
                image = [[UIImage imageNamed:@"对方气泡-默认"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,22,14,15) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"对方气泡-默认"] = image;
            }
            return image;
            
        }else if (state == UIControlStateHighlighted) {
            
            UIImage *image = _bubbleImages[@"对方气泡-按下"];
            if (!image) {
                
                image = [[UIImage imageNamed:@"对方气泡-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,22,14,15) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"对方气泡-按下"] = image;
            }
            return image;
        }
    }
    return nil;
}

@end
