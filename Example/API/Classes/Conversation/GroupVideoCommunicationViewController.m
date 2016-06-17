//
//  GroupVideoCommunicationViewController.m
//  API
//
//  Created by ShingHo on 16/5/11.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "GroupVideoCommunicationViewController.h"
#import "GroupVideoCommunicationCollectionViewCell.h"
#import "GroupVideoCommunicationMemberViewCellModel.h"
#import "GroupVideoChatSideBar.h"
#import <Y2W_RTC_SDK/Y2WRTCVideoView.h>
#import <Y2W_RTC_SDK/Y2WRTCMember.h>
#import "SessionMemberModel.h"

#define PROPORTION 3/4

@interface GroupVideoCommunicationViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
Y2WRTCChannelDelegate,
GroupVideoChatSideBarDelegate>

@property (nonatomic, strong) UIButton *menuButton;

@property (nonatomic, strong) GroupVideoChatSideBar *sideBar;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *members;

@property (nonatomic, strong) NSArray *models;

@property (nonatomic, retain) Y2WRTCChannel *channel;

@property (nonatomic, strong) Y2WSession *session;

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, retain) Y2WRTCVideoView *mainVideoView;

@property (nonatomic, strong) AVCallModel *avcallModel;

@property (nonatomic, assign) CommType commType;

@end

@implementation GroupVideoCommunicationViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

<<<<<<< HEAD
- (instancetype)initWithChannel:(Y2WRTCChannel *)channel SessionId:(NSString *)sessionId
{
    if (self = [super init]) {
        self.channel = channel;
        self.sessionId = sessionId;
    }
    return self;
}

=======
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
- (instancetype)initWithChannel:(Y2WRTCChannel *)channel SessionId:(NSString *)sessionId commType:(CommType)commtype
{
    if (self = [super init]) {
        self.channel = channel;
        self.sessionId = sessionId;
        self.commType = commtype;
    }
    return self;
}

- (instancetype)initWithAVCallModel:(AVCallModel *)model withChannel:(Y2WRTCChannel *)channel
{
    if (self = [super init]) {
        self.avcallModel = model;
        self.channel = channel;
        self.sessionId = model.sessionId;
        if ([model.type isEqualToString:@"video"])
            self.commType = commVideo;
        else
            self.commType = commAudio;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    [[NSNotificationCenter defaultCenter] addObserverForName:@"日志" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@",note.object);
    }];
=======
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"音视频_背景图"]];
    imageView.frame = self.view.bounds;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    [self.view addSubview:self.mainVideoView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.menuButton];
    [self.view addSubview:self.sideBar];
<<<<<<< HEAD
    
    
=======

  
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
    self.channel.delegate = self;
    [self.channel join];
    [self.channel openAudio];
    [self.channel setSpeaker:YES];
    
    if (self.commType == commVideo) {
        [self.channel openVideo];
    }
    
    [self reloadData];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mainVideoView.frame = self.view.bounds;
    self.sideBar.frame = self.view.bounds;
}

- (void)reloadData
{
    if (_session) {
        NSMutableArray *tempArray = [NSMutableArray array];
        
<<<<<<< HEAD
        for (Y2WRTCMember *member in self.channel.getMembers) {
            if (!member.screenOpened) continue;
            
            GroupVideoCommunicationMemberViewCellModel *model = [[GroupVideoCommunicationMemberViewCellModel alloc]init];
            model.isScreen = YES;
            model.member = member;
            Y2WSessionMember *sessionMember = [self.session.members getMemberWithUserId:member.uid];
            model.sessionMember = sessionMember;
            [tempArray addObject:model];
        }
        
        for (Y2WRTCMember *member in self.channel.getMembers) {
            GroupVideoCommunicationMemberViewCellModel *model = [[GroupVideoCommunicationMemberViewCellModel alloc]init];
            model.member = member;
            Y2WSessionMember *sessionMember = [self.session.members getMemberWithUserId:member.uid];
            model.sessionMember = sessionMember;
            [tempArray addObject:model];
        }
        
=======
        for (Y2WRTCMember *member in self.channel.getMembers) {            GroupVideoCommunicationMemberViewCellModel *model = [[GroupVideoCommunicationMemberViewCellModel alloc]init];
                model.member = member;
                Y2WSessionMember *sessionMember = [self.session.members getMemberWithUserId:member.uid];
                model.sessionMember = sessionMember;
                [tempArray addObject:model];
        }

>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
        self.models = tempArray;
        
        GroupVideoCommunicationMemberViewCellModel *model = self.models.firstObject;
        self.mainVideoView.videoTrack = model.member.videoTrack;
        [self.collectionView reloadData];
        
        return;
    }
    
    [[Y2WUsers getInstance].getCurrentUser.sessions getSessionWithTargetId:self.sessionId type:@"group" success:^(Y2WSession *session) {
        self.session = session;
        [self reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - ———— Y2WRTCChannelDelegate ———— -


- (void)channel:(Y2WRTCChannel *)channel didJoinMember:(Y2WRTCMember *)member {
    [self reloadData];
    NSLog(@"%@",member);
}

- (void)channel:(Y2WRTCChannel *)channel didLeaveMember:(Y2WRTCMember *)member {
    [self reloadData];
}

- (void)channel:(Y2WRTCChannel *)channel didOpenAudioOfMember:(Y2WRTCMember *)member {
    
}

- (void)channel:(Y2WRTCChannel *)channel didCloseAudioOfMember:(Y2WRTCMember *)member {
    
}

- (void)channel:(Y2WRTCChannel *)channel didSwitchMuteAudioOfMember:(Y2WRTCMember *)member {
    
}

- (void)channel:(Y2WRTCChannel *)channel onAudioError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)channel:(Y2WRTCChannel *)channel didOpenVideoOfMember:(Y2WRTCMember *)member {
    [self reloadData];
    self.mainVideoView.hidden = NO;
    NSLog(@"%@",member);
}

- (void)channel:(Y2WRTCChannel *)channel didCloseVideoOfMember:(Y2WRTCMember *)member {
<<<<<<< HEAD
    [self reloadData];
    self.mainVideoView.hidden = YES;
}

- (void)channel:(Y2WRTCChannel *)channel onVideoError:(NSError *)error {
    
}

- (void)channel:(Y2WRTCChannel *)channel didOpenScreenOfMember:(Y2WRTCMember *)member {
    [self reloadData];
}

- (void)channel:(Y2WRTCChannel *)channel didCloseScreenOfMember:(Y2WRTCMember *)member {
    [self reloadData];
=======
        [self reloadData];
    self.mainVideoView.hidden = YES;
}

- (void)channel:(Y2WRTCChannel *)channel didSwitchVideoMuteOfMember:(Y2WRTCMember *)member {
    
}

- (void)channel:(Y2WRTCChannel *)channel onVideoError:(NSError *)error {
    
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
<<<<<<< HEAD
    self.mainVideoView.hidden = YES;
    GroupVideoCommunicationMemberViewCellModel *model = self.models[indexPath.row];
    if (model.isScreen) {
        if(model.member.videoOpened) self.mainVideoView.hidden = NO;
        self.mainVideoView.videoTrack = model.member.screenTrack;
        
    }else {
        if(model.member.videoOpened) self.mainVideoView.hidden = NO;
        self.mainVideoView.videoTrack = model.member.videoTrack;
    }
=======
    self.mainVideoView.hidden = NO;
    GroupVideoCommunicationMemberViewCellModel *model = self.models[indexPath.row];
    if(!model.member.videoOpened) self.mainVideoView.hidden = YES;
    self.mainVideoView.videoTrack = model.member.videoTrack;
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupVideoCommunicationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GroupVideoCommunicationCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
}

#pragma mark - GroupVideoChatSideBarDelegate
- (void)onTapSideBarItem:(GroupVideoChatSideBarItem *)item
{
    switch (item.itemType) {
        case Item_hangup:
        {
            [self.channel leave];
            self.channel = nil;
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            
        }
            break;
        case Item_mute:
        {
            [self.channel setMicMute:item.selected];
        }
            break;
        case Item_speaker:
        {
            [self.channel setSpeaker:item.selected];
        }
            break;
        case Item_video:
        {
            //                [self.channel setVideoMute:item.selected];
            if (item.selected) {
                [self.channel openVideo];
            }
            else
            {
                [self.channel closeVideo];
            }
            
        }
            break;
        case Item_changeCamera:
        {
            [self.channel useBackCamera:item.selected];
        }
            break;
        case Item_addMember:
        {
            
        }
            break;
        default:
            break;
    }
    
    if (!item.selected)
        item.selected = YES;
    else
        item.selected = NO;
}

#pragma mark - Helper

#pragma mark - Action

#pragma mark - Setter and Getter
- (Y2WRTCVideoView *)mainVideoView {
    if (!_mainVideoView) {
        _mainVideoView = [[Y2WRTCVideoView alloc] init];
    }
    return _mainVideoView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        //        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.itemSize = CGSizeMake(83, 110);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.left = 10;
        _collectionView.width = self.view.width - 20;
        _collectionView.height = 110;
        _collectionView.top = self.view.height - _collectionView.height - 10;
<<<<<<< HEAD
        
=======

>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[GroupVideoCommunicationCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([GroupVideoCommunicationCollectionViewCell class])];
        
    }
    return _collectionView;
}

- (NSArray *)models
{
    if (!_models) {
        _models = [NSArray array];
    }
    return _models;
}

- (UIButton *)menuButton {
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuButton setImage:[UIImage imageNamed:@"音视频_更多"] forState:UIControlStateNormal];
        _menuButton.frame = CGRectMake(self.view.frame.size.width - 10 - 35, 10, 35, 35);
        [_menuButton addTarget:self.sideBar action:@selector(show) forControlEvents:1<<6];
    }
    return _menuButton;
}

- (GroupVideoChatSideBar *)sideBar {
    if (!_sideBar) {
        _sideBar = [[GroupVideoChatSideBar alloc] initWithFrame:self.view.bounds];
        _sideBar.delegate = self;
        
        GroupVideoChatSideBarItem *hangupItem = [[GroupVideoChatSideBarItem alloc] init];
        hangupItem.title = @"挂断";
        hangupItem.image = [UIImage imageNamed:@"音视频_挂断_默认(更多)"];
        hangupItem.highlightedImage = [UIImage imageNamed:@"音视频_挂断_点击(更多)"];
        hangupItem.itemType = Item_hangup;
        
        
        GroupVideoChatSideBarItem *muteItem = [[GroupVideoChatSideBarItem alloc] init];
        muteItem.title = @"开启静音";
        muteItem.selectedTitle = @"关闭静音";
        muteItem.image = [UIImage imageNamed:@"音视频_语音_默认"];
        muteItem.highlightedImage = [UIImage imageNamed:@"音视频_语音_点击"];
<<<<<<< HEAD
=======
        muteItem.selected = YES;
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
        muteItem.itemType = Item_mute;
        
        GroupVideoChatSideBarItem *speakerItem = [[GroupVideoChatSideBarItem alloc] init];
        speakerItem.title = @"开启免提";
        speakerItem.selectedTitle = @"关闭免提";
        speakerItem.image = [UIImage imageNamed:@"音视频_免提_默认"];
        speakerItem.highlightedImage = [UIImage imageNamed:@"音视频_免提_点击"];
<<<<<<< HEAD
=======
        speakerItem.selected = YES;
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
        speakerItem.itemType = Item_speaker;
        
        GroupVideoChatSideBarItem *videoItem = [[GroupVideoChatSideBarItem alloc] init];
        videoItem.title = @"开启视频";
        videoItem.selectedTitle = @"关闭视频";
        videoItem.image = [UIImage imageNamed:@"音视频_摄像头_默认"];
        videoItem.highlightedImage = [UIImage imageNamed:@"音视频_摄像头_点击"];
        videoItem.itemType = Item_video;
        
        GroupVideoChatSideBarItem *backCameraItem = [[GroupVideoChatSideBarItem alloc] init];
        backCameraItem.title = @"前置镜头";
        backCameraItem.selectedTitle = @"后置镜头";
        backCameraItem.image = [UIImage imageNamed:@"音视频_转摄像头_默认"];
        backCameraItem.highlightedImage = [UIImage imageNamed:@"音视频_转摄像头_点击"];
        backCameraItem.itemType = Item_changeCamera;
        
        GroupVideoChatSideBarItem *addMemberItem = [[GroupVideoChatSideBarItem alloc] init];
        addMemberItem.title = @"添加成员";
        addMemberItem.image = [UIImage imageNamed:@"音视频_添加成员_默认"];
<<<<<<< HEAD
        addMemberItem.itemType = Item_addMember;
=======
         addMemberItem.itemType = Item_addMember;
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
        
        _sideBar.items = @[hangupItem,muteItem,speakerItem,videoItem,backCameraItem,addMemberItem];
    }
    return _sideBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
