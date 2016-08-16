//
//  Y2WContacts.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WContacts.h"
#import "MulticastDelegate.h"

@interface Y2WContacts ()

/**
 *  多路委托对象
 */
@property (nonatomic, retain) MulticastDelegate<Y2WContactsDelegate> *delegates;

/**
 *  所有联系人临时储存方式
 */
@property (nonatomic, strong) NSMutableArray *contactList;

@end

@implementation Y2WContacts

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user {
    if (self = [super init]) {
        self.user = user;
        self.remote = [[Y2WContactsRemote alloc] initWithContacts:self];
        MulticastDelegate *delegates = [[MulticastDelegate alloc] init];
        self.delegates = (MulticastDelegate<Y2WContactsDelegate> *)delegates;
    }
    return self;
}



#pragma mark - ———— Y2WContactsRemote调用此方法 ———— -

- (void)contactsRemote:(Y2WContactsRemote *)remote
           addContacts:(NSArray *)addContacts
        deleteContacts:(NSArray *)deleteContacts
        updateContacts:(NSArray *)updateContacts
  didCompleteWithError:(NSError *)error {
    
    if ([self.delegates respondsToSelector:@selector(contactsWillChangeContent:)]) {
        [self.delegates contactsWillChangeContent:self];
    }
    
    if ([self.delegates respondsToSelector:@selector(contacts:onAddContact:)]) {
        for (Y2WContact *contact in addContacts) {
            [self.delegates contacts:self onAddContact:contact];
        }
    }
   
    if ([self.delegates respondsToSelector:@selector(contacts:onDeleteContact:)]) {
        for (Y2WContact *contact in deleteContacts) {
            [self.delegates contacts:self onDeleteContact:contact];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(contacts:onUpdateContact:)]) {
        for (Y2WContact *contact in updateContacts) {
            [self.delegates contacts:self onUpdateContact:contact];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(contactsDidChangeContent:)]) {
        [self.delegates contactsDidChangeContent:self];
    }
}




#pragma mark - ———— Y2WContactsDelegateInterface ———— -

- (void)addDelegate:(id<Y2WContactsDelegate>)delegate {
    
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<Y2WContactsDelegate>)delegate {
    
    [self.delegates removeDelegate:delegate];
}




- (void)addContact:(Y2WContact *)contact {
    Y2WContact *model = [self getContactWithUID:contact.userId];
    if (model) [model updateWithContact:model];
    else [self.contactList addObject:contact];
}

- (void)removeContact:(Y2WContact *)contact {
    Y2WContact *model = [self getContactWithUID:contact.userId];
    if (model) [self.contactList removeObject:model];
}

- (Y2WContact *)getContactWithUID:(NSString *)uid
{
    NSMutableArray *temp_contacts = [NSMutableArray array];
    for (Y2WContact *model in [self getContacts]) {
        if ([model.userId isEqualToString:uid]) {
            [temp_contacts addObject:model];
        }
    }
    if (temp_contacts.count) return temp_contacts.firstObject;
    return nil;
}

- (NSArray *)getContactWithKey:(NSString *)key
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR userId CONTAINS[cd] %@",key,key];
    NSArray *contacts = [[self getContacts] filteredArrayUsingPredicate:predicate];
    return contacts;
}

- (NSArray *)getContacts
{
    if (self.contactList.count)
        return self.contactList;
    else
        return nil;
}

- (NSMutableArray *)contactList
{
    if (!_contactList) {
        _contactList = [NSMutableArray array];
    }
    return _contactList;
}

@end





@interface Y2WContactsRemote ()

@property (nonatomic, weak) Y2WContacts *contacts;

@end


@implementation Y2WContactsRemote

- (instancetype)initWithContacts:(Y2WContacts *)contacts {
    if (self = [super init]) {
        self.contacts = contacts;
        
//        // 初始化时启动一次同步
//        [self sync];
    }
    return self;
}


- (void)sync {
    //    NSString *conTimeStamp = [[NSUserDefaults standardUserDefaults]objectForKey:[@"conTimeStamp" stringByAppendingFormat:@"%@",USERID]];
    
    NSString *conTimeStamp;
    //若无更新时间戳时
    if (!conTimeStamp.length)
    {
        NSString *timeStamp = @"1990-01-01T00:00:00";
        [self syncContactAtTimeStamp:timeStamp];
    }
    else
    {
        [self syncContactAtTimeStamp:conTimeStamp];
    }
}

- (void)syncContactAtTimeStamp:(NSString *)timeStamp
{
    [HttpRequest GETWithURL:[URL acquireContacts] timeStamp:timeStamp parameters:@{@"limit":@50} success:^(id data) {
        NSInteger count = [data[@"total_count"] integerValue];
        if (count) {
            NSArray *arr = data[@"entries"];
            NSString *nowTimeStamp = arr[arr.count-1][@"updatedAt"];
            
            NSMutableArray *addContacts = [NSMutableArray array];
            NSMutableArray *deleteContacts = [NSMutableArray array];
            NSMutableArray *updateContacts = [NSMutableArray array];

            
            for (NSDictionary *dic in arr) {
                ContactBase *contactbase = [[ContactBase alloc]initWithValue:dic];
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [realm addOrUpdateObject:contactbase];
                [realm commitWriteTransaction];
                
                Y2WContact *contact = [[Y2WContact alloc]initWithValue:dic];
                contact.contacts = self.contacts;
                
                if (contact.isDelete) {
                    [deleteContacts addObject:contact];
                    [self.contacts removeContact:contact];
                    
                }else {
                    Y2WContact *oldContact = [self.contacts getContactWithUID:contact.userId];
                    if (oldContact) {
                        [updateContacts addObject:contact];
                        
                    }else {
                        [addContacts addObject:contact];
                    }
                    [self.contacts addContact:contact];
                }
                
            }
            
            // 通知contacts变化结果
            if ([self.contacts respondsToSelector:@selector(contactsRemote:addContacts:deleteContacts:updateContacts:didCompleteWithError:)]) {
                
                [self.contacts contactsRemote:self addContacts:addContacts deleteContacts:deleteContacts updateContacts:updateContacts didCompleteWithError:nil];
            }
         
            // todo 联系人同步完全结束后再启动
            // 同步一次用户会话
            [self.contacts.user.userConversations.remote sync];

            
            [[NSUserDefaults standardUserDefaults]setObject:nowTimeStamp forKey:[@"conTimeStamp" stringByAppendingFormat:@"%@",USERID]];
            if (count <= 50)
            {
            }
            else
            {
                [self syncContactAtTimeStamp:nowTimeStamp];
            }
            
        }
    } failure:^(id msg) {
        
    }];
}



- (void)addContact:(Y2WContact *)contact
           success:(void (^)(void))success
           failure:(void (^)(NSError *))failure {
    
    [HttpRequest POSTWithURL:[URL acquireContacts]
                  parameters:@{@"userId":contact.userId,@"name":contact.name}
                     success:^(id data) {
                         
                         // 添加成功启动同步
                         [self sync];
                         if (success) success();
                         
                     } failure:failure];
}

- (void)deleteContact:(Y2WContact *)contact
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure {
    
    [HttpRequest DELETEWithURL:[URL aboutContact:contact.contactId]
                    parameters:nil
                       success:^(id data) {
                           
                           // 添加成功启动同步
                           [self sync];
                           if (success) success();
                           
                       } failure:failure];
}

@end