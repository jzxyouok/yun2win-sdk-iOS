//
//  ReceiveCommunicationManage.m
//  API
//
//  Created by ShingHo on 16/5/13.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ReceiveCommunicationManage.h"
#import "ReceiveCommunicationViewController.h"

@implementation ReceiveCommunicationManage

+ (instancetype)showReceiveCommManage
{
    static dispatch_once_t once;
    static ReceiveCommunicationManage *manage;
    dispatch_once(&once, ^{
        manage = [[ReceiveCommunicationManage alloc]init];
    });
    return manage;
}

- (void)receiveCommunicationMessage:(NSDictionary *)model
{
    AVCallModel *tempModel = [[AVCallModel alloc]initWithMessage:model];
    
    ReceiveCommunicationViewController *receive = [[ReceiveCommunicationViewController alloc]initWithModel:tempModel IsSender:NO];
    [[self getCurrentVC] presentViewController:receive animated:YES completion:nil];
//    if ([model[@"avcalltype"] isEqualToString:@"audio"]) {
//        ReceiveCommunicationViewController *receive = [[ReceiveCommunicationViewController alloc]initWithCommunicationType:Communication_Audio IsSender:NO];
//        [[self getCurrentVC] presentViewController:receive animated:YES completion:nil];
//    }
//    else
//    {
//        ReceiveCommunicationViewController *receive = [[ReceiveCommunicationViewController alloc]initWithCommunicationType:Communication_Video IsSender:NO];
//        [[self getCurrentVC] presentViewController:receive animated:YES completion:nil];
//
//    }
}

//- (UIViewController *)getPresentedViewController
//{
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//    if (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    
//    return topVC;
//}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
