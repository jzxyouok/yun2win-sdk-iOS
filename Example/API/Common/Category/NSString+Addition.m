//
//  NSString+Addition.m
//  LYY
//
//  Created by QS on 15/3/6.
//  Copyright (c) 2015年 lyy. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Addition)

-(NSString *)first {
    
    if (self.length == 0) return @"";
    return [self substringToIndex:1];
}

- (NSString *)last {
    
    if (self.length == 0) return @"";
    if (self.length == 1) return self;
    return [self substringFromIndex:self.length - 1];
}

- (BOOL)isIntegerNumber {
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return[scan scanInteger:&val] && [scan isAtEnd];
}




- (CGSize)stringSizeWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy} context:nil].size;
}




+ (NSString *)stringWithMD5OfFile: (NSString *) path {
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: path];
    if (handle == nil) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    
    BOOL done = NO;
    
    while (!done) {
        NSData *fileData = [[NSData alloc] initWithData: [handle readDataOfLength: 4096]];
        CC_MD5_Update (&md5, [fileData bytes], (float)[fileData length]);
        
        if ([fileData length] == 0) {
            done = YES;
        }
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

- (NSString *)MD5Hash {
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (float)[self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

@end
