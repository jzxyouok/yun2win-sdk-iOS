//
//  GroupVideoCommunicationViewController.h
//  API
//
//  Created by ShingHo on 16/5/11.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCallModel.h"
#import <Y2W_RTC_SDK/Y2WRTCChannel.h>
//typedef NS_ENUM(NSInteger , CommType) {
//    commAudio = 1,
//    commVideo,
//};

@interface GroupVideoCommunicationViewController : UIViewController

- (instancetype)initWithChannel:(Y2WRTCChannel *)channel SessionId:(NSString *)sessionId commType:(CommType)commtype;

- (instancetype)initWithAVCallModel:(AVCallModel *)model withChannel:(Y2WRTCChannel *)channel;

@end
