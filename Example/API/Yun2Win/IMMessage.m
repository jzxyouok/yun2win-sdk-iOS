//
//  IMMessage.m
//  API
//
//  Created by ShingHo on 16/3/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "IMMessage.h"

@implementation IMMessage
@synthesize y2wMessageId = _y2wMessageId;
@synthesize mts = _mts;
@synthesize message = _message;
//- (instancetype)initWithCommand:(NSString *)cmd Mts:(NSTimeInterval)mts Message:(id)message
//{
//    if ([super init]) {
//        _command = cmd;
//        _y2wMessageId = [NSUUID UUID].UUIDString;
//        _mts = mts;
//        _message = message;
//    }
//    return self;
//}

- (instancetype)initWithMts:(NSTimeInterval)mts Message:(id)message
{
    if (self = [super init]) {
        _y2wMessageId = [NSUUID UUID].UUIDString;
        _mts = mts;
        _message = message;
    }
    return self;
}

@end
