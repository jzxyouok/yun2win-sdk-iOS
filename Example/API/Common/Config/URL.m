//
//  URL.m
//  API
//
//  Created by ShingHo on 16/1/25.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "URL.h"

NSString const *userUrl = @"http://112.74.210.208:8080/v1/users/";
NSString const *baseURL = @"http://112.74.210.208:8080/v1/";

@implementation URL

+ (NSString *)getImToken
{
    return @"http://112.74.210.208/oauth/token";
}

+(NSString *)registerUser
{
    return [userUrl stringByAppendingString:@"register"];
}

+(NSString *)login
{
    return [userUrl stringByAppendingString:@"login"];
}

+(NSString *)aboutUser:(NSString *)userId
{
    return [userUrl stringByAppendingFormat:@"%@",userId];
}

+ (NSString *)acquireContacts
{
    return [userUrl stringByAppendingFormat:@"%@/contacts",[Y2WUsers getInstance].getCurrentUser.userId];
}

+ (NSString *)aboutContact:(NSString *)contactId
{
    return [userUrl stringByAppendingFormat:@"%@/contacts/%@",[Y2WUsers getInstance].getCurrentUser.userId,contactId];
}

+ (NSString *)userConversations
{
    return [userUrl stringByAppendingFormat:@"%@/userConversations",[Y2WUsers getInstance].getCurrentUser.userId];
}

+ (NSString *)singleUserConversation:(NSString *)userConversationId
{
    return [userUrl stringByAppendingFormat:@"%@/userConversations/%@",[Y2WUsers getInstance].getCurrentUser.userId,userConversationId];
}

+ (NSString *)sessions
{
    return [baseURL stringByAppendingString:@"sessions"];
}

+ (NSString *)p2pSessionWithUserA:(NSString *)userA andUserB:(NSString *)userB
{
    return [baseURL stringByAppendingFormat:@"sessions/p2p/%@/%@",userA,userB];
}

+ (NSString *)aboutSession:(NSString *)sessionId
{
    return [baseURL stringByAppendingFormat:@"sessions/%@",sessionId];
}

+ (NSString *)sessionMembers:(NSString *)sessionId
{
    return [baseURL stringByAppendingFormat:@"sessions/%@/members",sessionId];
}

+ (NSString *)singleSessionMember:(NSString *)memberId Session:(NSString *)sessionId
{
    return [baseURL stringByAppendingFormat:@"sessions/%@/members/%@",sessionId,memberId];
}

+ (NSString *)acquireMessages:(NSString *)sessionId
{
    return [baseURL stringByAppendingFormat:@"sessions/%@/messages",sessionId];
}

+ (NSString *)acquireHistoryMessage:(NSString *)sessionId
{
    return [baseURL stringByAppendingFormat:@"sessions/%@/messages/history",sessionId];
}

+(NSString *)aboutMessage:(NSString *)messageId Session:(NSString *)sessionId
{
    return [baseURL stringByAppendingFormat:@"sessions/%@/messages/%@",sessionId,messageId];
}

+ (NSString *)attachments
{
    return [baseURL stringByAppendingString:@"attachments"];
}

+ (NSString *)attachments:(NSString *)attachmentId
{
    return [baseURL stringByAppendingFormat:@"attachments/%@",attachmentId];
}

+ (NSString *)attachmentsOfContent:(NSString *)attachmentId
{
    return [baseURL stringByAppendingFormat:@"attachments/%@/content",attachmentId];
}



+ (NSString *)attachmentsWithContent:(NSString *)content {
    return [baseURL stringByAppendingFormat:@"%@?access_token=%@",content,[[Y2WUsers getInstance].getCurrentUser token]];
}


+ (NSString *)getUsers {
    return [baseURL stringByAppendingFormat:@"users"];
}

@end



@implementation NSString(URL)

- (NSString *)attachmentUrl {
    if([self.lowercaseString hasPrefix:@"http"]) return self;
    return [URL attachmentsWithContent:self];
}

@end
