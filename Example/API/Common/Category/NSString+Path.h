//
//  NSString+Path.h
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

- (NSString *)getCachePath;

- (NSString *)tmp;

+ (NSString *)getDocumentPath;

+ (NSString *)getDocumentPathInbox:(NSString *)fileName;

+ (NSString *)getDocumentPath:(NSString *)fileName Type:(NSString *)type;
@end
