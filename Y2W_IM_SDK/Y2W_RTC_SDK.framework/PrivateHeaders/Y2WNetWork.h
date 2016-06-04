//
//  Y2WNetWork.h
//  SIPDEMO
//
//  Created by QS on 16/4/25.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Y2WNetWork : NSObject

- (void)resume;

- (void)cancel;

+ (Y2WNetWork *)postWithUrl:(NSString *)url
                     params:(NSDictionary *)params
                    success:(void(^)(NSDictionary *dict))success
                       fail:(void(^)(NSError *error))fail;

+ (Y2WNetWork *)postWithUrl:(NSString *)url
                    headers:(NSDictionary *)headers
                     params:(NSDictionary *)params
                    success:(void(^)(NSDictionary *dict))success
                       fail:(void(^)(NSError *error))fail;
@end
