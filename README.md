[![LOGO](http://8225117.s21i-8.faiusr.com/4/ABUIABAEGAAg5o3ztwUoivKDrgQwuAE4Mg.png)](http://www.yun2win.com)
# yun2win-sdk-iOS V_1.0.0
 
Yun2win为企业和开发者提供最安全的即时通讯(IM)云服务和基于Web RTC下的融合通讯云服务，通过yun2win的SDK及API，快速拥有即时通讯(instant messaging)、实时音视频（Audio and video Communication）、屏幕共享（Screen sharing）、电子白板（whiteboard）通讯能力。

### 编译环境
编译环境：Xcode-Version 7.2.1 (7C1002)

-
### 目录结构

```
┌── yun2win
│   ├── yun2win
│   │   ├── Common :通用组件
│   │   │   ├── Category :扩展方法
│   │   │   ├── Config   :全局配置
│   │   │   ├── DB       :Realm数据库模型对象
│   │   │   ├── Tool     :封装的工具
│   │   │   └── Util     :常用工具
│   │   ├── Classes :Demo界面
│   │   │   ├── Main             :登陆后的根视图控制器
│   │   │   ├── Login            :登陆注册
│   │   │   ├── ConversationList :会话列表
│   │   │   ├── Conversation     :会话
│   │   │   ├── Contact          :联系人
│   │   │   ├── Search           :搜索
│   │   │   ├── Profile          :个人主页
│   │   │   ├── Video            :音视频通话
│   │   │   └── Setting          :设置
│   │   ├── Model    :yun2win所有业务模型
│   │   │   └── IMBridge         :Y2W_IM_SDK管理
│   │   └── Resource :资源和配置文件
│   ├── Frameworks
│   ├── Products
│   └── Pods
└── Pods 依赖管理工具
```
-
### SDK使用说明
#### 添加项目文件
直接把SDK拷贝到项目中，选择项目TARGETS，点击"Build Phases"选项，点击"+"号添加"Copy Files"，点击"Copy Files"中"+"号选项添加SDK。

#### 使用即时通讯SDK
* 导入头文件。 
```objective-c
#import <Y2W_IM_SDK/Y2W_IM_SDK.h>
```
* 初始化Y2W_IM_SDK对象实例 
```objective-c
- (instancetype)initWithDelegate:(id<Y2WIMClientDelegate>)delegate;
```

* 创建连接配置对象
```objective-c
- (instancetype)initWithAppkey:(NSString *)appkey uid:(NSString *)uid token:(NSString *)token;
```

* 传入配置对象,开始连接
```objective-c
- (void)connectWithConfig:(Y2WIMClientConfig *)config ;
```

* 如需使用APNs,在AppDelegate的- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken调用
```objective-c
+ (void)setDeviceToken:(NSData *)deviceToken;
```

* 如果开启了APNs,需要在退出登录时调用
```objective-c
- (void)closePush;
```


* 发送消息

```objective-c
- (void)sendMessage:(NSDictionary *)message toSession:(id<Y2WIMSession>)session;
```

* 更新会话

```objective-c
- (void)sendUpdateMessage:(NSDictionary *)message toSession:(id<Y2WIMSession>)session;
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
