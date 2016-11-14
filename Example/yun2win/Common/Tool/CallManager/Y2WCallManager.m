//
//  Y2WCallManager.m
//  yun2win
//
//  Created by QS on 16/10/27.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WCallManager.h"
@import CoreTelephony;

@interface Y2WCallManager ()

@property (nonatomic, retain) CTCallCenter *callCenter;

@property (nonatomic, retain) NSMutableArray *disconnectHandlers;

@end


@implementation Y2WCallManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static Y2WCallManager *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[Y2WCallManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        self.disconnectHandlers = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}


- (void)applicationDidBecomeActive:(NSNotification *)noti {
    for (dispatch_block_t handler in self.disconnectHandlers.copy) {
        handler();
    }
    [self.disconnectHandlers removeAllObjects];
}



- (void)addDidDisconnectHandler:(dispatch_block_t)handler {
    if (handler) {
        [self.disconnectHandlers addObject:handler];
    }
}



- (CTCallCenter *)callCenter {
    if (!_callCenter) {
        _callCenter = [[CTCallCenter alloc] init];
        [_callCenter setCallEventHandler:^(CTCall *call) {
             if ([call.callState isEqualToString: CTCallStateConnected]) {
                 NSLog(@"Connected");
             }
             else if ([call.callState isEqualToString: CTCallStateDialing]) {
                 NSLog(@"Dialing");
             }
             else if ([call.callState isEqualToString: CTCallStateDisconnected]) {
                 NSLog(@"Disconnected");
                 
             } else if ([call.callState isEqualToString: CTCallStateIncoming]) {
                 NSLog(@"Incomming");
             }
         }];
    }
    return _callCenter;
}

@end
