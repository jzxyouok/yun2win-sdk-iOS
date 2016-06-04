//
//  AVCallModel.m
//  API
//
//  Created by ShingHo on 16/5/17.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "AVCallModel.h"

@implementation AVCallModel

- (instancetype)initWithChannel:(NSString *)channelId Session:(NSString *)sessionId CommunicationType:(NSString *)type sender:(NSString *)senderId receivers:(NSArray *)receiverIds AVCallType:(AVCallType)avcall
{
    if (self = [super init]) {
        self.senderId = senderId;
        self.receiverIds = receiverIds;;
        self.type = type;
        self.channelId = channelId;
        self.sessionId = sessionId;
        self.avcall = avcall?@"groupavcall":@"singleavcall";
    }
    return self;
}

- (instancetype)initWithMessage:(NSDictionary *)dict
{
    if (self = [super init]) {
        NSDictionary *dic = dict[@"content"];
        self.senderId = dic[@"senderId"];
        self.receiverIds = dic[@"receiversIds"];;
        self.type = dic[@"avcalltype"];
        self.channelId = dic[@"channelId"];
        self.sessionId = dic[@"sessionId"];
        self.avcall = dict[@"type"];
    }
    return self;
}

@end
