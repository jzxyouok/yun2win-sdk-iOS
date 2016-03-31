//
//  UIColor+Y2WColor.m
//  API
//
//  Created by QS on 16/3/11.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "UIColor+Y2WColor.h"

@implementation UIColor (Y2WColor)

+ (UIColor *)colorWithUID:(NSString *)uid {
    NSInteger asciiCode = 0;
    if (uid.length) asciiCode = [uid characterAtIndex:uid.length - 1];

    NSString *hexString = @[@"26D1CC",@"20D3A8",@"7DCF5D",@"FFC950",@"FD6774"][asciiCode%5];
    return [UIColor colorWithHexString:hexString];
}

@end
