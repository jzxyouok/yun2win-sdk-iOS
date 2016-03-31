//
//  Y2WUsers.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

NSString *const CURRENT_USER_KEY = @"currentUser";

#import "Y2WUsers.h"

@interface Y2WUsers ()

@property (nonatomic, retain, readwrite) Y2WUsersRemote *remote;

/**
 *  当前生命周期所维持的当前登录用户
 */
@property (nonatomic, retain) Y2WCurrentUser *currentUser;

/**
 *  所有用户数据的临时存储方式
 */
@property (nonatomic, retain) NSMutableArray *userList;

@end

@implementation Y2WUsers

+ (instancetype)getInstance {
    
    static dispatch_once_t once;
    static Y2WUsers *users;
    dispatch_once(&once, ^{
        users = [[Y2WUsers alloc]init];
        users.remote = [[Y2WUsersRemote alloc] initWithUsers:users];
        users.userList = [NSMutableArray array];
    });
    return users;
}

- (Y2WCurrentUser *)getCurrentUser {

    if (!_currentUser) {
#warning 每次都取，可考虑过token过期的问题？ 风险2
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_KEY];
        if (dict) _currentUser = [[Y2WCurrentUser alloc]initWithValue:dict];
    }
    return _currentUser;
}

- (void)addUser:(Y2WUser *)user {
    // 如果已经有此用户则更新
    Y2WUser *oldUser = [self getUserWithUserId:user.userId];
    if (oldUser) [self.userList removeObject:oldUser];

    [self.userList addObject:user];
}

- (Y2WUser *)getUserWithUserId:(NSString *)userId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId LIKE[CD] %@",userId];
    NSArray *users = [self.userList filteredArrayUsingPredicate:predicate];
    if (users.count) return users.firstObject;
    return nil;
}


@end






@interface Y2WUsersRemote ()

@property (nonatomic, retain) Y2WUsers *users;

@end

@implementation Y2WUsersRemote

- (instancetype)initWithUsers:(Y2WUsers *)users {
    if (self = [super init]) {
        self.users = users;
    }
    return self;
}

- (void)registerWithAccount:(NSString *)account password:(NSString *)password name:(NSString *)name success:(void (^)(void))success failure:(void (^)(NSError *))failure
{
    [HttpRequest POSTWithURL:[URL registerUser] parameters:@{@"email":account,@"name":name,@"password":[password MD5Hash]} success:^(id data) {

        if (success) {
            success();
        }
    } failure:failure];
}

- (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(Y2WCurrentUser *))success
                 failure:(void (^)(NSError *))failure {
    
    [HttpRequest POSTWithURL:[URL login] parameters:@{@"email":account,@"password":[password MD5Hash]} success:^(id data) {
        // 临时存储方式
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:CURRENT_USER_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.users.currentUser = nil;
        
        
        Y2WUser *user = [[Y2WUser alloc] initWithValue:data];
        [[Y2WUsers getInstance] addUser:user];
        
        Y2WCurrentUser *currentUser = [[Y2WUsers getInstance] getCurrentUser];
        
        // 启动一次同步
        [currentUser.userConversations.remote sync];
        [currentUser.contacts.remote sync];
        [currentUser.userSessions.remote sync];

        if (success) success(currentUser);

    } failure:failure];
}

- (void)searchUserWithKey:(NSString *)key success:(void (^)(NSArray *users))success failure:(void (^)(NSError *error))failure {
    
    [HttpRequest GETWithURL:[URL getUsers] parameters:@{@"filter_term":key} success:^(id data) {
        
        NSMutableArray *users = [NSMutableArray array];
        NSArray *entries = data[@"entries"];
        if (!entries.count) {
            if (success) success(users);
            return;
        }
        
        for (NSDictionary *dict in data[@"entries"]) {
            Y2WUser *user = [[Y2WUser alloc]initWithValue:dict];
            [users addObject:user];
        }

        if (success) success(users);

    } failure:^(id msg) {
        if (failure) failure([NSError errorWithDomain:@"Y2WUsersRemote" code:0 userInfo:@{NSLocalizedDescriptionKey:msg}]);
    }];
}

- (void)storeUser:(NSString *)userId success:(void (^)(id))success failure:(void (^)(id))failure
{
    [HttpRequest GETWithURL:[URL aboutUser:userId] parameters:nil success:^(id data) {
        NSLog(@"%@",data);
        Y2WUser *u = [[Y2WUser alloc]initWithValue:data];
     
        if (success) {
            success(u);
        }
    } failure:^(id msg) {
        if (failure) {
            failure(msg);
        }
    }];
}

@end
