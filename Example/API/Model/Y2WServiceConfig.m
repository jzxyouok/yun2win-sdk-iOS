//
//  Y2WServiceConfig.m
//  API
//
//  Created by QS on 16/3/31.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WServiceConfig.h"

@implementation Y2WServiceConfig

+ (NSString *)domain {
    return @"http://112.74.210.208:8080/";
}

+ (NSString *)version {
    return @"v1";
}

+ (NSString *)baseUrl {
    return [self.domain stringByAppendingString:self.version];
}

@end