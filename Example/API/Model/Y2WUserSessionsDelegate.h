//
//  Y2WUserSessionsDelegate.h
//  API
//
//  Created by QS on 16/3/30.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Y2WUserSessions,Y2WUserSession;

@protocol Y2WUserSessionsDelegate <NSObject>
@optional
/**
 *  用户群组增加的回调
 *
 *  @param userSessions 用户群组管理对象
 *  @param userSession  添加的用户群组
 */
- (void)userSessions:(Y2WUserSessions *)userSessions
    onAdduserSession:(Y2WUserSession *)userSession;



/**
 *  用户群组删除的回调
 *
 *  @param userSessions 用户群组管理对象
 *  @param userSession  删除的用户群组
 */
- (void)userSessions:(Y2WUserSessions *)userSessions
 onDeleteuserSession:(Y2WUserSession *)userSession;



/**
 *  用户群组更新的回调
 *
 *  @param userSessions 用户群组管理对象
 *  @param userSession  更新的用户群组
 */
- (void)userSessions:(Y2WUserSessions *)userSessions
 onUpdateuserSession:(Y2WUserSession *)userSession;



/**
 *  用户群组将要变化的回调
 *
 *  @param userSessions 用户群组管理对象
 */
- (void)userSessionsWillChangeContent:(Y2WUserSessions *)userSessions;



/**
 *  用户群组变化完成的回调
 *
 *  @param userSessions 用户群组管理对象
 */
- (void)userSessionsDidChangeContent:(Y2WUserSessions *)userSessions;

@end
