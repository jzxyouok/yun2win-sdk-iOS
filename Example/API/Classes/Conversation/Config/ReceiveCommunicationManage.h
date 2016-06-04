//
//  ReceiveCommunicationManage.h
//  API
//
//  Created by ShingHo on 16/5/13.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveCommunicationManage : NSObject

+ (instancetype)showReceiveCommManage;

- (void)receiveCommunicationMessage:(NSDictionary *)model;

@end
