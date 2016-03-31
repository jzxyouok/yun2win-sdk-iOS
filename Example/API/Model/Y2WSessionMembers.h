//
//  Y2WSessionMembers.h
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y2WSessionMember.h"
#import "Y2WSessionMembersDelegate.h"
@class Y2WSession;
@class Y2WSessionMembersRemote;

@interface Y2WSessionMembers : NSObject

/**
 *  会话成员管理对象从属于某一会话，此处保存对会话的引用
 */
@property (nonatomic, weak) Y2WSession *session;

/**
 *  远程方法封装对象
 */
@property (nonatomic, strong) Y2WSessionMembersRemote *remote;

/**
 *  会话成员创建时间，用于推送消息
 */
@property (nonatomic, strong) NSString *createdAt;

/**
 *  同步时间戳，同步时使用此时间戳获取之后的数据
 */
@property (nonatomic, strong) NSString *updatedAt;





- (instancetype)initWithSession:(Y2WSession *)session;

/**
 *  获取对应的会话成员
 *
 *  @param userId 用户ID
 *
 *  @return 返回会话成员
 */
- (Y2WSessionMember *)getMemberWithUserId:(NSString *)userId;

/**
 *  获取该会话中所有的会话成员
 *
 *  @return 返回会话成员数组
 */
- (NSArray *)getMembers;

@end


@interface Y2WSessionMembersRemote : NSObject

/**
 *  初始化一个SessionMembers的远程管理对象
 *
 *  @param members 引用此对象的SessionMembers对象
 *
 *  @return 对象实例
 */
- (instancetype)initWithSessionMembers:(Y2WSessionMembers *)members;

/**
 *  同步会话成员
 */
- (void)sync;


/**
 *  添加一个成员到Session
 *
 *  @param member  添加的成员对象
 *  @param success 添加成功的回调
 *  @param failure 添加失败的回调
 */
- (void)addSessionMember:(Y2WSessionMember *)member
                 success:(void (^)(void))success
                 failure:(void(^)(NSError *error))failure;

/**
 *  添加一组成员到Session
 *
 *  @param members 添加的成员数组
 *  @param success 添加成功的回调
 *  @param failure 添加失败的回调
 */
- (void)addSessionMembers:(NSArray<Y2WSessionMember *> *)members
                  success:(void (^)(void))success
                  failure:(void(^)(NSError *error))failure;


/**
 *  删除一个Session成员
 *
 *  @param member  要删除的成员对象
 *  @param success 删除成功的回调
 *  @param failure 删除失败的回调
 */
- (void)deleteSessionMember:(Y2WSessionMember *)member
                    success:(void (^)(void))success
                    failure:(void(^)(NSError *error))failure;

@end