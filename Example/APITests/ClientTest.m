//
//  ClientTest.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "Y2WUser.h"
#import "Y2WUsers.h"
#import "Y2WCurrentUser.h"
#import "Y2WContact.h"
#import "Y2WContacts.h"
#import "Y2WUserConversation.h"
#import "Y2WUserConversations.h"
#import "Y2WSession.h"
#import "Y2WSessions.h"
#import "Y2WMessages.h"


SPEC_BEGIN(SimpleStringSpec)

describe(@"XML", ^{
    
//    context(@"check single chat", ^{
//        __block id registerCallback;
//        __block id registerError;
//        
//        [[NSUserDefaults standardUserDefaults] setValue:[NSUUID UUID].UUIDString forKey:@"account"];
//        [[NSUserDefaults standardUserDefaults] setValue:[NSUUID UUID].UUIDString forKey:@"password"];
//        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
//        NSString *psd = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
//        [Y2WUsersRemote registerUserWithAccount:account password:psd name:@"" success:^(id data) {
//            registerCallback = data;
//        } failure:^(id msg) {
//            registerError = msg;
//        }];
//        it(@" register callback", ^{
//            [[expectFutureValue(theValue(registerCallback)) shouldEventually]beNonNil];
//            //            [[expectFutureValue(theValue(registerError)) shouldEventually]beNil];
//        });
//        
//        //User1登录后 返回currentUser
//        __block id loginError;
//        __block Y2WCurrentUser *user1;
//        __block Y2WCurrentUser *user2;
//        __block Y2WContact *contact1;
//        __block Y2WContact *contact2;
//        __block Y2WSession *session1;
//        __block Y2WSession *session2;
//        __block NSArray *arrA;
//        __block NSArray *arrB;
//        
//        __block Y2WMessage *messageT;
//        __block Y2WMessage *messageV;
//        
//        Y2WUsers *usersA = [[Y2WUsers alloc]init];
//        Y2WUsers *usersB = [[Y2WUsers alloc]init];
//        
//        [usersA.remote loginWithAccount:account password:psd success:^(id data) {
//            user1 = data;
//            
//            //user2登录
//            [usersB.remote loginWithAccount:@"z" password:@"z" success:^(id data) {
//                user2 = data;
//                
//                //user1添加contact1
//                [user1.contacts.remote addContactWithUserId:user2.userId Name:user2.name success:^(id data) {
//                    contact1 = data;
//#warning 添加contact后sync
//                    //create a new session
//                    [user1.sessions getSessionWithTargetId:user2.userId type:@"p2p" success:^(id data) {
//                        session1 = data;
//                        
//                        Y2WMessage *mess = [Y2WMessage mock];
//                        //user1 send a message
//                        Y2WMessage *message1 = [session1.messages createMessage:mess];
//                        [session1.messages.remote storeMessages:message1 success:^(id data) {
//                            
//                        } failure:^(NSString *msg) {
//                            
//                        }];
//                        
//                        //the session1 of user1 sync the list of messages;
//                        [session1.messages.remote syncMessages:session1.sessionId success:^(id data) {
//                            arrA = data;
//                            
//                        } failure:^(NSString *msg) {
//                            
//                        }];
//                        
//                        //userB(currentUser2) sync userConversations
//                        [user2.userConversations.remote syncUserConversationsForsuccess:^(id data) {
//                            Y2WUserConversation *userConversationB = [user2.userConversations getUserConversation:user1.userId];
//                            //curr2 get the session which contain user1 and user2
//                            
//                            contact2 = [user2.contacts getContact:user1.userId];
//                            //                            session2 = [contact2 getSession];
//                            
//                            [user2.sessions getSessionWithTargetId:userConversationB.targetId type:@"p2p" success:^(id data) {
//                                Y2WSession *session2 = data;
//                                [session2.messages.remote syncMessages:session2.sessionId success:^(id data) {
//                                    arrB = data;
//                                    
//                                    id mess2;
//                                    Y2WMessage *message2 = [session2.messages createMessage:mess2];
//                                    [session2.messages.remote storeMessages:message2 success:^(id data) {
//                                        messageT = data;
//                                        
//                                    } failure:^(NSString *msg) {
//                                        
//                                    }];
//                                    
//                                    [session1.messages.remote syncMessages:session1.sessionId success:^(id data) {
//                                        NSArray *arrC = data;
//                                        messageV = [[Y2WMessage alloc]initWithValue:[arrC[arrC.count-1] dicToMessage]];
//                                    } failure:^(NSString *msg) {
//                                        
//                                    }];
//                                    
//                                } failure:^(NSString *msg) {
//                                    
//                                }];
//                                
//                            } failure:^(NSString *msg) {
//                                
//                            }];
//                            
//                        } failure:^(NSString *msg) {
//                            
//                        }];
//                        
//                    } failure:^(NSString *msg) {
//                        
//                    }];
//                } failure:^(NSString *msg) {
//                    
//                }];
//            } failure:^(id msg) {
//                
//            }];
//            
//        } failure:^(id msg) {
//            loginError = msg;
//        }];
//        
//        it(@"check login callback", ^{
//            [[expectFutureValue(theValue(user1.userId)) shouldEventually]beNonNil];
//        });
//        
//        
//        //添加联系人ContactA，即用户UserB
//        it(@"check the Contact1", ^{
//            [[expectFutureValue(theValue(contact1.userId)) shouldEventually]equal:theValue(user2.userId)];
//        });
//        
//        //与ContactA建立Session
//        it(@"check the session1", ^{
//            [[expectFutureValue(theValue(session1.sessionId)) shouldEventually]equal:theValue(session2.sessionId)];
//        });
//        
//        
//        //向Session发送MessageA
//        
//        it(@"check the sync of session1", ^{
//            [[expectFutureValue(theValue(arrA)) shouldEventually]beNonNil];
//        });
//        it(@"check the sync of session1", ^{
//            [[expectFutureValue(theValue(arrB)) shouldEventually]beNonNil];
//        });
//        
//        //UserB登录，收到MessageA，并向Session发送MessageB
//        //UserA接收到MessageB
//        it(@"check the same message", ^{
//            [[expectFutureValue(theValue(messageT.messageId))shouldEventually]equal:theValue(messageV.messageId)];
//        });
//  
//    });
    
    
    context(@"check group chat", ^{
        
//        [[IMClient shareY2WIMClient] connect];
//        [[IMClient shareY2WIMClient]]
        
    });
    
});

SPEC_END