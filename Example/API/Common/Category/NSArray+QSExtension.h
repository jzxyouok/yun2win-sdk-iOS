//
//  NSArray+QSExtension.h
//  API
//
//  Created by QS on 16/4/5.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (QSExtension)

- (NSArray *)qs_mapObjectsUsingBlock:(id (^)(id obj, NSUInteger index))block;

- (NSArray *)qs_compact;

@end
