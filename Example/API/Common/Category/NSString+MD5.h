//
//  NSString+MD5.h
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

// MD5 hash of the file on the filesystem specified by path
+ (NSString *) stringWithMD5OfFile: (NSString *) path;
// The string's MD5 hash
- (NSString *) MD5Hash;
@end
