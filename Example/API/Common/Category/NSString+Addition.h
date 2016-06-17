//
//  NSString+Addition.h
//  LYY
//
//  Created by QS on 15/3/6.
//  Copyright (c) 2015年 lyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)
- (NSString *)first;
- (NSString *)last;
- (BOOL)isIntegerNumber;
- (CGSize)stringSizeWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize;

+ (NSString *)stringWithMD5OfFile: (NSString *) path;
- (NSString *)MD5Hash;
@end
