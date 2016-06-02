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
