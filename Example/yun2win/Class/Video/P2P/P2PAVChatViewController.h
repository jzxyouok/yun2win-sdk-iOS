//
//  P2PAVChatViewController.h
//  videoTest
//
//  Created by duanhl on 16/9/20.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, P2PAVChatActionType) {
    P2PAVChatActionTypeCall,            //呼叫
    P2PAVChatActionTypeCalled,          //被叫
};

typedef NS_ENUM(NSInteger, P2PAVChatMediaType) {
    P2PAVChatMediaTypeAudio,            //音频
    P2PAVChatMediaTypeVideo,            //视频
};

@interface P2PAVChatViewController : UIViewController

@property (nonatomic, copy) NSString                *channelId;         //通道id(房间号)
@property (nonatomic, copy) NSString                *sessionId;         //会话id
@property (nonatomic, strong)Y2WUser                *targetUserModel;   //对方用户model
@property (nonatomic, assign)P2PAVChatActionType    actionType;         //动作类型
@property (nonatomic, assign)P2PAVChatMediaType     mediaType;          //媒体类型

@end
