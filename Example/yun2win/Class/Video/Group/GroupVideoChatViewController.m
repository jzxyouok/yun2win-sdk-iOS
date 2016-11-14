//
//  GroupVideoChatViewController.m
//  videoTest
//
//  Created by duanhl on 16/9/20.
//  Copyright © 2016年 duanhl. All rights reserved.
//  多人视频通话

#import "GroupVideoChatViewController.h"
#import "GroupVideoChatSideBar.h"
#import "GroupVideoChatCell.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "AVMemberModel.h"
#import "PromptBoxView.h"
#import "VideoStatusManager.h"
#import "SessionMemberPickerConfig.h"
#import "VideoDisabledView.h"

#define kGroupVideoCellId   @"kGroupVideoCellId"

@interface GroupVideoChatViewController ()<GroupVideoChatSideBarDelegate, AgoraRtcEngineDelegate, AVMemberModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton           *menuButton;        //菜单按钮
@property (weak, nonatomic) IBOutlet UIView             *videoMainView;     //主视频
@property (weak, nonatomic) IBOutlet UICollectionView   *collectionView;    //小视频
@property (weak, nonatomic) IBOutlet UIView             *disabledView;

@property (retain, nonatomic) GroupVideoChatSideBar     *sideBar;           //右侧菜单
@property (strong, nonatomic) AgoraRtcEngineKit         *agoraKit;          //声网

@property (strong, nonatomic) AVMemberModel             *mainMemberModel;   //
@property (strong, nonatomic) NSMutableArray            *cellMemberArray;   //视频model数组
@property (assign, nonatomic) BOOL                      isOpendVideo;       //是否关闭本地视频
@property (strong, nonatomic) VideoDisabledView         *videoDisabledView; //关闭本地视频显示出来的view

@end

@implementation GroupVideoChatViewController

- (void)dealloc {
    NSLog(@"group被释放");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (VideoDisabledView *)videoDisabledView
{
    if (_videoDisabledView == nil) {
        _videoDisabledView = [VideoDisabledView instanceVideoDisabledView];
    }
    return _videoDisabledView;
}

- (NSMutableArray *)cellMemberArray
{
    if (_cellMemberArray == nil) {
        _cellMemberArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _cellMemberArray;
}

- (GroupVideoChatSideBar *)sideBar {
    if (!_sideBar) {
        _sideBar = [[GroupVideoChatSideBar alloc] initWithFrame:self.view.bounds];
        _sideBar.delegate = self;
        
        GroupVideoChatSideBarItem *hangupItem = [[GroupVideoChatSideBarItem alloc] init];
        hangupItem.title = @"挂断";
        hangupItem.image = [UIImage y2w_imageNamed:@"音视频个人_挂断_默认"];
        hangupItem.selectedImage = [UIImage y2w_imageNamed:@"音视频个人_挂断_点击"];
        
        GroupVideoChatSideBarItem *muteItem = [[GroupVideoChatSideBarItem alloc] init];
        muteItem.title = @"静音关闭";
        muteItem.selectedTitle = @"静音开启";
        muteItem.image = [UIImage y2w_imageNamed:@"音视频_静音_关闭"];
        muteItem.selectedImage = [UIImage y2w_imageNamed:@"音视频_静音_开启"];
        
        GroupVideoChatSideBarItem *speakerItem = [[GroupVideoChatSideBarItem alloc] init];
        speakerItem.title = @"免提关闭";
        speakerItem.selectedTitle = @"免提开启";
        speakerItem.image = [UIImage y2w_imageNamed:@"音视频_免提_关闭"];
        speakerItem.selectedImage = [UIImage y2w_imageNamed:@"音视频_免提_开启"];
        speakerItem.selected = YES;
        
        GroupVideoChatSideBarItem *videoItem = [[GroupVideoChatSideBarItem alloc] init];
        videoItem.title = @"摄像头";
        videoItem.selectedTitle = @"摄像头";
        videoItem.image = [UIImage y2w_imageNamed:@"音视频_摄像头_关闭"];
        videoItem.selectedImage = [UIImage y2w_imageNamed:@"音视频_摄像头_开启"];
        videoItem.selected = !self.isOpendVideo;
        
        GroupVideoChatSideBarItem *backCameraItem = [[GroupVideoChatSideBarItem alloc] init];
        backCameraItem.title = @"前置镜头";
        backCameraItem.selectedTitle = @"后置镜头";
        backCameraItem.image = [UIImage y2w_imageNamed:@"音视频_转摄像头_默认"];
        
        GroupVideoChatSideBarItem *addMemberItem = [[GroupVideoChatSideBarItem alloc] init];
        addMemberItem.title = @"添加成员";
        addMemberItem.image = [UIImage y2w_imageNamed:@"音视频_添加成员_默认"];
        
        _sideBar.items = @[hangupItem, muteItem, speakerItem, videoItem, backCameraItem, addMemberItem];
    }
    
    return _sideBar;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.sideBar.frame = self.view.bounds;
    self.videoDisabledView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.disabledView addSubview:self.videoDisabledView];

    self.disabledView.hidden = self.mediaType == GroupVideoChatMediaTypeVideo;

    //屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.view addSubview:self.sideBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectNotAction:) name:KvideoRejectNot object:nil];
    [self.collectionView registerClass:[GroupVideoChatCell class] forCellWithReuseIdentifier:kGroupVideoCellId];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initAgoraKit];
    
    [[Y2WUsers getInstance].getCurrentUser.sessions.remote getSessionWithTargetId:self.sessionId type:@"group" success:nil failure:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CurAppDelegate.isOpenVideo = YES;
    CurAppDelegate.curVideoUserId = self.sessionId;
    self.isOpendVideo = YES;
    self.videoMainView.frame = self.videoMainView.superview.bounds;
    [self joinChannel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    CurAppDelegate.isOpenVideo = NO;
    CurAppDelegate.curVideoUserId = nil;
}

- (NSArray *)getMemberIdsFromMembers:(NSArray *)members
{
    NSMutableArray *memberIds = [NSMutableArray array];
    for (NSObject<MemberModelInterface> *member in members) {
        [memberIds addObject:member.uid];
    }
    return memberIds;
}

- (void)addMembers {
    Y2WSession *session = [[Y2WUsers getInstance].getCurrentUser.sessions getSessionById:self.sessionId];
    SessionMemberPickerConfig *config = [[SessionMemberPickerConfig alloc] initWithSession:session];
    config.filterIds = @[[Y2WUsers getInstance].currentUser.ID];
    UserPickerViewController *userPickerVC = [[UserPickerViewController alloc] initWithConfig:config];
    [userPickerVC selectMembersCompletion:^(NSArray<NSObject<MemberModelInterface> *> *members) {
        [[Y2WUsers getInstance].remote getUserByIds:[self getMemberIdsFromMembers:members] success:^(NSArray<Y2WUser *> *users) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (Y2WUser *tempUser in users) {
                    NSInteger index = [self findMemberModel:tempUser.ID.integerValue];
                    if (index == -1) {
                        [self creteMemberModel:tempUser.ID.integerValue isAdd:YES];
                        [self.collectionView reloadData];
                    }
                }
            });
        } failure:nil];
        [self sendChannelId:self.channelId withMode:VideoDataTypeVideo actionType:VideoActionTypeCall toUids:[self getMemberIdsFromMembers:members]];
    } cancel:nil];
    
    [self.navigationController pushViewController:userPickerVC animated:YES];
}

- (void)sendChannelId:(NSString *)channelId withMode:(VideoDataType)mediaType actionType:(VideoActionType)actionType toUids:(NSArray<NSString *> *)uids
{
    for (NSString *uid in uids) {
        [[Y2WUsers getInstance].getCurrentUser.sessions getSessionWithTargetId:uid type:@"p2p" success:^(Y2WSession *session) {
            NSDictionary *messageDic = [VideoStatusManager sendChannelId:channelId sessionId:self.sessionId mediaType:mediaType videoActionType:actionType videoChatType:@"group" formUid:[Y2WUsers getInstance].getCurrentUser.ID toUids:uids];
            
            IMSession *imSession = [[IMSession alloc] initWithSession:session];
            NSDictionary *pns = @{@"msg": [NSString stringWithFormat:@"来自%@的通话请求",[Y2WUsers getInstance].getCurrentUser.name],
                                  @"payload": @{@"av": messageDic}};
            [[Y2WUsers getInstance].getCurrentUser.bridge sendMessages:nil pushMessage:pns callMessage:messageDic toSession:imSession];
        } failure:^(NSError *error) {
            NSLog(@"%@",error.message);
        }];
    }
}

- (void)rejectNotAction:(NSNotification *)not {
    NSDictionary *dic = (NSDictionary *)not.object;
    NSString *actionStr = [dic objectForKey:@"action"];
    NSString *senderStr = [dic objectForKey:@"sender"];
    NSString *channelId = [dic objectForKey:@"channel"];
    NSString *senderName = [[Y2WUsers getInstance] getUserById:senderStr].name;
    
    NSDictionary *promptDic = @{@"reject" : @"对方已拒绝", @"busy" : @"正在通话中", @"cancel" : @"取消通话"};
    PromptBoxView *promptBox = [[PromptBoxView alloc] init];
    NSString *str = [promptDic objectForKey:actionStr];
    promptBox.title = [NSString stringWithFormat:@"%@%@",senderName, str];
    __weak typeof(self) weakSelf = self;
    [promptBox show:^{
        if ([actionStr isEqualToString:@"busy"]) {
            [weakSelf removeModelWithUID:senderStr.integerValue];
            if (weakSelf.cellMemberArray.count > 0){
                [weakSelf sendMessage:senderStr];
            }
        }else{
            [weakSelf removeModelWithUID:senderStr.integerValue];
            if (weakSelf.cellMemberArray.count > 0){
                [weakSelf sendMessage:senderStr];
            }
        }
       
//        if (weakSelf.cellMemberArray.count <= 0) {
//            [weakSelf hangupAction];
//        }
    }];
}

- (void)initAgoraKit
{
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:KagoraAppKey delegate:self];
    [self.agoraKit setLogFilter:AgoraRtc_LogFilter_Critical];
    [self setUpMianVideo];
    
    if (self.actionType == GroupVideoChatActionTypeCall) {
         [self setUpRemoteVideo];
    }
}

- (void)joinChannel
{
    __weak typeof(self) weakSelf = self;
    [self.agoraKit joinChannelByKey:nil channelName:self.channelId info:nil uid:[[Y2WUsers getInstance].getCurrentUser.ID integerValue] joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        
        [weakSelf.agoraKit setEnableSpeakerphone:YES];
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }];
}

- (void)setUpRemoteVideo {
    for (Y2WUser *tempUser in self.selectUserArray) {
        [self creteMemberModel:tempUser.ID.integerValue isAdd:NO];
    }
    
    [self.collectionView reloadData];
}

- (void)setUpMianVideo
{
    (self.mediaType == GroupVideoChatMediaTypeVideo) ? [self.agoraKit enableVideo] : [self.agoraKit disableVideo];
    
    [self.agoraKit enableLocalVideo:(self.mediaType == GroupVideoChatMediaTypeVideo)];
    
    [self creteMemberModel:[Y2WUsers getInstance].getCurrentUser.ID.integerValue isAdd:NO];
    
    [self switchVideoCellIndexPath:nil];
}

//创建model
- (void)creteMemberModel:(NSUInteger)uid isAdd:(BOOL)isAdd
{
    if (![self modelWithUID:uid]) {
        AVMemberModel *model = [[AVMemberModel alloc] init];
        model.user = [[Y2WUsers getInstance] getUserById:@(uid).stringValue];
        model.dataType = (self.mediaType == GroupVideoChatMediaTypeVideo) ? AVMemberTypeVideo : AVMemberTypeAudio;
        
        if (self.actionType == GroupVideoChatActionTypeCall) {
            model.dataType = (uid  == [[Y2WUsers getInstance].getCurrentUser.ID integerValue]) ? : AVMemberTypeNone;
        }

        model.isLocalVideo = (uid  == [[Y2WUsers getInstance].getCurrentUser.ID integerValue]);
        model.uid = uid;
        
        if (isAdd) {
            model.AVStatus = AVMemberStatusWait;
        }else{
            if (model.isLocalVideo) {
                model.AVStatus = AVMemberStatusAnswered;
            }else{
                model.AVStatus = (self.actionType == GroupVideoChatActionTypeCalled) ? AVMemberStatusAnswered : AVMemberStatusWait;
            }
        }
        
        model.AVMemberDelegate = self;
        [self.cellMemberArray addObject:model];
    }
}

//根据uid返回model索引
- (NSInteger)findMemberModel:(NSUInteger)uid
{
    NSString *uidStr = [NSString stringWithFormat:@"%lu", (unsigned long)uid];
    
    NSInteger index = -1;
    
    for (int i = 0; i < self.cellMemberArray.count; i++) {
        AVMemberModel *tempModel = self.cellMemberArray[i];
        if ([tempModel.user.ID isEqualToString:uidStr]) {
            index = i;
            break;
        }
    }
    
    return index;
}

//根据uid返回model
- (AVMemberModel *)modelWithUID:(NSInteger)uid {
    if (self.mainMemberModel.uid == uid) {
        return self.mainMemberModel;
    }
    for (int i = 0; i < self.cellMemberArray.count; i++) {
        AVMemberModel *tempModel = self.cellMemberArray[i];
        if (tempModel.uid == uid) {
            return tempModel;
        }
    }
    return nil;
}

//返回当前用户的model
- (AVMemberModel *)getCurrentModel {
    NSInteger uid = [[Y2WUsers getInstance].getCurrentUser.ID integerValue];
    if (self.mainMemberModel.uid == uid) {
        return self.mainMemberModel;
    }
    for (int i = 0; i < self.cellMemberArray.count; i++) {
        AVMemberModel *tempModel = self.cellMemberArray[i];
        if (tempModel.uid == uid) {
            return tempModel;
        }
    }
    return nil;
}

- (void)removeModelWithUID:(NSInteger)uid {
    AVMemberModel *model = [self modelWithUID:uid];
    if (!model) {
        return;
    }
    
    model.AVStatus = AVMemberStatusEnd;
    
    if (model == self.mainMemberModel) {
        [self renderViewWithModel:model inView:nil];
        self.mainMemberModel = self.cellMemberArray.lastObject;
        if (self.mainMemberModel) {
            [self.cellMemberArray removeObject:self.mainMemberModel];
            [self renderViewWithModel:self.mainMemberModel inView:self.videoMainView];
        }
    }
    else {
        [self.cellMemberArray removeObject:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

//切换视频
- (void)switchVideoCellIndexPath:(NSIndexPath *)indexPath
{
    if (!self.mainMemberModel) {
        AVMemberModel *cellModel = self.cellMemberArray.firstObject;
        [self.cellMemberArray removeObject:cellModel];
        [self.collectionView reloadData];
        
        self.mainMemberModel = cellModel;
        [self renderViewWithModel:self.mainMemberModel inView:self.videoMainView];
        return;
    }
    
    AVMemberModel *cellModel = self.cellMemberArray[indexPath.row];
    AVMemberModel *mainModel = self.mainMemberModel;
    
    NSInteger index = [self.cellMemberArray indexOfObject:cellModel];
    if (index != NSNotFound) {
        [self.cellMemberArray replaceObjectAtIndex:index withObject:mainModel];
        [self.collectionView reloadData];
        
        self.mainMemberModel = cellModel;
        [self renderViewWithModel:self.mainMemberModel inView:self.videoMainView];
    }
}

- (void)renderViewWithModel:(AVMemberModel *)model inView:(UIView *)view {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = model.uid;
    videoCanvas.view = view;
    videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    
    if (model.isLocalVideo) {
        [self.agoraKit stopPreview];
        
    }else {
        [self.agoraKit muteRemoteVideoStream:model.uid mute:YES];
    }
    
    if (!view) {
        return;
    }
    
    if (model.isLocalVideo) {
        [self.agoraKit setupLocalVideo:videoCanvas];
        [self.agoraKit startPreview];
        
    }else {
        [self.agoraKit setupRemoteVideo:videoCanvas];
        [self.agoraKit muteRemoteVideoStream:model.uid mute:NO];
    }
}

#pragma mark AVMemberModelDelegate
- (void)waitEnd:(AVMemberModel *)model
{
    [self removeModelWithUID:model.uid];
    
    NSString *curId = [Y2WUsers getInstance].getCurrentUser.ID;
    NSString *targetUid = [NSString stringWithFormat:@"%ld",(long)model.uid];
    if ([curId isEqualToString:targetUid]) { return; }
    
    [[Y2WUsers getInstance].currentUser.sessions getSessionWithTargetId:targetUid type:@"p2p" success:^(Y2WSession *session) {
        
        [VideoStatusManager sendChannelId:self.channelId mediaType:VideoDataTypeVideo videoActionType:VideoActionTypeCancel formUid:targetUid toUids:@[targetUid] sessionId:session.ID];
        
    } failure:^(NSError *error) {
        
    }];
    
    [self sendMessage:[NSString stringWithFormat:@"%ld",(long)model.uid]];
    
//    if (self.cellMemberArray.count <= 0) {
//        [self hangupAction];
//    }
}

#pragma mark AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    __weak typeof(self) weakSelf = self;
    weakSelf.videoMainView.frame = weakSelf.videoMainView.superview.bounds; // video view's autolayout cause crash
}


- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    __weak typeof(self) weakSelf = self;
    if (self.actionType == GroupVideoChatActionTypeCall) {
        NSInteger index = [self findMemberModel:uid];
        if (index != -1 && index < self.cellMemberArray.count) {
            AVMemberModel *tempModel = self.cellMemberArray[index];
            tempModel.dataType = AVMemberTypeVideo;
            tempModel.AVStatus = AVMemberStatusAnswered;
            [weakSelf.collectionView reloadData];
        }
    }else {
        NSInteger index = [self findMemberModel:uid];
        if (index != -1 && index < self.cellMemberArray.count) {
            AVMemberModel *tempModel = self.cellMemberArray[index];
            tempModel.dataType = AVMemberTypeVideo;
            tempModel.AVStatus = AVMemberStatusAnswered;
            [weakSelf.collectionView reloadData];
            
        }else if (index == -1) {
            [self creteMemberModel:uid isAdd:NO];
            [weakSelf.collectionView reloadData];
        }
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason
{
    __weak typeof(self) weakSelf = self;
    [weakSelf removeModelWithUID:uid];
//    if (weakSelf.cellMemberArray.count <= 0) {
//        [weakSelf hangupAction];
//    }
}

//远程用户关闭视频或重新开启视频的回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid
{
    __weak typeof(self) weakSelf = self;
    NSUInteger index = [self findMemberModel:uid];
    if (index != -1 && index < self.cellMemberArray.count) {
        AVMemberModel *tempModel = self.cellMemberArray[index];
        tempModel.dataType = muted ? AVMemberTypeAudio : AVMemberTypeVideo;
        [weakSelf.collectionView reloadData];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode
{
    __weak typeof(self) weakSelf = self;
    if (errorCode == AgoraRtc_Error_InvalidAppId) {
        [weakSelf.agoraKit leaveChannel:nil];
    }
}

#pragma mark - ———— GroupVideoChatSideBarDelegate ———— -
- (void)groupVideoChatSideBar:(GroupVideoChatSideBar *)sidbar didSelectItem:(GroupVideoChatSideBarItem *)item {
    item.selected = !item.selected;
    
    if ([item.title isEqualToString:@"挂断"]) {
        [self hangupAction];
        
    }else if ([item.title isEqualToString:@"静音关闭"]) {
        [self.agoraKit muteLocalAudioStream:item.selected];
        
    }else if ([item.title isEqualToString:@"免提关闭"]) {
         [self.agoraKit setEnableSpeakerphone:item.selected];
        
    }else if ([item.title isEqualToString:@"摄像头"]) {
        if (item.selected) {
            [self.agoraKit startPreview];
            if (self.mediaType == GroupVideoChatMediaTypeVideo) {
                [self.agoraKit muteLocalVideoStream:NO];
            }
            [self.agoraKit enableLocalVideo:YES];
            self.disabledView.hidden = YES;
            
            AVMemberModel *model = [self getCurrentModel];
            if (model) {
                model.dataType = AVMemberTypeVideo;
            }
            [self.collectionView reloadData];
            
        }else {
            [self.agoraKit stopPreview];
            if (self.mediaType == GroupVideoChatMediaTypeVideo) {
                [self.agoraKit muteLocalVideoStream:YES];
            }
            [self.agoraKit enableLocalVideo:NO];
            self.disabledView.hidden = !self.mainMemberModel.isLocalVideo;
            
            AVMemberModel *model = [self getCurrentModel];
            if (model) {
                model.dataType = AVMemberTypeAudio;
            }
            [self.collectionView reloadData];
        }
    
    }else if ([item.title isEqualToString:@"前置镜头"]) {
        [self.agoraKit switchCamera];
        
    }else if ([item.title isEqualToString:@"添加成员"]) {
        [self addMembers];
    }
}

//挂断
- (void)hangupAction {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    for (AVMemberModel *model in self.cellMemberArray) {
        NSString *curId = [Y2WUsers getInstance].getCurrentUser.ID;
        NSString *targetUid = [NSString stringWithFormat:@"%ld",(long)model.uid];
        if ([curId isEqualToString:targetUid]) { continue; }
        
        [[Y2WUsers getInstance].currentUser.sessions getSessionWithTargetId:targetUid type:@"p2p" success:^(Y2WSession *session) {
            
            [VideoStatusManager sendChannelId:self.channelId mediaType:VideoDataTypeVideo videoActionType:VideoActionTypeCancel formUid:targetUid toUids:@[targetUid] sessionId:session.ID];
            
        } failure:^(NSError *error) {
            
        }];

        [self sendMessage:[NSString stringWithFormat:@"%ld",(long)model.uid]];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)sendMessage:(NSString *)uidStr{
    NSString *mediaStr = (self.mediaType == GroupVideoChatMediaTypeVideo) ? @"多人视频通话未接听" : @"多人语音通话未接听";
    [VideoStatusManager sendMessageTargetUserId:uidStr mediaType:VideoDataTypeVideo messageText:mediaStr];
}

- (void)groupVideoChatSideBarWillShow {
    self.menuButton.hidden = YES;
}

- (void)groupVideoChatSideBarWillHide {
    self.menuButton.hidden = NO;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellMemberArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupVideoChatCell *cell = (GroupVideoChatCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGroupVideoCellId forIndexPath:indexPath];
    
    AVMemberModel *tempModel = self.cellMemberArray[indexPath.row];
    if (tempModel.dataType == AVMemberTypeVideo) {
        [self renderViewWithModel:tempModel inView:cell.videoView];
    }
    
    cell.userModel = tempModel;
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AVMemberModel *tempModel = self.cellMemberArray[indexPath.row];
    if (tempModel.dataType == AVMemberTypeVideo) {
        [self switchVideoCellIndexPath:indexPath];
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90.0f, 110.0f);
}

#pragma mark 按钮点击事件
- (IBAction)menuButtonAction:(UIButton *)sender {
    [self.sideBar show];
}

@end
