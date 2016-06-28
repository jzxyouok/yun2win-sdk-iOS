//
//  UrlRequest.h
//  API
//
//  Created by ZakiHo on 16/1/30.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlRequest : NSObject

+ (void)connectForGetWithUrl:(NSString *)url
                  parameters:(NSString *)parameter
                      Header:(NSString *)headerToken
                     success:(void(^)(id data))success
                     failure:(void(^)(NSError *error))failure;

+ (void)connectForPostWithUrl:(NSString *)url
                   parameters:(NSString *)parameter
                       Header:(NSString *)headerToken
                      success:(void(^)(id data))success
                      failure:(void(^)(NSError *error))failure;

@end
