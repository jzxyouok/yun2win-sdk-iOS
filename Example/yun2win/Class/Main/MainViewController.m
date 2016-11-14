//
//  MainViewController.m
//  API
//
//  Created by ShingHo on 16/1/18.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MainViewController.h"
#import "Y2WNavigationController.h"
#import "ConversationListViewController.h"
#import "ContactsViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "VideoAnsweringView.h"
#import "P2PAVChatViewController.h"
#import "GroupVideoChatViewController.h"
#import "VideoStatusManager.h"
#import "PromptBoxView.h"
#import "Y2WUserConversations.h"

@interface MainViewController ()<Y2WIMBridgeDelegate, VideoAnsweringDelegate, Y2WUserConversationsDelegate>

@property (nonatomic, strong) VideoAnsweringView    *videoAnsweringView;        //音视频接听页面

@property (nonatomic, retain) Y2WUserConversations  *userConversations;

@property (nonatomic, weak) GroupVideoChatViewController    *groupVideoVc;      //群组视频
@property (nonatomic, weak) P2PAVChatViewController         *p2pChatVC;         //单聊视频
@property (nonatomic, strong) NSString                      *lastChannelId;     //上一次的channelId;
@property (nonatomic, strong) NSString                      *lastSessionId;     //上一次的sessionId;

@property (nonatomic, retain) UIView *statusView;

@end

#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"
#define TabbarItemBadgeValue @"badgeValue"  //未读数

@implementation MainViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setUpSubNav];
    }
    return self;
}

- (Y2WUserConversations *)userConversations {
    if (!_userConversations) {
        _userConversations = [Y2WUsers getInstance].getCurrentUser.userConversations;
    }
    return _userConversations;
}

- (VideoAnsweringView *)videoAnsweringView
{
    if (_videoAnsweringView == nil) {
        _videoAnsweringView = [VideoAnsweringView instanceVideoAnsweringView];
        _videoAnsweringView.frame = [UIScreen mainScreen].bounds;
        _videoAnsweringView.delegate = self;
    }

    return _videoAnsweringView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[Y2WUsers getInstance].getCurrentUser.bridge addDelegate:self];
    [self.userConversations addDelegate:self];
    self.lastChannelId = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotAction:) name:kPushVideoNot object:nil];
}


- (void)setUpSubNav{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [self.tabbars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * item = obj;
        NSString * vcName = item[TabbarVC];
        NSString * title  = item[TabbarTitle];
        NSString * imageName = item[TabbarImage];
        NSString * imageSelected = item[TabbarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController * vc = [[clazz alloc] init];
        vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage y2w_imageNamed:@"导航栏_logo"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:nil
                                                                              action:nil];
        vc.hidesBottomBarWhenPushed = NO;
        Y2WNavigationController *nav = [[Y2WNavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[UIImage y2w_imageNamed:imageName]
                                               selectedImage:[UIImage y2w_imageNamed:imageSelected]];
        nav.tabBarItem.tag = idx;
        NSInteger badge = [item[TabbarItemBadgeValue] integerValue];
        NSString *badgeStr = (badge > 99) ? @"99+" : [NSString stringWithFormat:@"%zd",badge];
        nav.tabBarItem.badgeValue = (badge > 0) ? badgeStr : nil;

        [array addObject:nav];
    }];
    self.viewControllers = array;
}

- (NSArray*)tabbars{

    NSMutableArray *items = [NSMutableArray array];
    [items addObject:@{TabbarVC             : @"ConversationListViewController",
                       TabbarTitle          : @"交流",
                       TabbarImage          : @"交流-默认",
                       TabbarSelectedImage  : @"交流-选中",
                       TabbarItemBadgeValue : @(0)}];
    
//    if (![[Y2WUsers getInstance].getCurrentUser.role isEqualToString:@"customer"]) {
//        [items addObject:@{TabbarVC             : @"WorkViewController",
//                           TabbarTitle          : @"工作",
//                           TabbarImage          : @"工作-默认",
//                           TabbarSelectedImage  : @"工作-选中",
//                           TabbarItemBadgeValue : @(0)}];
//    }
    
    [items addObject:@{TabbarVC             : @"ContactsViewController",
                       TabbarTitle          : @"通讯录",
                       TabbarImage          : @"通讯录-默认",
                       TabbarSelectedImage  : @"通讯录-选中",
                       TabbarItemBadgeValue : @(0)}];

    
    [items addObject:@{TabbarVC             : @"SettingViewController",
                       TabbarTitle          : @"设置",
                       TabbarImage          : @"设置-默认",
                       TabbarSelectedImage  : @"设置-选中",
                       TabbarItemBadgeValue : @(0)}];
    return items;
}

#pragma mark - ———— Y2WUserConversationsDelegate ———— -
- (void)userConversationsDidChangeContent:(Y2WUserConversations *)userConversations {
    NSArray *converArray = [userConversations getUserConversations];
    NSInteger num = 0;
    
    for (Y2WUserConversation *tempConver in converArray) {
        num += tempConver.unRead;
    }
    
    for (Y2WNavigationController *tempNav in self.viewControllers) {
        if ([tempNav.tabBarItem.title isEqualToString:@"交流"]) {
            NSString *badgeStr = (num > 99) ? @"99+" : [NSString stringWithFormat:@"%zd",num];
            tempNav.tabBarItem.badgeValue = (num > 0) ? badgeStr : nil;
        }
        
        break;
    }
}


#pragma mark - Y2WIMBridgeDelegate

- (void)bridge:(Y2WIMBridge *)bridge didLogoutWithMessage:(NSString *)message {
    [[LoginManager sharedManager] logout];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [UIView transitionWithView:keyWindow duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];

    } completion:^(BOOL finished) {
        if (finished && message) {
            [UIAlertView showTitle:@"警告" message:message];
        }
    }];
}

//在线状态发生改变
- (void)bridge:(Y2WIMBridge *)bridge didChangeOnlineStatus:(BOOL)isOnline {
    if (self.statusView.hidden == isOnline) {
        return;
    }
    self.statusView.hidden = isOnline;
    [UIView animateWithDuration:0.1 animations:^{
        CGRect frame = [UIScreen mainScreen].bounds;
        CGFloat viewHeight = self.statusView.height * !self.statusView.isHidden;
        frame.origin.y = viewHeight;
        frame.size.height = [UIScreen mainScreen].bounds.size.height - viewHeight;
        self.view.frame = frame;
        
        CGRect statusViewFrame = self.statusView.frame;
        statusViewFrame.origin.y = -1 * self.statusView.height * isOnline;
        self.statusView.frame = statusViewFrame;
        
    } completion:^(BOOL finished) {
        NSInteger index = self.selectedIndex;
        self.selectedIndex = [self getRandomIndex];
        self.selectedIndex = index;
    }];
}

- (NSInteger)getRandomIndex {
    NSInteger index = arc4random_uniform((uint32_t)self.viewControllers.count);
    if (index == self.selectedIndex) {
        return [self getRandomIndex];
    }
    return index;
}

//接收信令
- (void)bridge:(Y2WIMBridge *)bridge didReceiveMessage:(NSDictionary *)message {
    if (!message[@"av"]) {
        return;
    }
    
    [self messageProcessing:message[@"av"]];
}

//推送过来的消息
- (void)pushNotAction:(NSNotification *)not{
    NSDictionary *dic = (NSDictionary *)not.object;
    
    [self messageProcessing:dic[@"av"]];    
}

//消息状态的处理
- (void)messageProcessing:(NSDictionary *)avDic{
    NSDictionary *promptDic = @{@"reject" : @"对方已挂断", @"busy" : @"对方正在通话中", @"cancel" : @"对方取消通话"};
    NSString *actionStr = [avDic objectForKey:@"action"];
    NSString *channelId = [avDic objectForKey:@"channel"];
    NSString *type = [avDic objectForKey:@"type"];
    
    if ([actionStr isEqualToString:@"call"]) {
        if (CurAppDelegate.isOpenVideo) {   //表示当前已在视频或者正在呼叫别人，所以这里发送忙的信令
            if (![self.lastChannelId isEqualToString:channelId]) {
                [self videoSendStauteAction:avDic videoActionType:VideoActionTypeBusy];
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIWindow *kwindow = [UIApplication sharedApplication].keyWindow;
                [kwindow endEditing:YES];
                
                self.videoAnsweringView.infoDic = avDic;
                CurAppDelegate.isOpenVideo = YES;
                self.lastChannelId = [avDic objectForKey:@"channel"];
                self.lastSessionId = [avDic objectForKey:@"session"];
                [self.videoAnsweringView playMusic];
                [kwindow addSubview:self.videoAnsweringView];
            });
        }
    }else if ([actionStr isEqualToString:@"reject"] || [actionStr isEqualToString:@"busy"]) {
        
        NSDictionary *dic = avDic;
        [[NSNotificationCenter defaultCenter] postNotificationName:KvideoRejectNot object:dic];
        
    }else if ([actionStr isEqualToString:@"cancel"]) {
            PromptBoxView *promptBox = [[PromptBoxView alloc] init];
            promptBox.title = [promptDic objectForKey:actionStr];
            __weak typeof(self) weakSelf = self;
            [promptBox show:^{
                [weakSelf.videoAnsweringView removeFromSuperview];
                CurAppDelegate.isOpenVideo = NO;
                CurAppDelegate.curVideoUserId = nil;
                [weakSelf.videoAnsweringView stopMusic];
            }];
    }
}

//发送状态
- (void)videoSendStauteAction:(NSDictionary *)infoDic videoActionType:(VideoActionType)actionType
{
    if (!infoDic) { return; }

    NSString *channelStr = (actionType == VideoActionTypeBusy) ? self.lastChannelId : [infoDic objectForKey:@"channel"];
    NSString *senderStr = [infoDic objectForKey:@"sender"];
    NSArray  *tempArray = [infoDic objectForKey:@"members"];
    NSString *dataTypeStr = [infoDic objectForKey:@"mode"];
    NSString *session = (actionType == VideoActionTypeBusy) ? self.lastSessionId : [infoDic objectForKey:@"session"];
    
    VideoDataType dataType = ([dataTypeStr isEqualToString:@"A"]) ? VideoDataTypeAudio : VideoDataTypeVideo;
    NSString *curUser = [Y2WUsers getInstance].getCurrentUser.ID;
    
    NSMutableArray *membersArray = [NSMutableArray arrayWithCapacity:tempArray.count + 1];
    [membersArray addObject:senderStr];
    [membersArray addObjectsFromArray:tempArray];
    
    for (NSString *uid in membersArray) {
        if ([curUser isEqualToString:uid]) {
            continue;
        }
        
        [VideoStatusManager sendChannelId:channelStr mediaType:dataType videoActionType:actionType formUid:uid toUids:membersArray sessionId:session];
    }
}

#pragma mark VideoAnsweringDelegate
//点击挂断按钮
- (void)VideoAnsweringView:(VideoAnsweringView *)videoAnsweringView clickRejectionBut:(UIButton *)rejectonBut
{
    [self videoSendStauteAction:videoAnsweringView.infoDic videoActionType:VideoActionTypeReject];
    
    [self.videoAnsweringView removeFromSuperview];
    CurAppDelegate.isOpenVideo = NO;
    CurAppDelegate.curVideoUserId = nil;
}

//点击接听按钮
- (void)VideoAnsweringView:(VideoAnsweringView *)videoAnsweringView clickAnswerBut:(UIButton *)answerBut
{
    NSString *typeStr = [videoAnsweringView.infoDic objectForKey:@"type"];
    NSString *channelStr = [videoAnsweringView.infoDic objectForKey:@"channel"];
    NSString *session = [videoAnsweringView.infoDic objectForKey:@"session"];
    NSString *dataTypeStr = [videoAnsweringView.infoDic objectForKey:@"mode"];
    
    if ([typeStr isEqualToString:@"p2p"]) { //单聊
        NSString *targetUser = [videoAnsweringView.infoDic objectForKey:@"sender"];
        Y2WUser *targetUserModel = [[Y2WUsers getInstance] getUserById:targetUser];
        P2PAVChatViewController *p2pVc = [[P2PAVChatViewController alloc] init];
        p2pVc.actionType = P2PAVChatActionTypeCalled;
        p2pVc.targetUserModel = targetUserModel;
        p2pVc.channelId = channelStr;
        p2pVc.sessionId = session;
        p2pVc.mediaType = ([dataTypeStr isEqualToString:@"AV"]) ? P2PAVChatMediaTypeVideo : P2PAVChatMediaTypeAudio;
        self.p2pChatVC = p2pVc;
        [self presentViewController:p2pVc animated:YES completion:^{
            [self.videoAnsweringView removeFromSuperview];
        }];
    
    }else if ([typeStr isEqualToString:@"group"]) { //群聊
        GroupVideoChatViewController *groupVc = [[GroupVideoChatViewController alloc] init];
        groupVc.channelId = channelStr;
        groupVc.sessionId = session;
        groupVc.actionType = GroupVideoChatActionTypeCalled;
        groupVc.mediaType = ([dataTypeStr isEqualToString:@"AV"]) ? GroupVideoChatMediaTypeVideo : GroupVideoChatMediaTypeAudio;
        self.groupVideoVc = groupVc;
        UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:groupVc];
        [self presentViewController:navVc animated:YES completion:^{
            [self.videoAnsweringView removeFromSuperview];
        }];
    }
}

- (UIView *)statusView {
    if (!_statusView) {
        CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height + 20;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, - height, self.view.frame.size.width, height)];
        view.backgroundColor = [UIColor y2w_redColor];
        view.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, view.frame.size.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"网络连接断开,请检查网络";
        label.font = [UIFont systemFontOfSize:11];
        [view addSubview:label];
        
        _statusView = view;
    }
    return _statusView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.userConversations removeDelegate:self];
}


- (void)openAV:(NSArray *)memberIds channel:(NSString *)channelId session:(NSString *)sessionId isVideo:(BOOL)isVideo success:(void (^)(BOOL isSuccess))callback {
    [[Y2WUsers getInstance].remote getUserByIds:memberIds success:^(NSArray<Y2WUser *> *users) {
        dispatch_async(dispatch_get_main_queue(), ^{
            GroupVideoChatViewController *chatVC = [[GroupVideoChatViewController alloc] init];
            chatVC.channelId = channelId;
            chatVC.sessionId = sessionId;
            chatVC.actionType = GroupVideoChatActionTypeCall;
            chatVC.selectUserArray = users;
            chatVC.mediaType = isVideo ? GroupVideoChatMediaTypeVideo : GroupVideoChatMediaTypeAudio;
            self.groupVideoVc = chatVC;
            self.lastChannelId = channelId;
            self.lastSessionId = sessionId;
            UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:chatVC];
            [self presentViewController:navVc animated:YES completion:nil];
        });
        
        if (callback) {
            callback(YES);
        }
        
    } failure:^(NSError *error) {
        [UIAlertView showTitle:nil message:error.message];
        if (callback) {
            callback(NO);
        }
    }];
}

- (void)openAVp2p:(Y2WUser *)targetUserModel channel:(NSString *)channelId session:(NSString *)sessionId isVideo:(BOOL)isVideo success:(void (^)(BOOL isSuccess))callback
{
    P2PAVChatViewController *chatVC = [[P2PAVChatViewController alloc] init];
    chatVC.channelId = channelId;
    chatVC.sessionId = sessionId;
    chatVC.actionType = P2PAVChatActionTypeCall;
    chatVC.targetUserModel = targetUserModel;
    chatVC.mediaType = isVideo ? P2PAVChatMediaTypeVideo : P2PAVChatMediaTypeAudio;
    self.p2pChatVC = chatVC;
    self.lastChannelId = channelId;
    self.lastSessionId = sessionId;
    [self presentViewController:chatVC animated:YES completion:nil];
    
    if (callback) {
        callback(YES);
    }
}

@end
