//
//  Y2WUserConversations.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WUserConversations.h"
#import "Y2WCurrentUser.h"
#import "MulticastDelegate.h"

@interface Y2WUserConversations ()

@property (nonatomic, retain) MulticastDelegate<Y2WUserConversationsDelegate> *delegates; //多路委托对象

@property (nonatomic, strong) NSMutableArray *userConversationList;

@end

@implementation Y2WUserConversations

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)user {
    if (self = [super init]) {
        self.user = user;
        self.remote = [[Y2WUserConversationsRemote alloc] initWithUserConversations:self];
        self.userConversationList = [NSMutableArray array];
        MulticastDelegate *delegates = [[MulticastDelegate alloc] init];
        self.delegates = (MulticastDelegate<Y2WUserConversationsDelegate> *)delegates;
    }
    return self;
}



#pragma mark - ———— Y2WUserConversationsRemote调用此方法 ———— -

- (void)userConversationsRemote:(Y2WUserConversationsRemote *)remote
           addUserConversations:(NSArray *)addUserConversations
        deleteUserConversations:(NSArray *)deleteUserConversations
        updateUserConversations:(NSArray *)updateUserConversations
           didCompleteWithError:(NSError *)error {
    
    if ([self.delegates respondsToSelector:@selector(userConversationsWillChangeContent:)]) {
        [self.delegates userConversationsWillChangeContent:self];
    }
    
    if ([self.delegates respondsToSelector:@selector(userConversations:onAddUserConversation:)]) {
        for (Y2WUserConversation *userConversation in addUserConversations) {
            [self.delegates userConversations:self onAddUserConversation:userConversation];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(userConversations:onDeleteUserConversation:)]) {
        for (Y2WUserConversation *userConversation in deleteUserConversations) {
            [self.delegates userConversations:self onDeleteUserConversation:userConversation];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(userConversations:onUpdateUserConversation:)]) {
        for (Y2WUserConversation *userConversation in updateUserConversations) {
            [self.delegates userConversations:self onUpdateUserConversation:userConversation];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(userConversationsDidChangeContent:)]) {
        [self.delegates userConversationsDidChangeContent:self];
    }
}




#pragma mark - ———— Y2WUserConversationsDelegateInterface ———— -

- (void)addDelegate:(id<Y2WUserConversationsDelegate>)delegate {
    
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<Y2WUserConversationsDelegate>)delegate {
    
    [self.delegates removeDelegate:delegate];
}




- (void)addUserConversation:(Y2WUserConversation *)userConversation
{
    Y2WUserConversation *model = [self getUserConversation:userConversation.userConversationId];
    if (model) [model updateWithUserConversation:userConversation];
    else [self.userConversationList addObject:userConversation];
}

- (void)removeUserConversation:(Y2WUserConversation *)userConversation {
    Y2WUserConversation *model = [self getUserConversation:userConversation.userConversationId];
    if (model) [self.userConversationList removeObject:model];
}

- (Y2WUserConversation *)getUserConversationWithTargetId:(NSString *)targetId
                                                    type:(NSString *)type {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"targetId LIKE[CD] %@ AND type LIKE[CD] %@",targetId,type];
    NSArray *userConversations = [self.userConversationList filteredArrayUsingPredicate:predicate];
    return userConversations.count ? userConversations.firstObject : nil;
}

- (NSArray *)getUserConversations
{
    if (self.userConversationList.count)
        return self.userConversationList;
    else
#warning 从数据库获取
        return nil;
}

- (Y2WUserConversation *)getUserConversation:(NSString *)userConversationId {
    
    NSMutableArray *temp_userconversations = [NSMutableArray array];
    for (Y2WUserConversation *model in [self getUserConversations]) {
        if ([model.userConversationId isEqualToString:userConversationId]) {
            [temp_userconversations addObject:model];
        }
    }
    if (temp_userconversations.count) return temp_userconversations.firstObject;
    return nil;
}

@end







@interface Y2WUserConversationsRemote ()

@property (nonatomic, weak) Y2WUserConversations *userConversations;

@end


@implementation Y2WUserConversationsRemote

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithUserConversations:(Y2WUserConversations *)userConversations {
    if (self = [super init]) {
        self.userConversations = userConversations;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sync) name:Y2WUserConversationDidChangeNotification object:nil];
    }
    return self;
}

- (void)sync
{
    //    NSString *conTimeStamp = [[NSUserDefaults standardUserDefaults]objectForKey:[@"userConversayionTimeStamp" stringByAppendingFormat:@"%@",USERID]];
    NSString *conTimeStamp;
    //若无更新时间戳时
    if (!conTimeStamp.length) {
        NSString *timeStamp = @"1990-01-01T00:00:00";
        [self syncUserConversationsAtTimeStamp:timeStamp];
    }
    else
    {
        [self syncUserConversationsAtTimeStamp:conTimeStamp];
    }
}

- (void)syncUserConversationsAtTimeStamp:(NSString *)timeStamp
{
    [HttpRequest GETWithURL:[URL userConversations] timeStamp:timeStamp parameters:@{@"limit":@"100"} success:^(id data) {
        
        NSInteger count = [data[@"total_count"] integerValue];
        if (count) {
            NSArray *arr = data[@"entries"];
            NSString *nowTimeStamp = arr[arr.count-1][@"updatedAt"];
            
            NSMutableArray *addUserConversations = [NSMutableArray array];
            NSMutableArray *deleteUserConversations = [NSMutableArray array];
            NSMutableArray *updateUserConversations = [NSMutableArray array];
            
            
            for (NSDictionary *dic in arr) {
                Y2WUserConversation *userConversation = [[Y2WUserConversation alloc] initWithDict:dic userConversations:self.userConversations];
                
                
                if (userConversation.isDelete) {
                    [deleteUserConversations addObject:userConversation];
                    [self.userConversations removeUserConversation:userConversation];
                    
                }else {
                    Y2WUserConversation *oldUserConversation = [self.userConversations getUserConversation:userConversation.userConversationId];
                    
                    if (oldUserConversation) {
                        [updateUserConversations addObject:userConversation];
                        
                    }else {
                        [addUserConversations addObject:userConversation];
                    }
                    [self.userConversations addUserConversation:userConversation];
                }
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:nowTimeStamp forKey:[@"userConversayionTimeStamp" stringByAppendingFormat:@"%@",USERID]];
            
            // 通知userConversations变化结果
            if ([self.userConversations respondsToSelector:@selector(userConversationsRemote:addUserConversations:deleteUserConversations:updateUserConversations:didCompleteWithError:)]) {

                [self.userConversations userConversationsRemote:self
                                           addUserConversations:addUserConversations
                                        deleteUserConversations:deleteUserConversations
                                        updateUserConversations:updateUserConversations
                                           didCompleteWithError:nil];
            }
            if (count <= arr.count){
                
            }
            else{
                [self syncUserConversationsAtTimeStamp:nowTimeStamp];
            }
        }
        
    } failure:^(id msg) {
        NSLog(@"msg :%@",msg);
    }];
}


- (void)deleteUserConversation:(Y2WUserConversation *)userConversation
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *))failure {
    
    [HttpRequest DELETEWithURL:[URL singleUserConversation:userConversation.userConversationId] parameters:nil success:^(id data) {
        [self sync];
        if (success) success();
    } failure:failure];
}

@end