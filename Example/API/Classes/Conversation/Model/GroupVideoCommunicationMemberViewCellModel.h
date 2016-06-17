//
//  GroupVideoCommunicationMemberViewCellModel.h
//  API
//
//  Created by ShingHo on 16/5/10.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Y2WSessionMember;
#import <Y2W_RTC_SDK/Y2WRTCMember.h>
@interface GroupVideoCommunicationMemberViewCellModel : NSObject

@property (nonatomic, strong) Y2WSessionMember *sessionMember;

@property (nonatomic, weak) Y2WRTCMember *member;

@property (nonatomic, assign) BOOL isScreen;

@end
