//
//  NSString+Path.m
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "NSString+Path.h"
#import "Y2WUsers.h"
@implementation NSString (Path)

- (NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:@"Files"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [path stringByAppendingPathComponent:self];
}

- (NSString *)tmp
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self];
}

+ (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)getDocumentPathInbox:(NSString *)fileName
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *createPath = [[self getDocumentPath] stringByAppendingFormat:@"/%@",[Y2WUsers getInstance].getCurrentUser.userId];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [createPath stringByAppendingFormat:@"/%@",fileName];
}

+ (NSString *)getDocumentPath:(NSString *)fileName Type:(NSString *)type
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *createPath = [[self getDocumentPath] stringByAppendingFormat:@"/%@/%@",[Y2WUsers getInstance].getCurrentUser.userId,type];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [createPath stringByAppendingFormat:@"/%@",fileName];
}

@end
