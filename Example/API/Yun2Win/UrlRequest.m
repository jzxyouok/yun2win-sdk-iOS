//
//  UrlRequest.m
//  API
//
//  Created by ZakiHo on 16/1/30.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "UrlRequest.h"

@implementation UrlRequest

+ (void)connectForGetWithUrl:(NSString *)url
                 parameters:(NSString *)parameter
                      Header:(NSString *)headerToken
                    success:(void (^)(id))success
                    failure:(void (^)(NSError *))failure
{
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    request.HTTPBody = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    if ([headerToken length]) {
        [request setValue:[NSString stringWithFormat:@"Bearer %@",headerToken] forHTTPHeaderField:@"Authorization"];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [task resume];
}

+ (void)connectForPostWithUrl:(NSString *)url
                   parameters:(NSString *)parameter
                       Header:(NSString *)headerToken
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure
{
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    request.HTTPBody = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    if ([headerToken length]) {
        [request setValue:[NSString stringWithFormat:@"Bearer %@",headerToken] forHTTPHeaderField:@"Authorization"];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    }];
    [task resume];
}

@end
