//
//  SingleCommunicationView.h
//  API
//
//  Created by ShingHo on 16/5/9.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleCommunicationViewDelegate <NSObject>

- (void)onTapButton:(UIButton *)sender;

@end

@interface SingleCommunicationView : UIView

@property (nonatomic, weak) id<SingleCommunicationViewDelegate> delegate;

/**
 *  切换视频通话按钮
 */
@property (nonatomic, strong) UIButton *videoChangedButton;

- (instancetype)initWithCommType:(CommType)type;


@end
