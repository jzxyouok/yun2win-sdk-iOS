//
//  Y2WContact.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUser.h"
#import "Y2WSession.h"
#import "Y2WUserConversation.h"
@class Y2WContacts;

@interface Y2WContact : NSObject


/**
 *  联系人从属于联系人管理对象，此处保存对其的引用
 */
@property (nonatomic, weak) Y2WContacts *contacts;

/**
 *  联系人ID
 */
@property (nonatomic, copy) NSString *contactId;

/**
 *  联系人的用户ID
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  联系人名字
 */
@property (nonatomic, copy) NSString *name;

/**
 *  联系人用户姓名的拼音（格式为每个字的拼音为一个元素组成的数）
 *  示例：
 *     姓名：张三
 *     拼音：@[@"zhang",@"san"];
 */
@property (nonatomic, strong) NSArray *pinyin;

/**
 *  当前登录用户对联系人的备注
 */
@property (nonatomic, copy) NSString *title;

/**
 *  当前登录用户对联系人的备注拼音
 */
@property (nonatomic, copy) NSString *titlePinyin;

/**
 *
 */
@property (nonatomic, copy) NSString *remark;

/**
 *  联系人创建时间
 */
@property (nonatomic, copy) NSString *createdAt;

/**
 *  联系人更新时间
 */
@property (nonatomic, copy) NSString *updatedAt;

/**
 *  联系人头像URl
 */
@property (nonatomic, copy) NSString *avatarUrl;

/**
 *  如果为YES, 表示服务器已删除了此实体，同步时请在客户端也删除
 */
@property (nonatomic, assign) BOOL isDelete;

/**
 *  联系人的本身用户对象
 */
@property (nonatomic, strong) Y2WUser *user;




- (instancetype)initWithValue:(id)value;

/**
 *  用一个联系人对象更新一个联系人的属性
 *
 *  @param contact 需要更新的联系人对象
 */
- (void)updateWithContact:(Y2WContact *)contact;

/**
 *  获取和该联系人的用户会话
 *
 *  @return 用户会话对象（没有则返回nil）
 */
- (Y2WUserConversation *)getUserConversation;

/**
 *  获取和此联系人的session
 *
 *  @param block 结束的回调
 */
- (void)getSessionDidCompletion:(void(^)(Y2WSession *session, NSError *error))block;

@end

