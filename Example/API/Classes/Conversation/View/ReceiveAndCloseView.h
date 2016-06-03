//
//  ReceiveAndCloseView.h
//  API
//
//  Created by ShingHo on 16/5/12.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReceiveAndCloseViewDelegate <NSObject>

- (void)onClickButton:(UIButton *)sender;

@end

@interface ReceiveAndCloseView : UIView
@property (nonatomic, strong) UIButton *closedButton;

@property (nonatomic, strong) UILabel *closedLabel;

@property (nonatomic, strong) UIButton *receivedButton;

@property (nonatomic, strong) UILabel *receivedLabel;

@property (nonatomic, weak) id<ReceiveAndCloseViewDelegate> delegate;

- (instancetype)initWithIsSender:(BOOL)isSender;

@end
