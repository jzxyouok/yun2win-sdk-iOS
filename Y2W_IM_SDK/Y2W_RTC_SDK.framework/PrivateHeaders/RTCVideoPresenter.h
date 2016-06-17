//
//  RTCVideoPresenter.h
//  LYY
//
//  Created by QS on 16/1/22.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCVideoInterface.h"

@interface RTCVideoPresenter : NSObject <RTCVideoInterface>

@property (nonatomic, assign) BOOL useBackCamera;

@end