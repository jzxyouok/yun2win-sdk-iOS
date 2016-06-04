//
//  Y2WContacts.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WContactsDelegate.h"
#import "Y2WContact.h"
@class Y2WCurrentUser;
@class Y2WContactsRemote;

@interface Y2WContacts : NSObject

// 联系人管理对象从属于某一用户，此处保存对用户的引用，通常为当前用户
@property (nonatomic,weak) Y2WCurrentUser *user;

// 同步时间戳，同步时使用此时间戳获取之后的数据
@property (nonatomic, copy) NSString *updatedAt;

// 远程方法封装对象
@property (nonatomic, strong) Y2WContactsRemote *remote;



- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user;



/**
 *  添加委托对象（此对象需要实现Y2WContactsDelegate协议）
 *
 *  @param delegate 委托对象
 */
- (void)addDelegate:(id<Y2WContactsDelegate>)delegate;



/**
 *  移除委托对象
 *
 *  @param delegate 委托对象
 */
- (void)removeDelegate:(id<Y2WContactsDelegate>)delegate;



/**
 *  获取某联系人
 *
 *  @param contactId 联系人ID
 *
 *  @return 返回联系人对象
 */
- (Y2WContact *)getContactWithUID:(NSString *)uid;

- (NSArray *)getContactWithKey:(NSString *)key;

/**
 *  获取当前登陆用户的所有联系人
 *
 *  @return 返回所有联系人
 */
- (NSArray *)getContacts;

@end





@interface Y2WContactsRemote : NSObject

/**
 *  初始化一个联系人远程管理对象
 *
 *  @param contacts 引用此对象的联系人管理对象
 *
 *  @return 对象实例
 */
- (instancetype)initWithContacts:(Y2WContacts *)contacts;



/**
 *  激活联系人同步
 */
- (void)sync;



/**
 *  添加好友
 * 
 *  @param contact 要添加的联系人对象
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)addContact:(Y2WContact *)contact
           success:(void (^)(void))success
           failure:(void (^)(NSError *error))failure;



/**
 *  删除好友
 *
 *  @param contact 要删除的联系人对象
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)deleteContact:(Y2WContact *)contact
              success:(void(^)(void))success
              failure:(void (^)(NSError *error))failure;

@end