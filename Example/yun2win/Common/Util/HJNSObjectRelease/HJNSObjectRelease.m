//
//  HJNSObjectRelease.h
//  HJNSObjectRelease
//
//  Created by Haijiao on 14-10-13.
//  Copyright (c) 2014年 olinone. All rights reserved.
//

#import "HJNSObjectRelease.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static NSString * const HJNSObjectNoticeName = @"HJNSObjectNoticeName";
static NSMutableArray * HJNSObjectArray;

@implementation NSObject (HJRelease)

- (instancetype)HJInit
{
    if ([self needObserveClass]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HJReceiveReleaseNotice) name:HJNSObjectNoticeName object:nil];
        objc_setAssociatedObject(self, @selector(needObserveClass), @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [self HJInit];
}

- (BOOL)needObserveClass
{
    return [NSBundle bundleForClass:[self class]] == [NSBundle mainBundle] ||
    [self isKindOfClass:[UIView class]];
}

- (void)HJReceiveReleaseNotice
{
    [self HJRemoveObserver];
    
    NSString *strClass = NSStringFromClass([self class]);
    if ([NSBundle bundleForClass:[self class]] != [NSBundle mainBundle] && [self isKindOfClass:[UIView class]]) {
        UIView *superView = [(UIView *)self superview];
        if (!superView) {
            return;
        }
        BOOL isCustomBundle = NO;
        do {
            isCustomBundle |= [NSBundle bundleForClass:[superView class]] == [NSBundle mainBundle];
            strClass = [strClass stringByAppendingFormat:@"->%@", NSStringFromClass([superView class])];
            superView = [superView superview];
        } while (superView && ![superView isMemberOfClass:[UIView class]]);
        if (!isCustomBundle) {
            return;
        }
    }
    
    if (![HJNSObjectArray containsObject:strClass]) {
        [HJNSObjectArray addObject:strClass];
    }
}

- (void)HJDealloc
{
    [self HJRemoveObserver];
    [self HJDealloc];
}

- (void)HJRemoveObserver
{
    if ([objc_getAssociatedObject(self, @selector(needObserveClass)) boolValue]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:HJNSObjectNoticeName object:nil];
    }
}

@end

@implementation HJNSObjectRelease

+ (void)createReleaseObserver
{
    static bool initFlag = NO;
    if (initFlag) {
        return;
    }
    initFlag = YES;
    
    Method ori_Method =  class_getInstanceMethod([NSObject class], @selector(init));
    Method HJ_Method = class_getInstanceMethod([NSObject class], @selector(HJInit));
    method_exchangeImplementations(ori_Method, HJ_Method);
    
    ori_Method =  class_getInstanceMethod([NSObject class], NSSelectorFromString(@"dealloc"));
    HJ_Method = class_getInstanceMethod([NSObject class], @selector(HJDealloc));
    method_exchangeImplementations(ori_Method, HJ_Method);
}

+ (void)sendReleaseNotice
{
    @autoreleasepool {
        HJNSObjectArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] postNotificationName:HJNSObjectNoticeName object:nil];
        NSLog(@"HJNSObjectLeak: %@", HJNSObjectArray);
        [HJNSObjectArray removeAllObjects];
    }
}

@end
