//
//  CommunicationViewController.m
//  API
//
//  Created by ShingHo on 16/5/9.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "CommunicationViewController.h"
#import <Y2W_RTC_SDK/Y2WRTCVideoView.h>
#import <Y2W_RTC_SDK/Y2WRTCMember.h>
#import "ReceiveAndCloseView.h"
#import "SingleCommunicationView.h"

#import "MemberInfoView.h"
@interface CommunicationViewController ()
<Y2WRTCChannelDelegate,
ReceiveAndCloseViewDelegate,
SingleCommunicationViewDelegate>

@property (nonatomic, strong) Y2WRTCChannel *channel;

@property (nonatomic, retain) Y2WRTCVideoView *mainVideoView;

//接听挂断view
@property (nonatomic, strong) ReceiveAndCloseView *bottomView;

@property (nonatomic, assign) CommType commType;

//通话功能View
@property (nonatomic, strong) SingleCommunicationView *commView;

@property (nonatomic, strong) AVCallModel *model;

@property (nonatomic, strong) MemberInfoView *headerView;

@property (nonatomic, strong) Y2WRTCVideoView *smallVideoview;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;


@end

static BOOL isHidden = YES;
static BOOL isMe = NO;
@implementation CommunicationViewController

- (instancetype)initWithChannel:(Y2WRTCChannel *)channel CommType:(CommType)type
{
    if (self = [super init]) {
        self.channel = channel;
        self.commType = type;
    }
    return self;
}

- (instancetype)initWithAVCallModel:(AVCallModel *)model Channel:(Y2WRTCChannel *)channel
{
    if (self = [super init]) {
        self.channel = channel;
        self.model = model;
        if ([model.type isEqualToString:@"audio"])
            self.commType = commAudio;
        else
            self.commType = commVideo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MemberInfoView *infoView = [[MemberInfoView alloc]init];
    infoView.frame = self.view.bounds;
    infoView.videoMode = self.commType;
    Y2WContact *contact = [[Y2WUsers getInstance].getCurrentUser.contacts getContactWithUID:self.model.senderId];    
    infoView.avatarUrl = contact?contact.avatarUrl:[Y2WUsers getInstance].getCurrentUser.avatarUrl;
    infoView.name = contact?contact.name:[Y2WUsers getInstance].getCurrentUser.name;

    [self.view addSubview:infoView];
    
    [self.view addSubview:self.mainVideoView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.commView];
    
    [self.view addSubview:self.smallVideoview];
    
    self.channel.delegate = self;
    [self.channel join];
    [self.channel openAudio];
    [self.channel setSpeaker:YES];
    if (self.commType == commVideo) {
        [self.channel openVideo];
    }
    else
    {
        self.smallVideoview.hidden = YES;
    }
    [self refreshView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mainVideoView.frame = self.view.bounds;
}

#pragma mark - ReceiveAndCloseViewDelegate
- (void)onClickButton:(UIButton *)sender
{
    if (sender.tag == 101) {
        //挂断
        if (self.channel) [self.channel leave];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - SingleCommunicationViewDelegate
- (void)onTapButton:(UIButton *)sender
{
    if (sender.tag == 110) {
        //挂断
        if (self.channel) [self.channel leave];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (sender.tag == 111) {
        //静音
        [self.channel setMicMute:sender.selected];
    }
    if (sender.tag == 112) {
        //免提
        [self.channel setSpeaker:sender.selected];

    }
    if (sender.tag == 113) {
        //切换音视频
        if (!sender.selected) {
            [self.channel openVideo];
        }
        else
        {
            [self.channel closeVideo];
        }
    }
    if (!sender.selected)
        sender.selected = YES;
    else
        sender.selected = NO;
}

#pragma mark - Action
- (void)refreshView
{
    if (self.channel.getMembers.count == 1){
        self.mainVideoView.videoTrack = self.channel.getMembers.firstObject.videoTrack;
        self.bottomView.hidden = NO;
        self.commView.hidden = YES;
    }
    else if(self.channel.getMembers.count >= 1)
    {
        self.mainVideoView.videoTrack = self.channel.getMembers.lastObject.videoTrack;
        self.smallVideoview.videoTrack = self.channel.getMembers.firstObject.videoTrack;
        self.bottomView.hidden = YES;
        self.commView.hidden = NO;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)rec
{
    CGPoint point = [rec translationInView:self.view];
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)handleTapMainVideoView:(UITapGestureRecognizer *)rec
{
    self.commView.hidden = isHidden;
    
    if (isHidden)
        isHidden = NO;
    else
        isHidden = YES;
}

- (void)handleTapSmallVideoView:(UITapGestureRecognizer *)rec
{
    if (isMe) {
        isMe = NO;

        self.smallVideoview.videoTrack = self.channel.getMembers.firstObject.videoTrack;
        self.mainVideoView.videoTrack = self.channel.getMembers.lastObject.videoTrack;
    }
    else{
        isMe = YES;
        self.smallVideoview.videoTrack = self.channel.getMembers.lastObject.videoTrack;
        self.mainVideoView.videoTrack = self.channel.getMembers.firstObject.videoTrack;
    }
}

#pragma mark - ———— Y2WRTCChannelDelegate ———— -


- (void)channel:(Y2WRTCChannel *)channel didJoinMember:(Y2WRTCMember *)member {
    [self refreshView];
}

- (void)channel:(Y2WRTCChannel *)channel didLeaveMember:(Y2WRTCMember *)member {
    if (self.channel) [self.channel leave];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)channel:(Y2WRTCChannel *)channel didOpenAudioOfMember:(Y2WRTCMember *)member {
    
}

- (void)channel:(Y2WRTCChannel *)channel didCloseAudioOfMember:(Y2WRTCMember *)member {
    
}

- (void)channel:(Y2WRTCChannel *)channel didSwitchMuteAudioOfMember:(Y2WRTCMember *)member {
    
}

- (void)channel:(Y2WRTCChannel *)channel onAudioError:(NSError *)error {
    
}

- (void)channel:(Y2WRTCChannel *)channel didOpenVideoOfMember:(Y2WRTCMember *)member {
    [self refreshView];
    if (self.commType == commAudio) {
        [self.channel openVideo];
    }
    self.smallVideoview.hidden = NO;
    self.mainVideoView.hidden = NO;
    
    self.commView.videoChangedButton.selected = YES;
}

- (void)channel:(Y2WRTCChannel *)channel didCloseVideoOfMember:(Y2WRTCMember *)member {
    [self refreshView];
    [self.channel closeVideo];
    self.mainVideoView.hidden = YES;
    self.smallVideoview.hidden = YES;
    
    self.commView.videoChangedButton.selected = NO;
}

- (void)channel:(Y2WRTCChannel *)channel didSwitchVideoMuteOfMember:(Y2WRTCMember *)member {
    
}

- (void)channel:(Y2WRTCChannel *)channel onVideoError:(NSError *)error {
    
}


#pragma mark - Setter and Getter

- (ReceiveAndCloseView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[ReceiveAndCloseView alloc]initWithIsSender:YES];
        _bottomView.delegate = self;
        _bottomView.frame = CGRectMake(0, self.view.height - 100, self.view.width, 100);
    }
    return _bottomView;
}

- (SingleCommunicationView *)commView
{
    if (!_commView) {
        _commView = [[SingleCommunicationView alloc]initWithCommType:self.commType];
        _commView.frame = CGRectMake(0, self.view.height - 200, self.view.width, 200);
        _commView.delegate = self;
    }
    return _commView;
}

- (Y2WRTCVideoView *)mainVideoView {
    if (!_mainVideoView) {
        _mainVideoView = [[Y2WRTCVideoView alloc] init];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapMainVideoView:)];
        [_mainVideoView addGestureRecognizer:tapGestureRecognizer];
    }
    return _mainVideoView;
}

- (Y2WRTCVideoView *)smallVideoview
{
    if (!_smallVideoview) {
        _smallVideoview = [[Y2WRTCVideoView alloc]init];
        _smallVideoview.frame = CGRectMake(self.view.width - 110, 10, 100, 150);
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [_smallVideoview addGestureRecognizer:_panGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapSmallVideoView:)];
        [_smallVideoview addGestureRecognizer:tapGestureRecognizer];
    }
    return _smallVideoview;
}

//- (UITapGestureRecognizer *)tapGestureRecognizer
//{
//    if (!_tapGestureRecognizer) {
//        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
//    }
//    return _tapGestureRecognizer;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
