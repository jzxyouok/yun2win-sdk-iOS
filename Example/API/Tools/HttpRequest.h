//
//  HttpRequest.h
//  API
//
//  Created by ShingHo on 16/1/25.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//#import "AFHTTPSessionManager.h"
//#import "AFURLRequestSerialization.h"

@interface HttpRequest : NSObject

+ (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(id msg))failure;

+ (void)GETWithURL:(NSString *)url timeStamp:(NSString *)timeStamp parameters:(NSDictionary *)parameter success:(void (^)(id data))success failure:(void (^)(id msg))failure;

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

+ (void)POSTNoHeaderWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

+ (void)PUTWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

+ (void)DELETEWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;

+ (void)UPLOADWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;
@end

@interface HttpRequest (Category)
+ (id)cleanNullWithResponseObject:(id)responseObject;
@end