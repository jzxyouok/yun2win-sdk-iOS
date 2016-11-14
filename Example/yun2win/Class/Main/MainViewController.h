//
//  MainViewController.h
//  API
//
//  Created by ShingHo on 16/1/18.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y2WCurrentUser.h"

@interface MainViewController : UITabBarController

- (void)openAV:(NSArray *)memberIds channel:(NSString *)channelId session:(NSString *)sessionId isVideo:(BOOL)isVideo success:(void (^)(BOOL isSuccess))callback;
- (void)openAVp2p:(Y2WUser *)targetUserModel channel:(NSString *)channelId session:(NSString *)sessionId isVideo:(BOOL)isVideo success:(void (^)(BOOL isSuccess))callback;

@end
