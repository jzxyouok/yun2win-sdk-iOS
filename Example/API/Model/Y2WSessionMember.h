//
//  Y2WSessionMember.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WUser.h"
@class Y2WSessionMembers;

@interface Y2WSessionMember : NSObject

/**
 *  会话成员从属于会话成员管理对象，此处保存对其的引用
 */
@property (nonatomic, weak) Y2WSessionMembers *sessionMembers;

/**
 *  会话成员唯一标识码
 */
@property (nonatomic, copy) NSString *sessionMemberId;

/**
 *  用户唯一标识码
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  会话成员名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  成员头像
 */
@property (nonatomic, copy) NSString *avatarUrl;

/**
 *  联系人用户姓名的拼音（格式为每个字的拼音为一个元素组成的数）
 *  示例：
 *     姓名：张三
 *     拼音：@[@"zhang",@"san"];
 */
@property (nonatomic, strong) NSArray *pinyin;

/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *createdAt;

/**
 *  修改时间
 */
@property (nonatomic, copy) NSString *updatedAt;

/**
 *  用户角色,"master", "admin", "user"
 */
@property (nonatomic, copy) NSString *role;

/**
 *  用户状态，有效(active)，封禁(inactive)
 */
@property (nonatomic, copy) NSString *status;

/**
 *  如果为YES, 表示服务器已删除了此实体，同步时请在客户端也删除
 */
@property (nonatomic, assign) BOOL isDelete;

/**
 *  获取会话成员的用户信息
 */
@property (nonatomic, strong) Y2WUser *user;





/**
 *  初始化会话成员
 *
 *  @param value 初始化所需信息
 *
 *  @return 初始化会话成员
 */
- (instancetype)initWithValue:(id)value;

/**
 *  更新会话成员信息
 *
 *  @param member 会话成员对象
 */
- (void)updateSessionMember:(Y2WSessionMember *)member;



#pragma mark - ———— 构造方法 ———— -

/**
 *  转换成REST接口需要的结构,方便请求时调用
 */
- (NSDictionary *)toParameters;

@end

