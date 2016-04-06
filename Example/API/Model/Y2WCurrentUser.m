//
//  Y2WCurrentUser.m
//  API
//
//  Created by ShingHo on 16/3/3.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WCurrentUser.h"

@implementation Y2WCurrentUser

- (instancetype)initWithValue:(id)value
{
    self = [super initWithValue:value];
    if (self) {
        _appKey = value[@"key"];
        _secret = value[@"secret"];
        _imToken = @"";
        _token = value[@"token"];
        
        self.contacts = [[Y2WContacts alloc] initWithCurrentUser:self];
        self.userSessions = [[Y2WUserSessions alloc] initWithCurrentUser:self];
        self.sessions = [[Y2WSessions alloc] initWithCurrentUser:self];
        self.userConversations = [[Y2WUserConversations alloc] initWithCurrentUser:self];
        self.remote = [[Y2WCurrentUserRemote alloc] initWithCurrentUser:self];
        self.bridge = [[Y2WBridge alloc]init];
    }
    return self;
}

@end





@interface Y2WCurrentUserRemote ()

@property (nonatomic, weak) Y2WCurrentUser *currentUser;

@end


@implementation Y2WCurrentUserRemote

- (instancetype)initWithCurrentUser:(Y2WCurrentUser *)currentUser {
    if (self = [super init]) {
        self.currentUser = currentUser;
    }
    return self;
}

- (void)syncTokenDidCompletion:(void (^)(NSError *))block {
    
    [HttpRequest POSTWithURL:[URL login] parameters:@{@"email":self.currentUser.account,@"password":self.currentUser.passwordHash} success:^(id data) {
        
        self.currentUser.token = data[@"token"];

        if (block) block(nil);
        
    } failure:block];
}



- (void)syncIMTokenDidCompletion:(void (^)(NSError *))block
{
    [HttpRequest POSTNoHeaderWithURL:[URL getImToken] parameters:@{@"grant_type":@"client_credentials",@"client_id":self.currentUser.appKey,@"client_secret":self.currentUser.secret} success:^(id data) {
        self.currentUser.imToken = data[@"access_token"];
        
        [[IMClient shareY2WIMClient] registerWithToken:self.currentUser.imToken UID:self.currentUser.userId];
#warning IMClient要取消单态，一个CurrentUser一个IMClient, 多用户间才不会出错。
    } failure:block];
}

@end
