//
//  AppDelegate.h
//  yun2win
//
//  Created by ShingHo on 15/12/29.
//  Copyright © 2015年 yun2win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL      isOpenVideo;          //判断当前是否开启了视频通话状态
@property (assign, nonatomic) NSString  *curVideoUserId;      //当前视频通话的id

@end

