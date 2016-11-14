//
//  RequestManager.m
//  yun2win
//
//  Created by QS on 16/9/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

+ (void)createChannelCompletion:(void (^)(NSString *channelId))success failure:(void (^)(NSError *))failure {
    
    [HttpRequest POSTWithURL:@"http://meeting-api.liyueyun.com:81/v1/meetrooms/room"
                     headers:@{@"Authorization": [NSString stringWithFormat:@"Bearer %@",[Y2WUsers getInstance].getCurrentUser.imToken ?: @""]}
                  parameters:@{@"userId": [Y2WUsers getInstance].getCurrentUser.ID ?: @"",
                               @"deviceType": @"iOS"}
                     success:^(id data) {
                         if (success) {
                             success(data[@"channelId"]);
                         }
                     }
                     failure:failure];
}

@end
