//
//  AppDelegate.m
//  yun2win
//
//  Created by ShingHo on 15/12/29.
//  Copyright © 2015年 yun2win. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self debug];
    [[ThemeManager sharedManager] defaultTheme];
    [self setMainViewController];
    
    [self pushJumpAction:launchOptions];
    
    return YES;
}

- (void)setMainViewController {
    LoginViewController *login = [[LoginViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
}


- (void)debug {
//    SWIZZ_IT;
    [[NTESCrashReporter sharedInstance] initWithAppId:@"I003061449"];
    [NTESCrashLogger initLogger:BGRLogLevelVerbose consolePrint:YES];
}

//收到视频推送消息的处理
- (void)pushJumpAction:(NSDictionary *)dic {
    if (dic) {
        NSDictionary *messageDic = [dic objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if (messageDic && [messageDic objectForKey:@"av"]) {
            if (![self.window.rootViewController isKindOfClass:[MainViewController class]]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self pushJumpAction:dic];
                });
                return;
            }  
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kPushVideoNot object:dic];
    });
}

- (void)openFileWithURL:(NSURL *)url {
    if (!self.window.rootViewController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self openFileWithURL:url];
        });
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *path = [NSString tempPathForKey:url.lastPathComponent];
        [[NSFileManager defaultManager] copyItemAtPath:url.path toPath:path error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            DocumentItem *item = [[DocumentItem alloc] initWithURL:[NSURL fileURLWithPath:path] title:url.lastPathComponent];
            DocumentViewController *documentVC = [[DocumentViewController alloc] initWithItems:@[item] currentItem:item];
            [self.window.rootViewController presentViewController:documentVC animated:YES completion:nil];
        });
    });
}

//打开手机文件的回调
//适配8.0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [self openFileWithURL:url];
    return YES;
}

//适配9.0及以后版本
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [self openFileWithURL:url];
    return YES;
}


#pragma mark - UIApplicationDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [Y2WIMClientConfig setDeviceToken:deviceToken];
    NSLog(@"%@",deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    Y2WErrorLog(@"%@",error);
}

//远程推送接收回调
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
    
    if (userInfo && [userInfo objectForKey:@"av"]) {
        [self pushJumpAction:userInfo];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    NSLog(@"%@ --- %@",identifier, userInfo);
    if (completionHandler) {
        completionHandler();
    }
}




- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_window makeKeyAndVisible];
    }
    return _window;
}

@end
