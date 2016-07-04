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

@interface Y2WBridge ()<IMClientReceiveMessageDelegate,IMClientReceiptMessageDelegate>

@property (nonatomic, strong) dispatch_queue_t dispath_send_queue;

@property (nonatomic, strong) dispatch_queue_t dispath_receive_queue;

@property (nonatomic, strong) NSMutableArray *sendMessageList;

@property (nonatomic, strong) IMClient *imClient;

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
        self.imClient.receiveMessageDelegate = self;
        self.imClient.receiptMessageDelegate = self;
        [self reachability];
    }
    return self;
}

- (void)sendMessageWithSession:(Y2WSession *)session Content:(NSArray *)content
{
    IMSession *imSession = [[IMSession alloc]initWithSession:session];
    NSDictionary *syncTypeDict = @{@"syncs":content};
    IMMessage *imMessage = [[IMMessage alloc]initWithMts:imSession.mts Message:syncTypeDict];
    ////    NSLog(@"send-----%@",imMessage.y2wMessageId);
    [self.imClient sendMessageWithSession:imSession Message:imMessage];
    
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
    
    [self.imClient updateSessionWithSession:imSession Message:imMessage];
}


#pragma mark - IMClientReceiveMessageDelegate

- (void)receiveMessage:(NSDictionary *)receiveMessage
{
    NSArray *tempArr_syncs = receiveMessage[@"message"][@"syncs"];
    if ([tempArr_syncs isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *tempDic in tempArr_syncs)
        {
            if (tempDic[@"sessionId"])
            {
                NSString *tempString_sessionId = tempDic[@"sessionId"];
                NSArray *tempArr_sessionId = [tempString_sessionId componentsSeparatedByString:@"_"];
                NSDictionary *message_syncs = @{@"sender":receiveMessage[@"from"],
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

#pragma mark - IMClientReceiptMessageDelegate

- (void)gotReceiptMessageWithSendReturnCode:(SendReturnCode)returnCode IMSession:(id<IMSessionProtocol>)session IMMessage:(id<IMMessageProtocol>)message
{
    switch (returnCode) {
        case success:
            
            break;
        case timeout_sendMessage:
        {
            NSLog(@"发送消息超时");
        }
            break;
        case cmdIsInvalid:
        {
            
        }
            break;
        case sessionIsInvalid:
        {
            
        }
            break;
        case sessionIdIsInvalid:
        {
            
        }
            break;
        case sessionMTSIsInvalid:
        {
            
        }
            break;
        case sessionOnServerIsNotExist:
        {
            
        }
            break;
        case sessionMTSOnClientHasExpired:
        {
            NSLog(@"客户端 MTS失效");
            
            [self.imClient updateSessionWithSession:session Message:message];
            [self.imClient sendMessageWithSession:session Message:message];
        }
            break;
        case sessionMTSOnServerHasExpired:
        {
            
        }
            break;
        case sessionMembersIsInvalid:
        {
            
        }
            break;
        case invalidFormatOfJSONContent:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - NetStatus
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