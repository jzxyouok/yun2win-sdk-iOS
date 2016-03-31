//
//  MessageModel.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageModel.h"
#import <AVFoundation/AVFoundation.h>

@implementation MessageModel
@synthesize contentViewInsets = _contentViewInsets;

- (instancetype)initWithMessage:(Y2WMessage *)message {
    
    if (self = [self init]) {
        _message = message;
    }
    return self;
}

- (void)cleanCache {
    _timeStampFrame = CGRectZero;
    _avatarFrame = CGRectZero;
    _contentFrame = CGRectZero;
    _contentViewInsets = UIEdgeInsetsZero;
}


- (void)calculateContent:(CGFloat)width{
    
    BOOL isMe = self.isMe;
    CGFloat avatar_content_margin = 3;
    CGFloat avatarMargin = self.cellConfig.avatarMargin;
    CGFloat contentMargin = 50;
    
    if (CGRectEqualToRect(_timeStampFrame, CGRectZero)) {
        
        _timeStampFrame = CGRectMake(0, 0, width, self.cellConfig.timeStampHeight * self.shouldShowTimeStamp);
    }
    
    
    if (CGRectEqualToRect(_avatarFrame, CGRectZero)) {
        
        _avatarFrame = CGRectMake(0, _timeStampFrame.size.height + 10, self.cellConfig.avatarSize, self.cellConfig.avatarSize);
        _avatarFrame.origin.x = isMe ? width - avatarMargin - self.cellConfig.avatarSize : avatarMargin;
    }
    
    
    if (CGRectEqualToRect(_contentFrame, CGRectZero)) {
        
        CGSize contentSize = CGSizeZero;
        
        if ([self.message.type isEqualToString:@"text"]) {
            contentSize = [self.message.content[@"text"] stringSizeWithWidth:width - avatarMargin - avatar_content_margin - contentMargin - self.cellConfig.timeStampHeight - self.contentViewInsets.left - self.contentViewInsets.right
                                                                  fontSize:self.cellConfig.textFontSize];
            contentSize.width += (self.contentViewInsets.left + self.contentViewInsets.right);
            contentSize.height += (self.contentViewInsets.top + self.contentViewInsets.bottom);
            
            if (contentSize.width < 40) {
                contentSize.width = 40;
            }
            if (contentSize.height < 32) {
                contentSize.height = 32;
            }
            
        }else if ([self.message.type isEqualToString:@"image"]) {
            NSDictionary *contentDict = self.message.content;
            CGSize size = CGSizeMake([contentDict[@"width"] floatValue], [contentDict[@"height"] floatValue]);
            contentSize = AVMakeRectWithAspectRatioInsideRect(size,CGRectMake(0, 0, 200, 200)).size;
        }
        
        
        _contentFrame = CGRectMake(isMe ? _avatarFrame.origin.x - contentSize.width - avatar_content_margin: _avatarFrame.origin.x + _avatarFrame.size.width + avatar_content_margin,
                                   _avatarFrame.origin.y,
                                   contentSize.width,
                                   contentSize.height);
    }
}



- (UIEdgeInsets)contentViewInsets{
    if (UIEdgeInsetsEqualToEdgeInsets(_contentViewInsets, UIEdgeInsetsZero)) {
        if ([self.message.type isEqualToString:@"text"]) {
            _contentViewInsets = self.isMe ? UIEdgeInsetsMake(10, 10, 10, 15) : UIEdgeInsetsMake(10, 15, 10, 10);
        }else {
            
        }
    }
    return _contentViewInsets;
}


- (CGFloat)cellHeight {
    return _contentFrame.origin.y + _contentFrame.size.height + 20;;
}


- (NSString *)cellClassName {
    if ([self.message.type isEqualToString:@"text"] ||
        [self.message.type isEqualToString:@"image"]) {
     
        return @"MessageCell";
    }
    return @"MessageNotiCell";
}

- (NSString *)bubbleViewClassName {
    if ([self.message.type isEqualToString:@"text"]) return @"MessageTextBubbleView";
    
    if ([self.message.type isEqualToString:@"image"]) return @"MessageImageBubbleView";

    return nil;
}


- (BOOL)isMe {
    return [[Y2WUsers getInstance].getCurrentUser.userId isEqualToString:self.message.sender];
}

- (BOOL)shouldShowTimeStamp {
    return NO;
}

- (MessageModelStatus)status {
    if ([self.message.status isEqualToString:@"storing"]) return MessageModelStatusSending;
    if ([self.message.status isEqualToString:@"storefailed"]) return MessageModelStatusSendFailed;
    return MessageModelStatusNormal;
}


@end
