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
          failure:(void (^)(NSError *))failure
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
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        switch (httpResponse.statusCode) {
            case 401:
            {
                NSLog(@"401-401-401-401-401-401-401-401-401-401-401-401-401-401-401-401");
                [[Y2WUsers getInstance].getCurrentUser.remote syncTokenDidCompletion:^(NSError *tokenError) {
                    if (tokenError) {
                        if (failure) failure(tokenError);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
    }];
    [manager operationQueue];
    
}

+ (void)GETWithURL:(NSString *)url
         timeStamp:(NSString *)timeStamp
        parameters:(NSDictionary *)parameter
           success:(void (^)(id))success
           failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
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
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote syncTokenDidCompletion:^(NSError *tokenError) {
                    if (tokenError) {
                        if (failure) failure(tokenError);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
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
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote syncTokenDidCompletion:^(NSError *tokenError) {
                    if (tokenError) {
                        if (failure) failure(tokenError);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
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
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote syncTokenDidCompletion:^(NSError *tokenError) {
                    if (tokenError) {
                        if (failure) failure(tokenError);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
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
//    NSLog(@"%@",[NSString stringWithFormat:@"Bearer %@",TOKEN]);
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager PUT:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote syncTokenDidCompletion:^(NSError *tokenError) {
                    if (tokenError) {
                        if (failure) failure(tokenError);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
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
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        
        switch (httpResponse.statusCode) {
            case 401:
            {
                [[Y2WUsers getInstance].getCurrentUser.remote syncTokenDidCompletion:^(NSError *tokenError) {
                    if (tokenError) {
                        if (failure) failure(tokenError);
                        return;
                    }
                    
                    [self POSTWithURL:url parameters:parameter success:success failure:failure];
                }];
            }
                break;
                
            default:
                if (failure) failure(error);
                break;
        }
    }];
    [manager operationQueue];
}


+ (void)UPLOADWithURL:(NSString *)url parameters:(NSDictionary *)parameter fileAppend:(FileAppend *)fileAppend progress:(ProgressBlock)progress success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:[NSString stringWithMD5OfFile:fileAppend.path] forHTTPHeaderField:@"Content-MD5"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-www-form-urlencoded",@"application/json", @"multipart/form-data", @"text/plain",@"text/html", nil];
    
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:fileAppend.path]
                                    name:fileAppend.name
                                fileName:fileAppend.fileName
                                mimeType:fileAppend.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id data = [self cleanNullWithResponseObject:responseObject];
        if (success) success(data);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)DOWNLOADWithURL:(NSString *)url parameters:(NSDictionary *)parameter progress:(ProgressBlock)progress success:(void (^)(NSURL *))success failure:(void (^)(NSError *))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];

        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error) {
            success(filePath);
        }
        else{
            failure(error);
        }

        
    }];
    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        if (!error) {
//            success(filePath);
//        }
//        else{
//            failure(error);
//        }
//    }];
    [downloadTask resume];
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
