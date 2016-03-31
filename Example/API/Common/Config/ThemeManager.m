//
//  ThemeManager.m
//  API
//
//  Created by QS on 16/3/11.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static ThemeManager *instance;

    dispatch_once(&onceToken, ^{
        instance = [[ThemeManager alloc] init];
    });
    return instance;
}

- (void)defaultTheme {
    self.currentColor = [UIColor colorWithHexString:@"21C0C0"];
}

- (void)update {

//    UIImage *image = [UIImage imageNamed:@"导航栏_返回"];
//    [UINavigationBar appearance].backIndicatorImage = image;
//    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = self.currentColor;
    
    [UITabBar appearance].tintColor = self.currentColor;
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
  
    [UIToolbar appearance].tintColor = self.currentColor;

    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}


#pragma mark - ———— setter ———— -

- (void)setCurrentColor:(UIColor *)currentColor {
    _currentColor = currentColor;
    
    [self update];
}

@end
