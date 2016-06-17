//
//  AVCallModel.h
//  API
//
//  Created by ShingHo on 16/5/17.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Y2W_RTC_SDK/Y2WRTCChannel.h>

typedef NS_ENUM(NSInteger , AVCallType) {
    SingleAVCall = 0,
    GroupAVCall = 1
};

@interface AVCallModel : NSObject

@property (nonatomic, copy) NSString *senderId;

@property (nonatomic, strong) NSArray *receiverIds;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, copy) NSString *avcall;

- (instancetype)initWithChannel:(NSString *)channelId Session:(NSString *)sessionId CommunicationType:(NSString *)type sender:(NSString *)senderId receivers:(NSArray *)receiverIds AVCallType:(AVCallType)avcall;

- (instancetype)initWithMessage:(NSDictionary *)dict;

@end
