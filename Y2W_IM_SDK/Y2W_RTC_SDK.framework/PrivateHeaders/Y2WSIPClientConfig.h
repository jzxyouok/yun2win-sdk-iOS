//
//  Y2WSIPClientConfig.h
//  SIPDEMO
//
//  Created by QS on 16/4/25.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Y2WSIPClientConfig : NSObject

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *domain;

@property (nonatomic, copy) NSString *stunServer;

@property (nonatomic, assign) NSUInteger port;

@end
