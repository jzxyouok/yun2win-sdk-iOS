//
//  Y2WBridge.m
//  API
//
//  Created by ShingHo on 16/3/10.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WBridge.h"
#import "Y2WSession.h"
#import "ReceiveCommunicationManage.h"

@interface Y2WBridge ()<IMClientReceiveMessageDelegate>

@property (nonatomic, strong) dispatch_queue_t dispath_send_queue;

@property (nonatomic, strong) dispatch_queue_t dispath_receive_queue;

@property (nonatomic, strong) NSMutableArray *sendMessageList;

@property (nonatomic, strong) IMClient *imClient;

@property (nonatomic, strong) Y2WSession *tempSession;

@end

@implementation Y2WBridge

- (instancetype)initWithAppKey:(NSString *)appkey Token:(NSString *)token UserId:(NSString *)userId OnConnectionStatusChanged:(id<IMClientOnConnectionStatusChanged>)onConnectionStatusChanged OnMessage:(OnMessage *)message
{
    if ([super init]) {
        _appKey = appkey;
        _token = token;
        _userId = userId;
        _statusChanged = onConnectionStatusChanged;
        _message = message;

    }
    return self;
}

- (instancetype)init
{
    if ([super init]) {
        self.dispath_send_queue = dispatch_queue_create("dispath_send_queue", DISPATCH_QUEUE_SERIAL);
        self.dispath_receive_queue = dispatch_queue_create("dispath_receive_queue", DISPATCH_QUEUE_SERIAL);
        self.imClient = [IMClient shareY2WIMClient];
        self.imClient.receiptDelegate = self;
    }
    return self;
}


//- (void)connectBeforeCheck:(Y2WBridge *)opts
//{
//    //    self.uid = opts.userId;
//    //    self.token = opts.token;
//    if (!opts.appKey.length) {
//        [opts.statusChanged onConnectionStatusChangedWithConnectionStatus:disconnected connectionReturn:appKeyIsInvalid];
//        return;
//    }
//    if (!opts.token.length) {
//        [opts.statusChanged onConnectionStatusChangedWithConnectionStatus:disconnected connectionReturn:tokenIsInvalid];
//        return;
//    }
//    if (!opts.userId.length) {
//        [opts.statusChanged onConnectionStatusChangedWithConnectionStatus:disconnected connectionReturn:uidIsInvalid];
//        return;
//    }
//    [opts.statusChanged onConnectionStatusChangedWithConnectionStatus:connecting connectionReturn:0];
//    
//}

- (void)sendMessageWithSession:(Y2WSession *)session Content:(NSArray *)content
{
    self.tempSession = session;
    IMSession *imSession = [[IMSession alloc]initWithSession:session];
    NSDictionary *syncTypeDict = @{@"syncs":content};
    IMMessage *imMessage = [[IMMessage alloc]initWithMts:imSession.mts Message:syncTypeDict];
//    NSLog(@"send-----%@",imMessage.y2wMessageId);

    [self sendMessageInSession:imSession Message:imMessage];
    
}

- (void)updateSessionWithSession:(Y2WSession *)session
{
    IMSession *imSession = [[IMSession alloc]initWithSession:session];
    NSMutableArray *content = [NSMutableArray array];
    NSArray *temp_SessionMembers = [session.members getMembers];
    for (Y2WSessionMember *member in temp_SessionMembers) {
        NSDictionary *dic = @{@"uid":member.userId,
                              @"isDel":@(member.isDelete)};
        [content addObject:dic];
    }
    IMMessage *imMessage = [[IMMessage alloc]initWithMts:imSession.mts Message:content];
//    NSLog(@"update-----%@",imMessage.y2wMessageId);

    [self sendMessageInSession:imSession Message:imMessage];
}

#pragma mark ------私有方法------

- (void)sendMessageInSession:(IMSession *)session Message:(IMMessage *)message
{
//    if ([self checkWithIMSession:session IMMessage:message]) return;
    [self sendMessageListWithIMSession:session IMMessage:message];
}

- (BOOL)checkWithIMSession:(IMSession *)session IMMessage:(IMMessage *)message
{
    for (NSDictionary *dic in self.sendMessageList)
    {
        IMSession *temp_sess = dic[@"imSession"];
        
        if ([temp_sess.imSessionId isEqualToString:session.imSessionId])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkImSession:(IMSession *)session
{
    if (![session isKindOfClass:[IMSession class]]) {
        return NO;
    }
    if (!session.imSessionId.length) {
        
        return NO;
    }
    if (!session.mts) {
        
        return NO;
    }
    return YES;
}

- (void)sendMessageListWithIMSession:(IMSession *)session IMMessage:(IMMessage *)message
{
    [self.sendMessageList addObject:@{@"imSession":session,
                                      @"imMessage":message}];
        dispatch_async(self.dispath_send_queue, ^{
            
            if (!self.sendMessageList.count) return;
            IMSession *session = self.sendMessageList.firstObject[@"imSession"];
            IMMessage *message = self.sendMessageList.firstObject[@"imMessage"];
            if (![self checkImSession:session])
            {
                [self.statusChanged onConnectionStatusChangedWithConnectionStatus:disconnected connectionReturn:0];
            }
            
            if ([message.message isKindOfClass:[NSDictionary class]])
            {
                [self.imClient sendMessageWithSession:session Message:message];
            }
            else if ([message.message isKindOfClass:[NSArray class]])
            {
                [self.imClient updateSessionWithSession:session Message:message];
            }
            [self.sendMessageList removeObject:self.sendMessageList.firstObject];
        });
}

- (void)getReceiptMessage:(NSDictionary *)receiptMessage
{
    
    if (receiptMessage[@"returnCode"])
    {//发消息的回执
        [self getReturnCodeMessage:receiptMessage];

    }
    else
    {//收到消息
        [self getPushMessage:receiptMessage];
    }
}

/**
 *  获取RetuenCode
 *
 *  @param receiptMessage 回执消息
 */
- (void)getReturnCodeMessage:(NSDictionary *)receiptMessage
{
//    NSLog(@"receiptMessage -- %@",receiptMessage);
    switch ([receiptMessage[@"returnCode"] integerValue]) {
        case 20:
        {
            if (self.sendMessageList.count)
            {
                [self sendMessageInSession:self.sendMessageList.firstObject[@"imSession"] Message:self.sendMessageList.firstObject[@"imMessage"]];
            }
        }
            break;
        case 21:
        {
            
        }
            break;
        case 22:
        {
            
        }
            break;
        case 23:
        {
            
        }
            break;
        case 24:
        {
            
        }
            break;
        case 25:
        {
            
        }
            break;
        case 26:
        {
            
        }
            break;
        case 27:
        {
        
//            [[Y2WUsers getInstance].getCurrentUser.sessions getSessionWithTargetId:[self onGetSessionTargetId:self.tempSession] type:self.tempSession.type success:^(Y2WSession *session) {
//                NSLog(@"%@",session);
//            } failure:^(NSError *error) {
//                
//            }];
            [self.tempSession.members.remote sync];
        }
            break;
        case 28:
        {
            
        }
            break;
        case 29:
        {
            
        }
            break;
        default:
            break;
    }
}

/**
 *  获取推送消息
 *
 *  @param receiptMessage 推送消息
 */
- (void)getPushMessage:(NSDictionary *)receiptMessage
{
    NSArray *tempArr_syncs = receiptMessage[@"message"][@"syncs"];
    if ([tempArr_syncs isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *tempDic in tempArr_syncs)
        {
            if (tempDic[@"sessionId"])
            {
                NSString *tempString_sessionId = tempDic[@"sessionId"];
                NSArray *tempArr_sessionId = [tempString_sessionId componentsSeparatedByString:@"_"];
                NSDictionary *message_syncs = @{@"sender":receiptMessage[@"from"],
                                                @"sessionType":tempArr_sessionId.firstObject,
                                                @"sessionId":tempArr_sessionId.lastObject};
                [[NSNotificationCenter defaultCenter]postNotificationName:Y2WMessageDidChangeNotification object:message_syncs userInfo:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:Y2WUserConversationDidChangeNotification object:nil userInfo:nil];
            }
            if (tempDic[@"content"]) {
                [[ReceiveCommunicationManage showReceiveCommManage] receiveCommunicationMessage:tempDic];
            }
        }
    }
}

/**
 *  通过IMSessionId获得Y2WSession的type和sessionId
 *
 *  @param session IMSession对象
 *
 *  @return 返回含有type和sessionID的字典
 */
- (NSDictionary *)getSessionIdAndType:(IMSession *)session
{
    NSString *tempString_sessionId = session.imSessionId;
    NSArray *tempArr_sessionId = [tempString_sessionId componentsSeparatedByString:@"_"];
    NSDictionary *imSessionDic = @{@"sessionType":tempArr_sessionId.firstObject,
                                    @"sessionId":tempArr_sessionId.lastObject};
    return imSessionDic;
}

- (NSString *)onGetSessionTargetId:(Y2WSession *)session
{
    if ([session.type isEqualToString:@"group"]) {
        return session.sessionId;
    }
    else{
        return session.targetID;
    }
}

- (void)reachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}

#pragma mark - Set And Get
- (NSMutableArray *)sendMessageList
{
    if (!_sendMessageList) {
        _sendMessageList = [NSMutableArray array];
    }
    return _sendMessageList;
}

- (Y2WSession *)tempSession
{
    if (!_tempSession) {
        _tempSession = [[Y2WSession alloc]init];
    }
    return _tempSession;
}

@end

/**
 *  消息变更通知
 */
NSString *const Y2WMessageDidChangeNotification = @"Y2WMessageDidChangeNotification";

/**
 *  用户会话变更通知
 */
NSString *const Y2WUserConversationDidChangeNotification = @"Y2WUserConversationDidChangeNotification";

/**
 *  音视频消息
 */
NSString *const Y2WCommunicationMessageNotification = @"Y2WCommunicationMessageNotification";