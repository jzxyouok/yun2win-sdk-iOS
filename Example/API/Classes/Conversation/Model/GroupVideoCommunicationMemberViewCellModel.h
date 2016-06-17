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

<<<<<<< HEAD
@property (nonatomic, assign) BOOL isScreen;

=======
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
@end
