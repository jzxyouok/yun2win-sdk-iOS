//
//  HttpRequest.m
//  API
//
//  Created by ShingHo on 16/1/25.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "HttpRequest.h"


@implementation HttpRequest

+(void)GETWithURL:(NSString *)url
       parameters:(NSDictionary *)parameter
          success:(void (^)(id))success
          failure:(void (^)(id))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error.localizedDescription);
    }];
    [manager operationQueue];
    
}

+ (void)GETWithURL:(NSString *)url
         timeStamp:(NSString *)timeStamp
        parameters:(NSDictionary *)parameter
           success:(void (^)(id))success
           failure:(void (^)(id))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:timeStamp forHTTPHeaderField:@"Client-Sync-Time"];
    [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error.localizedDescription);
    }];
    [manager operationQueue];
}

+(void)POSTWithURL:(NSString *)url
        parameters:(NSDictionary *)parameter
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    [manager operationQueue];
}

+(void)POSTNoHeaderWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    [manager operationQueue];
}

+ (void)PUTWithURL:(NSString *)url
        parameters:(NSDictionary *)parameter
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    [manager operationQueue];
}

+(void)DELETEWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager DELETE:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    [manager operationQueue];
}

+ (void)UPLOADWithURL:(NSString *)url parameters:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
}

@end

@implementation HttpRequest (Category)

+ (id)cleanNullWithResponseObject:(id)responseObject
{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        return [self cleanNullWithDictionary:responseObject];
        
    }else if ([responseObject isKindOfClass:[NSArray class]]) {
        return [self cleanNullWithArray:responseObject];
        
    }else if (!responseObject) {
        return nil;
        
    }else {
        return [NSString stringWithFormat:@"%@",responseObject];
    }
}

+ (NSDictionary *)cleanNullWithDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *dict = [dic mutableCopy];
    for (NSString *key in [dict allKeys]) {
        if ([dict[key] isKindOfClass:[NSNull class]]) {
            dict[key] = @"";
            
        }else if ([dict[key] isKindOfClass:[NSDictionary class]]){
            dict[key] = [self cleanNullWithDictionary:dict[key]];
            
        }else if ([dict[key] isKindOfClass:[NSArray class]]){
            dict[key] = [self cleanNullWithArray:dict[key]];
        }
    }
    return dict;
}
+ (NSArray *)cleanNullWithArray:(NSArray *)arr
{
    NSMutableArray *array = [arr mutableCopy];
    for (int i = 0; i < array.count; i++) {
        if ([array[i] isKindOfClass:[NSNull class]]) {
            array[i] = @"";
            
        }else if ([array[i] isKindOfClass:[NSArray class]]) {
            array[i] = [self cleanNullWithArray:array[i]];
            
        }else if ([array[i] isKindOfClass:[NSDictionary class]]) {
            array[i] = [self cleanNullWithDictionary:array[i]];
        }
    }
    return array;
}

@end
