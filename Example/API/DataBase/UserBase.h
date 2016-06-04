//
//  UserBase.h
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Realm/Realm.h>

@interface UserBase : RLMObject
/**
 *  用户ID
 */
@property NSString *userId;

/**
 *  用户名字
 */
@property NSString *name;

/**
 *  用户姓名的拼音（格式为每个字的拼音为一个元素组成的数组）
 *  示例：
 *     姓名：张三
 *     拼音：@[@"zhang",@"san"];
 */
@property NSString *pinyin;

/**
 *  用户账号/email
 */
@property NSString *account;

/**
 *  用户头像地址
 */
@property NSString *avatarUrl;

/**
 *  用户创建时间
 */
@property NSString *createdAt;

/**
 *  用户更新时间
 */
@property NSString *updatedAt;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<UserBase>
RLM_ARRAY_TYPE(UserBase)
