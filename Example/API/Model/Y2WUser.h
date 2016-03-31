//
//  Y2WUser.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface Y2WUser : NSObject

/**
 *  用户ID
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  用户名字
 */
@property (nonatomic, copy) NSString *name;

/**
 *  用户姓名的拼音（格式为每个字的拼音为一个元素组成的数组）
 *  示例：
 *     姓名：张三
 *     拼音：@[@"zhang",@"san"];
 */
@property (nonatomic, strong) NSArray *pinyin;

/**
 *  用户账号/email
 */
@property (nonatomic, copy) NSString *account;

/**
 *  用户头像地址
 */
@property (nonatomic, copy) NSString *avatarUrl;

/**
 *  用户创建时间
 */
@property (nonatomic, copy) NSString *createdAt;

/**
 *  用户更新时间
 */
@property (nonatomic, copy) NSString *updatedAt;

- (instancetype)initWithValue:(id)value;

@end

