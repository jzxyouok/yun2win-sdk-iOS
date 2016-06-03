//
//  ContactBase.h
//  API
//
//  Created by ShingHo on 16/5/6.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Realm/Realm.h>

@interface ContactBase : RLMObject

/**
 *  联系人ID
 */
@property NSString *contactId;

/**
 *  联系人的用户ID
 */
@property NSString *userId;

/**
 *  联系人名字
 */
@property NSString *name;

/**
 *  联系人用户姓名的拼音（格式为每个字的拼音为一个元素组成的数）
 *  示例：
 *     姓名：张三
 *     拼音：@[@"zhang",@"san"];
 */
@property NSString *pinyin;

/**
 *  当前登录用户对联系人的备注
 */
@property NSString *title;

/**
 *  当前登录用户对联系人的备注拼音
 */
@property NSString *titlePinyin;

/**
 *
 */
@property NSString *remark;

/**
 *  联系人创建时间
 */
@property NSString *createdAt;

/**
 *  联系人更新时间
 */
@property NSString *updatedAt;

/**
 *  联系人头像URl
 */
@property NSString *avatarUrl;

/**
 *  如果为YES, 表示服务器已删除了此实体，同步时请在客户端也删除
 */
@property BOOL isDelete;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ContactBase>
RLM_ARRAY_TYPE(ContactBase)
