//
//  Y2WNavigationController.m
//  yun2win
//
//  Created by QS on 16/10/7.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WNavigationController.h"

@interface UINavigationController ()<UINavigationBarDelegate>
@end

@interface Y2WNavigationController ()
@end

@implementation Y2WNavigationController

//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
//    BOOL shouldPop = YES;
//    UIViewController<UINavigationBarDelegate> *topVC = (UIViewController<UINavigationBarDelegate> *)self.visibleViewController;
//    if ([topVC respondsToSelector:@selector(navigationBar:shouldPopItem:)]) {
//        shouldPop = [topVC navigationBar:navigationBar shouldPopItem:item];
//    }
//    
//    if (shouldPop) {
//        shouldPop = [super navigationBar:navigationBar shouldPopItem:item];
//    }
//    else {
//        for(UIView *subview in [navigationBar subviews]) {
//            if(0. < subview.alpha && subview.alpha < 1.) {
//                [UIView animateWithDuration:.25 animations:^{
//                    subview.alpha = 1.;
//                }];
//            }
//        }
//    }
//    return shouldPop;
//}

@end
