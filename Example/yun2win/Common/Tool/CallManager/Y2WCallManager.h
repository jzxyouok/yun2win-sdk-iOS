//
//  Y2WCallManager.h
//  yun2win
//
//  Created by QS on 16/10/27.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Y2WCallManager : NSObject

+ (instancetype)sharedInstance;

- (void)addDidDisconnectHandler:(dispatch_block_t)handler;

@end
