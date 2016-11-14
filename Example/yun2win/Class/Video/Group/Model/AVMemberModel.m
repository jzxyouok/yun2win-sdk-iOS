//
//  AVMemberModel.m
//  yun2win
//
//  Created by QS on 16/9/22.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "AVMemberModel.h"
#define kWaitTime   30

@implementation AVMemberModel


- (void)setAVStatus:(AVMemberStatus)AVStatus
{
    _AVStatus = AVStatus;
    if (AVStatus == AVMemberStatusWait) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(timingAction) withObject:nil afterDelay:kWaitTime];
        
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)timingAction{
    if (self.AVMemberDelegate && [self.AVMemberDelegate respondsToSelector:@selector(waitEnd:)]) {
        [self.AVMemberDelegate waitEnd:self];
    }
}

@end
