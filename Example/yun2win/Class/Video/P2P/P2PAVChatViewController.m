//
//  P2PAVChatViewController.m
//  videoTest
//
//  Created by duanhl on 16/9/20.
//  Copyright © 2016年 duanhl. All rights reserved.
//  一对一通话

#import "P2PAVChatViewController.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "PromptBoxView.h"
#import "VideoStatusManager.h"
#import "PromptBoxView.h"
#import "VideoDisabledView.h"

@interface P2PAVChatViewController ()<AgoraRtcEngineDelegate>
@property (weak, nonatomic) IBOutlet UIView     *videoMainView;     //自己的图像
@property (weak, nonatomic) IBOutlet UIView     *videoSecondView;   //对方的图像
@property (weak, nonatomic) IBOutlet UIView     *DisabledView;      //存放音频的view
@property (weak, nonatomic) IBOutlet UILabel    *nickNameLabel;     //昵称
@property (weak, nonatomic) IBOutlet UILabel    *talkTimeLabel;     //通话时间

@property (weak, nonatomic) IBOutlet UIView     *callingView;       //通话中的view
@property (weak, nonatomic) IBOutlet UIView     *waitView;          //等待远程连接view
@property (weak, nonatomic) IBOutlet UIButton   *waitViewHangBut;   //等待页面的挂断按钮
@property (weak, nonatomic) IBOutlet UIButton   *switchCameraBut;
@property (weak, nonatomic) IBOutlet UILabel    *switchCameraLabel;


@property (strong, nonatomic) NSNumber            *uid;
@property (strong, nonatomic) AgoraRtcEngineKit   *agoraKit;          //声网
@property (strong, nonatomic) AgoraRtcVideoCanvas *videoCanvas;

@property (strong, nonatomic) NSTimer             *durationTimer;     //定时器
@property (nonatomic) NSUInteger                   duration;
@property (strong, nonatomic) VideoDisabledView   *videoDisabledView; //关闭本地视频显示出来的view

@end


@implementation P2PAVChatViewController

- (VideoDisabledView *)videoDisabledView
{
    if (_videoDisabledView == nil) {
        _videoDisabledView = [VideoDisabledView instanceVideoDisabledView];
    }
    return _videoDisabledView;
}

- (void)setChannelId:(NSString *)channelId {
    _channelId = channelId.copy;
    NSLog(@"%@",channelId);
}

- (void)dealloc {
    [self.durationTimer invalidate];
    self.durationTimer = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.videoDisabledView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CurAppDelegate.isOpenVideo = YES;
    CurAppDelegate.curVideoUserId = self.targetUserModel.ID;
    self.videoMainView.frame = self.videoMainView.superview.bounds; // video view's autolayout cause crash
    [self joinChannel];
    self.duration = 0;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    CurAppDelegate.isOpenVideo = NO;
    CurAppDelegate.curVideoUserId = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.mediaType == P2PAVChatMediaTypeVideo) {
        self.DisabledView.hidden = YES;
        self.switchCameraBut.hidden = NO;
        self.switchCameraLabel.hidden = NO;
        self.videoSecondView.hidden = NO;
    }else {
        self.DisabledView.hidden = NO;
        [self.DisabledView addSubview:self.videoDisabledView];
        self.switchCameraBut.hidden = YES;
        self.switchCameraLabel.hidden = YES;
        self.videoSecondView.hidden = YES;
    }
   
    if (self.actionType == P2PAVChatActionTypeCall) {
        self.callingView.hidden = YES;
        self.waitView.hidden = NO;
        
        [self performSelector:@selector(wait10s) withObject:nil afterDelay:10.0f];
        [self performSelector:@selector(wait30s) withObject:nil afterDelay:30.0f];
        
    }else {
        self.callingView.hidden = NO;
        self.waitView.hidden = YES;
    }
    
    self.nickNameLabel.text = self.targetUserModel.name;
    self.talkTimeLabel.text = @"00:00";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectNotAction:) name:KvideoRejectNot object:nil];
    [self initAgoraKit];
}

- (void)wait10s {
    PromptBoxView *promptBox = [[PromptBoxView alloc] init];
    promptBox.title = @"请确认邀请好友在线！！！";
    [promptBox show:^{

    }];
}

- (void)wait30s {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self hangupAction:self.waitViewHangBut];
}

- (void)rejectNotAction:(NSNotification *)not {
    NSDictionary *dic = (NSDictionary *)not.object;
    NSString *actionStr = [dic objectForKey:@"action"];
    NSLog(@"p2p挂断或忙%@",self);

    NSDictionary *promptDic = @{@"reject" : @"对方已拒绝", @"busy" : @"对方正在通话中", @"cancel" : @"对方取消通话"};
    PromptBoxView *promptBox = [[PromptBoxView alloc] init];
    promptBox.title = [promptDic objectForKey:actionStr];
    
    __weak typeof(self) weakSelf = self;
    [promptBox show:^{
        [weakSelf hangupAction:nil];
    }];
}

- (void)initAgoraKit
{
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:KagoraAppKey delegate:self];
    [self setUpLocalVideo];
}

- (void)joinChannel
{
    __weak typeof(self) weakSelf = self;
    [self.agoraKit joinChannelByKey:nil channelName:self.channelId info:nil uid:[Y2WUsers getInstance].getCurrentUser.ID.integerValue joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        
        [weakSelf.agoraKit setEnableSpeakerphone:YES];
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }];
}

- (void)setUpRemoteVideo {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = self.uid.unsignedIntegerValue;
    videoCanvas.view = self.videoMainView;
    videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupRemoteVideo:videoCanvas];
}

- (void)setUpLocalVideo
{
    (self.mediaType == P2PAVChatMediaTypeVideo) ? [self.agoraKit enableVideo] : [self.agoraKit disableVideo];
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.view = self.videoSecondView;
    videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
}

#pragma mark AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"local video display");
    __weak typeof(self) weakSelf = self;
    weakSelf.videoMainView.frame = weakSelf.videoMainView.superview.bounds; // video view's autolayout cause crash
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.uid = @(uid);
    
    [self setUpRemoteVideo];
    self.waitView.hidden = YES;
    self.callingView.hidden = NO;
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    NSLog(@"user %@ mute video: %@", @(uid), muted ? @"YES" : @"NO");
}

//有用户挂断，或掉线（15s）
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:( NSUInteger )uid reason:(AgoraRtcUserOfflineReason)reason
{
    [self hangupAction:nil];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportRtcStats:(AgoraRtcStats*)stats
{
    __weak typeof(self) weakSelf = self;

    if (weakSelf.duration == 0 && !weakSelf.durationTimer) {
        weakSelf.talkTimeLabel.text = @"00:00";
        weakSelf.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(updateTalkTimeLabel) userInfo:nil repeats:YES];
    }
}

//错误信息
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode
{
    switch (errorCode) {
        case AgoraRtc_Error_TimedOut:   //请求超时
        {
            
            break;
        }
        case AgoraRtc_Error_JoinChannelRejected:    //加入频道被拒绝
        {
            
            break;
        }
        case AgoraRtc_Error_LeaveChannelRejected:    //离开频道失败
        {
            
            break;
        }
        case AgoraRtc_Error_StartCamera:            //本地摄像头启动失败
        {
            
            break;
        }
        default:
            break;
    }
}

//- (void)rtcEngine:(AgoraRtcEngineKit *)engine didLeaveChannelWithStats:(AgoraRtcStats*)stats
//{
//
//}

- (void)updateTalkTimeLabel
{
    self.duration++;
    NSUInteger seconds = self.duration % 60;
    NSUInteger minutes = (self.duration - seconds) / 60;
    self.talkTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (unsigned long)minutes, (unsigned long)seconds];
}

#pragma mark 按钮点击事件
//切换摄像头
- (IBAction)switchCamera:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.agoraKit switchCamera];
}

//静音按钮
- (IBAction)muteAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.agoraKit muteLocalAudioStream:sender.selected];
}

//挂断按钮
- (IBAction)hangupAction:(UIButton *)sender {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.durationTimer invalidate];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    //1000(表示等待对方接听的挂断按钮)
    if (sender.tag == 1000) {
        [VideoStatusManager sendChannelId:self.channelId mediaType:VideoDataTypeVideo videoActionType:VideoActionTypeCancel formUid:self.targetUserModel.ID toUids:@[self.targetUserModel.ID] sessionId:self.sessionId videoChatType:@"p2p"];
    }
    
    if (sender) {
        NSString *mediaStr = (self.mediaType == P2PAVChatMediaTypeVideo) ? @"视频通话未接听" : @"语音通话未接听";
        NSString *str = (sender.tag == 1000) ? mediaStr : [NSString stringWithFormat:@"通话时长%@", self.talkTimeLabel.text];
        [VideoStatusManager sendMessageTargetUserId:self.targetUserModel.ID mediaType:VideoDataTypeVideo messageText:str];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        // Myself leave status
        sender.enabled = NO;
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

//扬声器按钮
- (IBAction)speakerAction:(UIButton *)sender {
    [self.agoraKit setEnableSpeakerphone:!self.agoraKit.isSpeakerphoneEnabled];
    sender.selected = !self.agoraKit.isSpeakerphoneEnabled;
}

@end
