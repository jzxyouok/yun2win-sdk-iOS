//
//  Y2WContactsDelegate.h
//  API
//
//  Created by QS on 16/3/30.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Y2WContacts,Y2WContact;
@protocol Y2WContactsDelegate <NSObject>
@optional
/**
 *  联系人增加的回调
 *
 *  @param contacts 联系人管理对象
 *  @param contact  添加的联系人
 */
- (void)contacts:(Y2WContacts *)contacts
    onAddContact:(Y2WContact *)contact;



/**
 *  联系人删除的回调
 *
 *  @param contacts 联系人管理对象
 *  @param contact  删除的联系人
 */
- (void)contacts:(Y2WContacts *)contacts
 onDeleteContact:(Y2WContact *)contact;



/**
 *  联系人更新的回调
 *
 *  @param contacts 联系人管理对象
 *  @param contact  更新的联系人
 */
- (void)contacts:(Y2WContacts *)contacts
 onUpdateContact:(Y2WContact *)contact;



/**
 *  联系人将要变化的回调
 *
 *  @param contacts 联系人管理对象
 */
- (void)contactsWillChangeContent:(Y2WContacts *)contacts;



/**
 *  联系人变化完成的回调
 *
 *  @param contacts 联系人管理对象
 */
- (void)contactsDidChangeContent:(Y2WContacts *)contacts;

@end
