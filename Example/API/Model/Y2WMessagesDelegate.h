//
//  Y2WMessagesDelegate.h
//  API
//
//  Created by QS on 16/3/30.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Y2WMessages,Y2WMessage,Y2WMessagesPage;
@protocol Y2WMessagesDelegate <NSObject>

@optional
/**
 *  加载消息
 *
 *  @param messages 消息管理对象
 *  @param page     页数管理器
 *  @param error    错误返回,如果收取成功,error为nil
 */
- (void)messages:(Y2WMessages *)messages
loadMessagesFromPage:(Y2WMessagesPage *)page
didCompleteWithError:(NSError *)error;



/**
 *  收到消息回调
 *
 *  @param messages 消息管理对象
 *  @param message  收到的消息
 */
- (void)messages:(Y2WMessages *)messages
   onRecvMessage:(Y2WMessage *)message;



/**
 *  更新消息的回调
 *
 *  @param messages 消息管理对象
 *  @param message  更新的消息
 */
- (void)messages:(Y2WMessages *)messages
 onUpdateMessage:(Y2WMessage *)message;



/**
 *  即将发送消息
 *
 *  @param messages 消息管理对象
 *  @param message  发送的消息
 */
- (void)messages:(Y2WMessages *)messages
 willSendMessage:(Y2WMessage *)message;



/**
 *  发送消息进度回调
 *
 *  @param messages 消息管理对象
 *  @param message  当前发送的消息
 *  @param progress 进度
 */
- (void)messages:(Y2WMessages *)messages
     sendMessage:(Y2WMessage *)message
        progress:(CGFloat)progress;



/**
 *  发送消息完成回调
 *
 *  @param messages 消息管理对象
 *  @param message  当前发送的消息
 *  @param error    失败原因,如果发送成功则error为nil
 */
- (void)messages:(Y2WMessages *)messages
     sendMessage:(Y2WMessage *)message
didCompleteWithError:(NSError *)error;



/**
 *  收取消息附件回调
 *  @discussion 附件包括:图片,视频的缩略图,语音文件
 *  @param message  当前收取的消息
 *  @param progress 进度
 */
- (void)fetchMessageAttachment:(Y2WMessage *)message
                      progress:(CGFloat)progress;



/**
 *  收取消息附件完成回调
 *
 *  @param message 当前收取的消息
 *  @param error   错误返回,如果收取成功,error为nil
 */
- (void)fetchMessageAttachment:(Y2WMessage *)message
          didCompleteWithError:(NSError *)error;


@end
