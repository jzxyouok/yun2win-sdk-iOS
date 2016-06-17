//
//  RTCConstraint.h
//  LYY
//
//  Created by QS on 16/1/22.
//  Copyright © 2016年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCMediaConstraints.h"
#import "RTCPair.h"

@interface RTCConstraint : NSObject

+ (RTCMediaConstraints *)defaultPeerConnectionConstraints;

+ (RTCMediaConstraints *)emptyOfferConstraints;

+ (RTCMediaConstraints *)defaultOfferConstraints;

+ (RTCMediaConstraints *)defaultMediaStreamConstraints;

@end
