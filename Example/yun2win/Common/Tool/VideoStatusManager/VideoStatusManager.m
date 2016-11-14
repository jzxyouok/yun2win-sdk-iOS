//
//  VideoStatusManager.m
//  yun2win
//
//  Created by duanhl on 16/9/26.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "VideoStatusManager.h"

@implementation VideoStatusManager

+ (NSDictionary *)sendChannelId:(NSString *)channelId sessionId:(NSString *)sessionid mediaType:(VideoDataType)mediaType videoActionType:(VideoActionType)actionType videoChatType:(NSString *)chatType formUid:(NSString *)formUid toUids:(NSArray<NSString *> *)uids
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];

    switch (actionType) {
        case VideoActionTypeCall:
        {
            dic[@"action"] = @"call";
            break;
        }
        case VideoActionTypeReject:
        {
            dic[@"action"] = @"reject";
            break;
        }
        case VideoActionTypeBusy:
        {
            dic[@"action"] = @"busy";
            break;
        }
        case VideoActionTypeCancel:
        {
            dic[@"action"] = @"cancel";
            break;
        }
        default:
            break;
    }

    dic[@"session"] = sessionid;
    dic[@"channel"] = channelId;
    dic[@"sender"] = formUid;
    
    if (actionType == VideoActionTypeCall) {
        dic[@"type"] = chatType;
        dic[@"mode"] = (mediaType == VideoDataTypeAudio) ? @"A" : @"AV";
        dic[@"members"] = uids;
    }
    
    return [dic copy];
}

//发送操作数据
+ (void)sendChannelId:(NSString *)channelId mediaType:(VideoDataType)mediaType videoActionType:(VideoActionType)actionType formUid:(NSString *)formUid toUids:(NSArray<NSString *> *)uids sessionId:(NSString *)sessionid
{
    Y2WUser *targetUser = [[Y2WUsers getInstance] getUserById:formUid];
     NSString *curUser = [Y2WUsers getInstance].getCurrentUser.ID;
    [targetUser getSession:^(NSError *error, Y2WSession *session) {
        NSDictionary *messageDic = [self sendChannelId:channelId sessionId:sessionid mediaType:mediaType videoActionType:actionType videoChatType:session.type formUid:curUser toUids:uids];
        
        IMSession *imSession = [[IMSession alloc] initWithSession:session];
        [session.sessions.user.bridge sendMessages:nil pushMessage:nil callMessage:messageDic toSession:imSession];
    }];
}

+ (void)sendMessageTargetUserId:(NSString *)uid mediaType:(VideoDataType)mediaType messageText:(NSString *)text
{
    if (!text || text.length <= 0) { return; }
    
    Y2WUser *targetUser = [[Y2WUsers getInstance] getUserById:uid];
   NSString *modeType = (mediaType == VideoDataTypeAudio) ? @"A" : @"AV";
    
    [targetUser getSession:^(NSError *error, Y2WSession *session) {
        Y2WAVMessage *message = [session.messages avMessageWithContent:@{@"text":text, @"mode":modeType, @"type":session.type}];
        [session.messages sendMessage:message];
    }];
}


@end
