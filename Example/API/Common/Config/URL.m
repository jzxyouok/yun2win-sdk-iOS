//
//  URL.m
//  API
//
//  Created by ShingHo on 16/1/25.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "URL.h"
#import "Y2WServiceConfig.h"

@implementation URL

+ (NSString *)getImToken
{
    return @"http://112.74.210.208/oauth/token";
}

+ (NSString *)userUrl {
    return [Y2WServiceConfig.baseUrl stringByAppendingString:@"users/"];
}

+(NSString *)registerUser
{
    return [self.userUrl stringByAppendingString:@"register"];
}

+(NSString *)login
{
    return [self.userUrl stringByAppendingString:@"login"];
}

+(NSString *)aboutUser:(NSString *)userId
{
    return [self.userUrl stringByAppendingFormat:@"%@",userId];
}

+ (NSString *)acquireContacts
{
    return [self.userUrl stringByAppendingFormat:@"%@/contacts",[Y2WUsers getInstance].getCurrentUser.userId];
}

+ (NSString *)aboutContact:(NSString *)contactId
{
    return [self.userUrl stringByAppendingFormat:@"%@/contacts/%@",[Y2WUsers getInstance].getCurrentUser.userId,contactId];
}

+ (NSString *)userConversations
{
    return [self.userUrl stringByAppendingFormat:@"%@/userConversations",[Y2WUsers getInstance].getCurrentUser.userId];
}

+ (NSString *)singleUserConversation:(NSString *)userConversationId
{
    return [self.userUrl stringByAppendingFormat:@"%@/userConversations/%@",[Y2WUsers getInstance].getCurrentUser.userId,userConversationId];
}

+ (NSString *)sessions
{
    return [Y2WServiceConfig.baseUrl stringByAppendingString:@"sessions"];
}

+ (NSString *)p2pSessionWithUserA:(NSString *)userA andUserB:(NSString *)userB
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"sessions/p2p/%@/%@",userA,userB];
}

+ (NSString *)aboutSession:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"sessions/%@",sessionId];
}

+ (NSString *)sessionMembers:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"sessions/%@/members",sessionId];
}

+ (NSString *)singleSessionMember:(NSString *)memberId Session:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"sessions/%@/members/%@",sessionId,memberId];
}

+ (NSString *)acquireMessages:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"sessions/%@/messages",sessionId];
}

+ (NSString *)acquireHistoryMessage:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"sessions/%@/messages/history",sessionId];
}

+(NSString *)aboutMessage:(NSString *)messageId Session:(NSString *)sessionId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"sessions/%@/messages/%@",sessionId,messageId];
}

+ (NSString *)attachments
{
    return [Y2WServiceConfig.baseUrl stringByAppendingString:@"attachments"];
}

+ (NSString *)attachments:(NSString *)attachmentId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"attachments/%@",attachmentId];
}

+ (NSString *)attachmentsOfContent:(NSString *)attachmentId
{
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"attachments/%@/content",attachmentId];
}



+ (NSString *)attachmentsWithContent:(NSString *)content {
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"%@?access_token=%@",content,[[Y2WUsers getInstance].getCurrentUser token]];
}


+ (NSString *)getUsers {
    return [Y2WServiceConfig.baseUrl stringByAppendingFormat:@"users"];
}

@end



@implementation NSString(URL)

- (NSString *)attachmentUrl {
    if([self.lowercaseString hasPrefix:@"http"]) return self;
    return [URL attachmentsWithContent:self];
}

@end
