[![LOGO](http://8225117.s21i-8.faiusr.com/4/ABUIABAEGAAg5o3ztwUoivKDrgQwuAE4Mg.png)](http://www.yun2win.com)
# yun2win-sdk-iOS V_0.0.1

### 编译环境
编译环境：Xcode-Version 7.2.1 (7C1002)

-
### 目录结构

```
┌── API
│   ├── Common
│   │   ├── Config :全局配置
│   │   ├── Util :常用工具
│   │   ├── Category :扩展方法
│   ├── Yun2Win :SDK
│   ├── Model :SDK相关实体和方法
│   ├── APITests :单元测试
│   ├── Classes :Demo界面
│   │   ├── Login :登陆
│   │   ├── Setting :设置
│   │   ├── ConversationList :会话列表
│   │   ├── Conversation :会话
│   │   └── Contact :控制器，对应app中的各个页面
│   ├── Frameworks
│   │   ├── Y2W_RTC_SDK.framework :yun2win音视频SDK
│   │   └── Y2W_IM_SDK.framework :yun2win即时通讯SDK
└── Pods 依赖管理工具
```
-
### SDK使用说明
#### 添加项目文件
直接把SDK拷贝到项目中，选择项目TARGETS，点击"Build Phases"选项，点击"+"号添加"Copy Files"，点击"Copy Files"中"+"号选项添加SDK。

#### 引用头文件
在需要使用Y2W_IM_SDK的代码中引用头文件。 
```objective-c
#import <Y2W_IM_SDK/Y2W_IM_SDK.h>
```
在需要使用Y2W_RTC_SDK的代码中引用头文件。
```objective-c
#import <Y2W_RTC_SDK/Y2WRTCChannel.h>
#import <Y2W_RTC_SDK/Y2WRTCVideoView.h>
#import <Y2W_RTC_SDK/Y2WRTCMember.h>
```

#### 使用Y2W_IM_SDK
* 初始化Y2W_IM_SDK对象实例 

```objective-c
+ (instancetype)shareY2WIMClient;
```

* 设置获取到的Token、UID和Appkey

```objective-c
- (void)registerWithToken:(NSString *)token UID:(NSString *)uid Appkey:(NSString *)appkey;
```

* 与yun2win推送服务器建立连接

```objective-c
/**
 *  与yun2win服务器建立连接
 */
- (void)connect;

/**
 *  与yun2win服务器重新建立连接
 */
- (void)reconnect; 
```

* 推送消息

```objective-c
/**
 *  推送消息
 *
 *  @param session 会话
 *  @param message 推送消息体
 */
- (void)sendMessageWithSession:(id<IMSessionProtocol>)session Message:(id<IMMessageProtocol>)message;
```

* 推送更新会话消息

```objective-c
/**
 *  推送更新会话消息
 *
 *  @param session 对象IMSession
 *  @param message 对象IMMessage
 */
- (void)updateSessionWithSession:(id<IMSessionProtocol>)session Message:(id<IMMessageProtocol>)message;
```

#### 使用Y2W_RTC_SDK音视频SDK
##### 使用流程
 1.发起方使用Y2WRTCManager对象的createChannel方法获取到Y2WRTCChannel对象<br>
 2.接收方使用Y2WRTCManager对象的getChannel方法获取Y2WRTCChannel对象<br>
 3.给Y2WRTCChannel添加委托对象，并实现Y2WRTCChannelDelegate协议方法<br>
 4.然后调用join方法加入频道<br>
 5.调用leave方法离开频道<br>

#####Y2WRTCManager发起、加入音视频频道
* 属性
```objective-c
@property (nonatomic, copy) NSString *channelId;    // 频道ID，发起方会自动获取，加入时需要填入发起方获取的ID
@property (nonatomic, copy) NSString *memberId;     // 频道连接中的成员ID
@property (nonatomic, copy) NSString *token;        // 用户token
```

```objective-c
方法

/**
 *  发起音视频
 */
Y2WRTCManager *manager = [[Y2WRTCManager alloc] init];
manager.memberId = uid;
manager.token = token;
[manager createChannel:^(NSError *error, Y2WRTCChannel *channel) {

    if (error) {
        // 发起失败，返回错误
        return;
    }

    // 把channel.channelId转发给需要接听的用户
    // 使用channel对象管理连接
}];

/**
 *  发起音视频
 *  @discuss 加入方法必须填入需要加入的channelId 
 */                        
Y2WRTCManager *manager = [[Y2WRTCManager alloc] init];
manager.channelId = channelId;
manager.memberId = uid;
manager.token = token;
[manager getChannel:^(NSError *error, Y2WRTCChannel *channel) {

    if (error) {
        // 加入失败，返回错误
        return;
    }

    // 使用channel对象管理连接
}];
```

* Y2WRTCChannel管理频道

属性
```objective-c
@property (nonatomic, copy) NSString *channelId;                           // 频道ID
@property (nonatomic, retain, readonly) NSArray<Y2WRTCMember *> *members;  // 此频道当前的所有成员
@property (nonatomic, assign) id<Y2WRTCChannelDelegate> delegate;          // 委托对象
```
 方法
```objective-c
-------------------------------- 音频功能 --------------------------------
/**
 *  开启音频连接
 */
- (void)openAudio;

/**
 *  关闭音频功能（关闭后无法发送和接受音频）
 */
- (void)closeAudio;


/**
 *  是否开启扬声器
 *
 *  @param speaker bool
 */
- (void)setSpeaker:(BOOL)speaker;

/**
 *  当前是否使用的扬声器
 *
 *  @return bool
 */
- (BOOL)speakerEnabled;


/**
 *  是否设置麦克风静音
 *
 *  @param mute bool
 */
- (void)setMicMute:(BOOL)mute;

/**
 *  麦克风是否静音状态
 *
 *  @return bool
 */
- (BOOL)micMuteEnabled;

-------------------------------- 视频功能 --------------------------------
/**
 *  开启视频功能
 */
- (void)openVideo;

/**
 *  关闭视频功能（关闭后无法发送和接受视频）
 */
- (void)closeVideo;


/**
 *  切换前后摄像头
 *
 *  @param use YES为使用后置摄像头
 */
- (void)useBackCamera:(BOOL)use;

/**
 *  当前是否使用的后置摄像头
 *
 *  @return YES为后置摄像头，NO为前置摄像头
 */
- (BOOL)isUseBackCamera;


/**
 *  关闭自己的摄像头画面
 *
 *  @param mute bool
 */
- (void)setVideoMute:(BOOL)mute;

/**
 *  自己的摄像头是否关闭状态
 *
 *  @return bool
 */
- (BOOL)videoMuteEnabled;

```

* Y2WRTCMember成员对象,管理成员的状态并提供视频数据

属性
```objective-c
@property (nonatomic, copy) NSString *uid;          // 用户ID
@property (nonatomic, retain) RTCVideoTrack *track; // 视频数据流
@property (nonatomic, assign) BOOL audioOpened;     // 是否开启了音频连接
@property (nonatomic, assign) BOOL audioMuted;      // 是否开启了静音（关闭麦克风）
@property (nonatomic, assign) BOOL videoOpened;     // 是否开启了视频连接
@property (nonatomic, assign) BOOL videoMuted;      // 是否关闭了摄像头
```

* Y2WRTCChannelDelegate用于频道内事件的回调

方法
```objective-c
/**
 *  有成员加入此频道
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didJoinMember:(Y2WRTCMember *)member;

/**
 *  有成员离开此频道
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didLeaveMember:(Y2WRTCMember *)member;



/**
 *  有成员开启了音频
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didOpenAudioOfMember:(Y2WRTCMember *)member;

/**
 *  有成员关闭了音频
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didCloseAudioOfMember:(Y2WRTCMember *)member;

/**
 *  有成员关闭或开启了麦克风
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didSwitchMuteAudioOfMember:(Y2WRTCMember *)member;

/**
 *  音频连接出现错误
 *
 *  @param channel 频道对象
 *  @param error   错误对象
 */
- (void)channel:(Y2WRTCChannel *)channel onAudioError:(NSError *)error;



/**
 *  有成员开启了视频
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didOpenVideoOfMember:(Y2WRTCMember *)member;

/**
 *  有成员关闭了视频
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didCloseVideoOfMember:(Y2WRTCMember *)member;

/**
 *  有成员关闭或开启了摄像头
 *
 *  @param channel 频道对象
 *  @param member  成员对象
 */
- (void)channel:(Y2WRTCChannel *)channel didChangeVideoMuteFromMember:(Y2WRTCMember *)member;

/**
 *  视频连接出现错误
 *
 *  @param channel 频道对象
 *  @param error   错误对象
 */
- (void)channel:(Y2WRTCChannel *)channel onVideoError:(NSError *)error;
```

-
### 链接
官方网站 : http://www.yun2win.com<br>
安卓 : https://github.com/yun2win/yun2win-sdk-android<br>
iOS : https://github.com/yun2win/yun2win-sdk-iOS<br>
Web : https://github.com/yun2win/yun2win-sdk-web<br>
Server : https://github.com/yun2win/yun2win-sdk-server<br>

-
### License
liyueyun-SDK-iOS is available under the MIT license. See the [LICENSE](https://github.com/yun2win/yun2win-sdk-iOS/blob/master/LICENSE) file for more info.
