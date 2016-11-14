//
//  RequestManager.h
//  yun2win
//
//  Created by QS on 16/9/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject

+ (void)createChannelCompletion:(void (^)(NSString *channelId))success failure:(void (^)(NSError *error))failure;

@end
