//
//  CommunicationViewController.h
//  API
//
//  Created by ShingHo on 16/5/9.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCallModel.h"
#import <Y2W_RTC_SDK/Y2WRTCChannel.h>
//
//typedef NS_ENUM(NSInteger , CommunicationType) {
//    voiceCommunication_Send = 1,
//    voiceCommunication_Receive,
//    videoCommunication_Send,
//    videoCommunication_Receive
//};

@interface CommunicationViewController : UIViewController

- (instancetype)initWithChannel:(Y2WRTCChannel *)channel CommType:(CommType)type;

- (instancetype)initWithAVCallModel:(AVCallModel *)model Channel:(Y2WRTCChannel *)channel;

@end
