//
//  SingleCommunicationCallingView.h
//  API
//
//  Created by ShingHo on 16/5/9.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SingleCommunicationCallingViewDelegate<NSObject>

- (void)onClickBtn:(NSInteger)tag;

@end

@interface SingleCommunicationCallingView : UIView

@property (nonatomic, weak) id<SingleCommunicationCallingViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame senderIsMe:(BOOL)isMe;

@end
