//
//  IMSession.m
//  API
//
//  Created by ShingHo on 16/3/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "IMSession.h"

@implementation IMSession

@synthesize imSessionId = _imSessionId;
@synthesize mts = _mts;

//- (instancetype)initWithSessionId:(NSString *)sessionId MemberTimeStamp:(NSString *)mts
//{
//    self = [super init];
//    if (self) {
//        _imSessionId = sessionId;
//        
//        NSString *temp_mts = [[mts substringWithRange:NSMakeRange(0, 19)] stringByReplacingCharactersInRange:NSMakeRange(10, 1) withString:@" "];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate *date=[formatter dateFromString:temp_mts];
//        NSTimeInterval memTS = [date timeIntervalSince1970];
//        NSTimeInterval result_mts = memTS*1000+2678400000;
//        _mts = memTS*1000+2678400000;
////        _mts = [NSString stringWithFormat:@"%lld",result_mts];
//        NSLog(@"mts: %@--------_mts : %f",mts,result_mts);
//        
//    }
//    return self;
//}

- (instancetype)initWithSession:(Y2WSession *)session
{
    self = [super init];
    if (self) {
        _imSessionId = [NSString stringWithFormat:@"%@_%@",session.type,session.sessionId];
        
        NSString *temp_mts = [[session.createMTS substringWithRange:NSMakeRange(0, 19)] stringByReplacingCharactersInRange:NSMakeRange(10, 1) withString:@" "];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[formatter dateFromString:temp_mts];
        NSTimeInterval memTS = [date timeIntervalSince1970];
        _mts = memTS*1000+28800000;
            
    }
    return self;
}

@end
