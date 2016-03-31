//
//  MainViewController.m
//  API
//
//  Created by ShingHo on 16/1/18.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MainViewController.h"
#import "ConversationListViewController.h"
#import "ContactsViewController.h"
#import "SettingViewController.h"

@interface MainViewController ()<UINavigationBarDelegate>

@end

#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"
#define TabbarItemBadgeValue @"badgeValue"  //未读数

@implementation MainViewController

+ (instancetype)instance {
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([vc isKindOfClass:[MainViewController class]]) {
        return (MainViewController *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubNav];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpStatusBar];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)setUpSubNav{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [self.tabbars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * item = obj;
        NSString * vcName = item[TabbarVC];
        NSString * title  = item[TabbarTitle];
        NSString * imageName = item[TabbarImage];
        NSString * imageSelected = item[TabbarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController * vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = NO;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        nav.delegate = self;
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[UIImage imageNamed:imageName]
                                               selectedImage:[UIImage imageNamed:imageSelected]];
        nav.tabBarItem.tag = idx;
        NSInteger badge = [item[TabbarItemBadgeValue] integerValue];
        if (badge) {
            nav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge];
        }
        [array addObject:nav];
    }];
    self.viewControllers = array;
}

- (void)setUpStatusBar{
    UIStatusBarStyle style = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}

- (NSArray*)tabbars{

    NSArray *item = @[
                      @{
                          TabbarVC           : @"ConversationListViewController",
                          TabbarTitle        : @"交流",
                          TabbarImage        : @"交流-默认",
                          TabbarSelectedImage: @"交流-选中",
                          TabbarItemBadgeValue: @(0)
                          },
                      @{
                          TabbarVC           : @"ContactsViewController",
                          TabbarTitle        : @"通讯录",
                          TabbarImage        : @"通讯录-默认",
                          TabbarSelectedImage: @"通讯录-选中",
                          TabbarItemBadgeValue: @(0)
                          },
                      @{
                          TabbarVC           : @"SettingViewController",
                          TabbarTitle        : @"设置",
                          TabbarImage        : @"设置-默认",
                          TabbarSelectedImage: @"设置-选中",
                          TabbarItemBadgeValue: @(0)
                          },
                      
                      ];
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
