//
//  IMSession.h
//  API
//
//  Created by ShingHo on 16/3/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Y2W_IM_SDK/Y2W_IM_SDK.h>

@class Y2WSession;
@interface IMSession : NSObject<IMSessionProtocol>

//@property (nonatomic, copy) NSString *imSessionId;
//
//@property (nonatomic, assign) NSTimeInterval mts;

//- (instancetype)initWithSessionId:(NSString *)sessionId MemberTimeStamp:(NSString *)mts;

- (instancetype)initWithSession:(Y2WSession *)session;

@end
