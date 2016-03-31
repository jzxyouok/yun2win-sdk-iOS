//
//  Y2WMessages.m
//  API
//
//  Created by ShingHo on 16/3/2.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WMessages.h"
#import "Y2WSession.h"
#import "MulticastDelegate.h"
#import <objc/runtime.h>

@interface Y2WMessages ()

@property (nonatomic, retain) MulticastDelegate<Y2WMessagesDelegate> *delegates; //多路委托对象

@property (nonatomic, retain) NSMutableSet *messageList;

@end



@implementation Y2WMessages

#pragma mark - ———— queue ———— -
/**
 *  创建一个串行队列（此队列只做读写操作）
 *
 *  @return 队列实例
 */
static dispatch_queue_t message_readwrite_queue() {
    static dispatch_queue_t message_readwrite_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        message_readwrite_queue = dispatch_queue_create("message_readwrite_queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return message_readwrite_queue;
}

/**
 *  创建一个串行队列（此队列只做代理回调操作）
 *
 *  @return 队列实例
 */
static dispatch_queue_t message_callback_queue() {
    static dispatch_queue_t message_callback_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        message_callback_queue = dispatch_queue_create("message_callback_queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return message_callback_queue;
}




#pragma mark - ———— 初始化 ———— -

- (instancetype)initWithSession:(Y2WSession *)session {
    
    if (self = [super init]) {
        self.session = session;
        self.remote = [[Y2WMessagesRemote alloc] initWithMessages:self];
        MulticastDelegate *delegates = [[MulticastDelegate alloc] init];
        self.delegates = (MulticastDelegate<Y2WMessagesDelegate> *)delegates;
    }
    return self;
}




#pragma mark - ———— Y2WMessagesRemote调用此方法 ———— -

- (void)messagesRemote:(Y2WMessagesRemote *)remote syncMessages:(NSArray *)messages didCompleteWithError:(NSError *)error {
    __weak typeof(self)weakSelf = self;

    for (Y2WMessage *message in messages) {
        
        [self getMessageWithMessage:message didCompletionBlock:^(Y2WMessage *gMessage, NSError *error) {
            if (gMessage) {
                [weakSelf updateMessage:message didCompletionBlock:^(Y2WMessage *uMessage, NSError *error) {
                    [weakSelf onUpdateMessage:message];
                }];
                
            }else {

                [weakSelf addMessage:message didCompletionBlock:^(NSError *error) {
                    [weakSelf onReceiveMessage:message];
                }];
            }
        }];
    }
}





#pragma mark - ———— Y2WMessageDelegateInterface ———— -

- (void)addDelegate:(id<Y2WMessagesDelegate>)delegate {
 
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<Y2WMessagesDelegate>)delegate {

    [self.delegates removeDelegate:delegate];
}

- (void)loadMessageWithPage:(Y2WMessagesPage *)page {
    BOOL needSync = NO;
    if (!page) {
        page = [[Y2WMessagesPage alloc] init];
        needSync = YES;
    }
    
    [self getBeforeMessagesFromMessage:[page.messageList firstObject] limit:10 didCompletionBlock:^(NSArray<Y2WMessage *> *messages, NSError *error) {
        
        page.messageList = messages;
        
        if (page.messageList.count) {
            [self loadMessagesFromPage:page didCompleteWithError:nil];
            
        }else {
            NSError *error = [NSError errorWithDomain:@"Y2WMessages"
                                                 code:0
                                             userInfo:@{NSLocalizedDescriptionKey:@"没有消息了"}];
            [self loadMessagesFromPage:nil didCompleteWithError:error];
        }
    }];
    
    
    if (needSync) {
        [self.remote sync];
    }
}

- (void)sendMessage:(Y2WMessage *)message {
    __weak typeof(self)weakSelf = self;
    [self addMessage:message didCompletionBlock:^(NSError *error) {
        if (error) {
            [weakSelf sendMessage:message didCompleteWithError:error];
        }else {
            [weakSelf willSendMessage:message];
        }
        
        [weakSelf.remote storeMessages:message success:^(Y2WMessage *message) {
            
            [weakSelf.remote sync];
            
        } failure:^(NSError *error) {
            message.status = @"storefailed";
            [weakSelf sendMessage:message didCompleteWithError:error];
        }];
    }];
}

- (void)resendMessage:(Y2WMessage *)message {
    [self sendMessage:message];
}






#pragma mark - ———— 所有回调操作（防止顺序不对，统一在一个串行队列执行） ———— -

- (void)loadMessagesFromPage:(Y2WMessagesPage *)page didCompleteWithError:(NSError *)error {
    
    dispatch_barrier_async(message_callback_queue(), ^{
        if ([self.delegates respondsToSelector:@selector(messages:loadMessagesFromPage:didCompleteWithError:)]) {
            [self.delegates messages:self loadMessagesFromPage:page didCompleteWithError:error];
        }
    });
}

- (void)onReceiveMessage:(Y2WMessage *)message {
    
    dispatch_barrier_async(message_callback_queue(), ^{
        if ([self.delegates respondsToSelector:@selector(messages:onRecvMessage:)]) {
            [self.delegates messages:self onRecvMessage:message];
        }
    });
}

- (void)willSendMessage:(Y2WMessage *)message {
    
    dispatch_barrier_async(message_callback_queue(), ^{
        if ([self.delegates respondsToSelector:@selector(messages:willSendMessage:)]) {
            [self.delegates messages:self willSendMessage:message];
        }
    });
}

- (void)sendMessage:(Y2WMessage *)message progress:(CGFloat)progress {
    
    dispatch_barrier_async(message_callback_queue(), ^{
        if ([self.delegates respondsToSelector:@selector(messages:sendMessage:progress:)]) {
            [self.delegates messages:self sendMessage:message progress:progress];
        }
    });
}

- (void)sendMessage:(Y2WMessage *)message didCompleteWithError:(NSError *)error {
    
    dispatch_barrier_async(message_callback_queue(), ^{
        if ([self.delegates respondsToSelector:@selector(messages:sendMessage:didCompleteWithError:)]) {
            [self.delegates messages:self sendMessage:message didCompleteWithError:error];
        }
    });
}

- (void)onUpdateMessage:(Y2WMessage *)message {
    
    dispatch_barrier_async(message_callback_queue(), ^{
        if ([self.delegates respondsToSelector:@selector(messages:onUpdateMessage:)]) {
            [self.delegates messages:self onUpdateMessage:message];
        }
    });
}









#pragma mark - ———— 数据相关 ———— -

- (NSUInteger)count {
    
    return self.messageList.count;
}

- (void)addMessage:(Y2WMessage *)message didCompletionBlock:(void (^)(NSError *error))block {

    dispatch_barrier_async(message_readwrite_queue(), ^{
        if (!self.messageList) self.messageList = [NSMutableSet set];
        [self.messageList addObject:message];
        
        if (block) block(nil);
    });
}

- (void)deleteMessage:(Y2WMessage *)message didCompletionBlock:(void (^)(Y2WMessage *dMessage, NSError *error))block {
    dispatch_barrier_async(message_readwrite_queue(), ^{
        [self getMessageWithMessage:message didCompletionBlock:^(Y2WMessage *gMessage, NSError *error) {
            if (error && block) {
                block(gMessage, error);
                return;
            }
            if (gMessage) {
                [self.messageList removeObject:gMessage];
            }
            if (block) block(gMessage, nil);
        }];
    });
}

- (void)updateMessage:(Y2WMessage *)message didCompletionBlock:(void (^)(Y2WMessage *uMessage, NSError *error))block {
    dispatch_barrier_async(message_readwrite_queue(), ^{
        [self getMessageWithMessage:message didCompletionBlock:^(Y2WMessage *gMessage, NSError *error) {
            if (error && block) {
                block(gMessage, error);
                return;
            }
            if (gMessage) {
                [gMessage updateWithMessage:message];
            }
            if (block) block(gMessage, nil);
        }];
    });
}

- (void)getMessageWithMessage:(Y2WMessage *)message didCompletionBlock:(void (^)(Y2WMessage *gMessage, NSError *error))block {
  
    dispatch_barrier_async(message_readwrite_queue(), ^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageId LIKE[CD] %@",message.messageId];
        NSSet *messages = [self.messageList filteredSetUsingPredicate:predicate];
        if (block) block(messages.anyObject,nil);
    });
}

/**
 *  获取一条消息之前的消息
 *
 *  @param message 如果是空则取最新的消息，否则只取此消息之前的消息
 *  @param limit   需要获取的最大数量
 *
 *  @return 以创建时间升序排序的数组
 */
- (void)getBeforeMessagesFromMessage:(Y2WMessage *)message limit:(NSUInteger)limit didCompletionBlock:(void (^)(NSArray<Y2WMessage *> *messages, NSError *error))block {
    
    dispatch_barrier_async(message_readwrite_queue(), ^{

        NSSet *messages = [self.messageList copy];
        if (message) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createdAt < %@",message.createdAt];
            messages = [self.messageList filteredSetUsingPredicate:predicate];
        }
        if (block) block([messages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]],nil);
    });
}

/**
 *  获取一条消息之后的消息
 *
 *  @param message 如果是空则取最新的消息，否则只取此消息之后的消息
 *  @param limit   需要获取的最大数量
 *
 *  @return 以创建时间升序排序的数组
 */
- (NSArray *)getAfterMessagesFromMessage:(Y2WMessage *)message limit:(NSUInteger)limit {

    NSSet *messages = [self.messageList copy];
    if (message) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"createdAt > %@",message.createdAt];
        messages = [self.messageList filteredSetUsingPredicate:predicate];
    }
    
    return [messages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
}

/**
 *  获取本地最新一条消息（没有发送成功不算）
 *
 *  @param block 结果回调
 */
- (void)getLastMessageDidCompletionBlock:(void (^)(Y2WMessage *message, NSError *error))block {
    dispatch_barrier_async(message_readwrite_queue(), ^{
        if (!self.messageList.count) {
            if (block) block(nil, nil);
            return;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status LIKE[CD] %@",@"stored"];
        NSSet *messagesSet = [self.messageList filteredSetUsingPredicate:predicate];
        NSArray *messages = [messagesSet sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
        if (block) block(messages.lastObject, nil);
    });
}





#pragma mark - ———— 消息构造 ———— -

- (Y2WMessage *)createMessage:(id)data {
    
    Y2WMessage *message = [[Y2WMessage alloc]init];
    message.sessionId = self.session.sessionId;
    message.sender = self.session.sessions.user.userId;
    message.type = @"text";
    message.status = @"storing";
    message.content = @{@"text": data};
    return message;
}

- (Y2WMessage *)messageWithText:(NSString *)text {
    
    Y2WMessage *message = [[Y2WMessage alloc]init];
    message.sessionId = self.session.sessionId;
    message.sender = self.session.sessions.user.userId;
    message.type = @"text";
    message.status = @"storing";
    message.content = @{@"text": text};
    message.messageId = [NSUUID UUID].UUIDString;
    return message;
}

- (Y2WMessage *)messageWithImage:(UIImage *)image
{
    return nil;
}


@end








@interface Y2WMessagesRemote ()

@property (nonatomic, weak) Y2WMessages *messages;

@property (nonatomic, copy) NSString *timeStamp;

@property (nonatomic, assign) BOOL syncMaximum;     // 每次同步任务的最大次数

@property (nonatomic, assign) BOOL synchronizing;   // 是否正在同步中

@property (nonatomic, assign) BOOL anotherTask;     // 是否有新任务

@end



@implementation Y2WMessagesRemote
@synthesize timeStamp = _timeStamp;

- (instancetype)initWithMessages:(Y2WMessages *)messages {
    
    if (self = [super init]) {
        self.messages = messages;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncNotification:) name:Y2WMessageDidChangeNotification object:nil];
    }
    return self;
}

- (void)syncNotification:(NSNotification *)noti {
    NSDictionary *dict = noti.object;

    if (![[dict[@"sessionId"] uppercaseString] isEqualToString:self.messages.session.sessionId.uppercaseString]) return;
    if (![dict[@"sessionType"] isEqualToString:self.messages.session.type]) return;
    
    [self sync];
}


- (void)getLastMessageDidCompletionBlock:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    if (!self.messages.session.sessionId) {
        if (failure) failure([NSError errorWithDomain:@"sessionId为空" code:0 userInfo:nil]);
        return;
    }
    
    [HttpRequest GETWithURL:[URL acquireMessages:self.messages.session.sessionId] parameters:@{@"limit":@"20"} success:^(id data) {
        NSMutableArray *messages = [NSMutableArray array];
        for (NSDictionary *dic in data[@"entries"]) {
            Y2WMessage *message = [[Y2WMessage alloc] initWithValue:dic];
            [messages addObject:message];
        }
        if (success) success(messages);
        
    } failure:^(id msg) {
        if (failure) failure([NSError errorWithDomain:msg code:0 userInfo:nil]);
    }];
}



- (void)sync {
    // 如果没有添加messages的代理则不做操作
    if (!self.messages.delegates.count) return;
    
    // 如果消息管理对象没有实现回调则不操作
    if (![self.messages respondsToSelector:@selector(messagesRemote:syncMessages:didCompleteWithError:)]) return;

    // 如果已经有新任务则不继续操作
    if (self.anotherTask) return;
    
    // 如果正在同步中则添加新任务后返回不再继续操作
    if (self.synchronizing) {
        self.anotherTask = YES;
        return;
    }
    
    // 开始同步
    self.synchronizing = YES;
    
    // 从时间戳开始获取一次消息
    [HttpRequest GETWithURL:[URL acquireMessages:self.messages.session.sessionId]
                  timeStamp:self.timeStamp
                 parameters:@{@"limit":@"10"}
                    success:^(NSDictionary *data) {

                        NSMutableArray *messages = [NSMutableArray array];
                        NSArray *entries = data[@"entries"];
                        NSUInteger count = [data[@"total_count"] integerValue] - entries.count;
                        
                        for (NSDictionary *dic in entries) {
                            Y2WMessage *message = [[Y2WMessage alloc]initWithValue:dic];
                            message.status = @"stored";
                            [messages addObject:message];
                        }
                        
                        [messages sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]]];
                        if (messages.count) {
                            self.timeStamp = [messages.lastObject createdAt];
                            [self.messages messagesRemote:self syncMessages:messages didCompleteWithError:nil];
                        }
                        
                        
                        BOOL continueSync = count || self.anotherTask;
                        
                        self.synchronizing = NO;
                        self.anotherTask = NO;

                        // 如果需要就再同步一次消息
                        if (continueSync) [self sync];
                        
                        // 如果同步结束就同步一次用户会话
                        if (!count) [self.messages.session.sessions.user.userConversations.remote sync];
                        
                        // todo members时间戳不同就同步一次
                        if (self.messages.session) {
                            [self.messages.session.updatedAt isEqualToString:data[@"sessionUpdatedAt"]];
//                            [self.messages.session]
                        }
                        
                    } failure:^(id msg) {
                        
                        self.synchronizing = NO;
                        [self.messages messagesRemote:self syncMessages:nil didCompleteWithError:nil];
                    }];
}



- (void)storeMessages:(Y2WMessage *)message success:(void (^)(Y2WMessage *message))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *parameters = @{@"type":message.type,@"content":[message.content toJsonString],@"sender":message.sender};
    
    [HttpRequest POSTWithURL:[URL acquireMessages:message.sessionId] parameters:parameters success:^(id data) {
        [message updateWithDict:data];
        NSString *temp_sessionId = [NSString stringWithFormat:@"%@_%@",self.messages.session.type,self.messages.session.sessionId];
        [[Y2WUsers getInstance].getCurrentUser.bridge updateSessionWithSession:self.messages.session];
        [[Y2WUsers getInstance].getCurrentUser.bridge sendMessageWithSession:self.messages.session Content:@[@{@"type":@0},@{@"type":@1,@"sessionId":temp_sessionId}]];

        if (success) success(message);
        
    } failure:^(id msg) {
        if (failure) failure([NSError errorWithDomain:msg code:0 userInfo:nil]);
    }];
}






#pragma mark - ———— setter ———— -

- (void)setTimeStamp:(NSString *)timeStamp {
    _timeStamp = timeStamp;
    [[NSUserDefaults standardUserDefaults] setObject:timeStamp forKey:[self timeStampKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - ———— getter ———— -

- (NSString *)timeStamp {
    if (!_timeStamp) {
//        _timeStamp = [[NSUserDefaults standardUserDefaults] objectForKey:[self timeStampKey]];
        _timeStamp = _timeStamp ?: @"1990-01-01T00:00:00";
    }
    return _timeStamp;
}

- (NSString *)timeStampKey {
    return [@"messagesTimeStampKey" stringByAppendingFormat:@"%@%@",self.messages.session.sessions.user.userId,self.messages.session.sessionId];
}


@end