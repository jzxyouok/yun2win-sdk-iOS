//
//  Y2WMessagesPage.m
//  API
//
//  Created by QS on 16/3/16.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WMessagesPage.h"

@implementation Y2WMessagesPage

- (NSString *)timeStamp {
    if (!self.messageList.count) return nil;
    return [self.messageList.firstObject createdAt];
}

@end
