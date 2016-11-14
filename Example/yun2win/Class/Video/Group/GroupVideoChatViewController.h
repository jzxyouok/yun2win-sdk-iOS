//
//  GroupVideoChatViewController.h
//  videoTest
//
//  Created by duanhl on 16/9/20.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KagoraAppKey @"257f282434f344ce92da4d18a58f92c7"

typedef NS_ENUM(NSInteger, GroupVideoChatActionType) {
    GroupVideoChatActionTypeCall,            //呼叫
    GroupVideoChatActionTypeCalled,          //被叫
};

typedef NS_ENUM(NSInteger, GroupVideoChatMediaType) {
    GroupVideoChatMediaTypeAudio,            //音频
    GroupVideoChatMediaTypeVideo,            //视频
};

@interface GroupVideoChatViewController : UIViewController

@property (nonatomic, copy) NSString                    *channelId;         //通道id(房间号)
@property (nonatomic, copy) NSString                    *sessionId;         //会话id
@property (nonatomic, strong)NSArray                    *selectUserArray;   //选择的用户
@property (nonatomic, strong)NSString                   *sender;            //发起者
@property (nonatomic, assign)GroupVideoChatActionType    actionType;        //动作类型
@property (nonatomic, assign)GroupVideoChatMediaType     mediaType;         //媒体类型

@end
