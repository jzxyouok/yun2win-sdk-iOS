//
//  MessageCellDelegate.h
//  API
//
//  Created by ShingHo on 16/4/5.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Y2WBaseMessage;
@protocol MessageCellDelegate <NSObject>

@optional

- (void)onTapAvatar:(NSString *)userId;

- (void)onRetryMessage:(Y2WBaseMessage *)message;

- (void)onLongPressCell:(Y2WBaseMessage *)message inView:(UIView *)view;

- (void)onTapBubbleView:(Y2WBaseMessage *)message;

@end
