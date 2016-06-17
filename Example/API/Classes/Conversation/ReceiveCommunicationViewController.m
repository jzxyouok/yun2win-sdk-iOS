//
//  ReceiveCommunicationViewController.m
//  API
//
//  Created by ShingHo on 16/5/12.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ReceiveCommunicationViewController.h"
#import "ReceiveAndCloseView.h"
#import "GroupVideoCommunicationViewController.h"
#import "CommunicationViewController.h"
#import <Y2W_RTC_SDK/Y2WRTCManager.h>
@interface ReceiveCommunicationViewController ()<ReceiveAndCloseViewDelegate>

@property (nonatomic, strong) AVCallModel *model;

@property (nonatomic, assign) BOOL isSender;

@property (nonatomic , strong) ReceiveAndCloseView *bottomView;

@property (nonatomic, strong) UIImageView *typeImageView;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UIButton *avatarBtn;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *inviteLabel;

@property (nonatomic, strong) Y2WContact *contact;

@property (nonatomic, strong) Y2WSession *session;

@property (nonatomic, strong) Y2WSessionMember *sessionMember;

@end

@implementation ReceiveCommunicationViewController

- (instancetype)initWithModel:(AVCallModel *)model IsSender:(BOOL)isSender
{
    if (self = [super init]) {
        
        self.model = model;
        self.isSender = isSender;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"音视频_背景图"]];
    imageView.frame = self.view.bounds;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    [self.view addSubview:self.bottomView];

    self.typeImageView.bottom = self.view.size.height - 210;
    self.typeImageView.height = 75;
    self.typeImageView.width = 200;
    self.typeImageView.left = self.view.width/2 - 100;

    [self.view addSubview:self.typeImageView];
    
    self.inviteLabel.bottom = self.typeImageView.top - 75;
    [self.view addSubview:self.inviteLabel];
    self.nameLabel.bottom = self.inviteLabel.top - 15;
    [self.view addSubview:self.nameLabel];
    
//    self.avatarImageView.centerX = self.view.centerX;
//    self.avatarImageView.bottom = self.nameLabel.top - 15;
//    [self.view addSubview:self.avatarImageView];
    
    self.avatarBtn.centerX = self.view.centerX;
    self.avatarBtn.bottom = self.nameLabel.top - 15;
    [self.view addSubview:self.avatarBtn];
    [self refreshView];
}

- (void)refreshView
{
    if (!self.model.sessionId.length) {
        self.contact = [[Y2WUsers getInstance].getCurrentUser.contacts getContactWithUID:self.model.senderId];
        self.nameLabel.text = self.contact.name;
        [self.avatarBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.contact.avatarUrl] placeholderImage:[UIImage imageNamed:@"默认个人头像"]];
    }
    else{
        [self getMemberAvarter];
    }
}

- (void)getMemberAvarter
{
    if (self.session) {
        
        self.sessionMember = [self.session.members getMemberWithUserId:self.model.senderId];
        self.nameLabel.text = self.sessionMember.name;
        [self.avatarBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.sessionMember.avatarUrl] placeholderImage:[UIImage imageNamed:@"默认个人头像"]];
        return;
    }
    [[Y2WUsers getInstance].getCurrentUser.sessions getSessionWithTargetId:self.model.sessionId type:@"group" success:^(Y2WSession *session) {
        self.session = session;
        [self getMemberAvarter];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - ReceiveAndCloseViewDelegate
- (void)onClickButton:(UIButton *)sender
{
    if (sender.tag == 101) {
        //挂断
<<<<<<< HEAD
//        Y2WRTCManager *manager = [[Y2WRTCManager alloc] init];
//        NSLog(@"%@",self.model);
//        manager.channelId = self.model.channelId;
//        manager.memberId = [Y2WUsers getInstance].getCurrentUser.userId; //uid
//        manager.token = [Y2WUsers getInstance].getCurrentUser.imToken; //token
//        [manager getChannel:^(NSError *error, Y2WRTCChannel *channel) {
//            [channel leave];
//
//        }];
        [self dismissViewControllerAnimated:YES completion:nil];

=======
        Y2WRTCManager *manager = [[Y2WRTCManager alloc] init];
        manager.channelId = self.model.channelId;
        manager.memberId = [Y2WUsers getInstance].getCurrentUser.userId; //uid
        manager.token = [Y2WUsers getInstance].getCurrentUser.imToken; //token
        [manager getChannel:^(NSError *error, Y2WRTCChannel *channel) {
            [channel leave];
            [self dismissViewControllerAnimated:YES completion:nil];

        }];
        
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
    }
    if (sender.tag == 102) {
        //接听
        Y2WRTCManager *manager = [[Y2WRTCManager alloc] init];
<<<<<<< HEAD
        NSLog(@"%@",self.model);
=======
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
        manager.channelId = self.model.channelId;
        manager.memberId = [Y2WUsers getInstance].getCurrentUser.userId; //uid
        manager.token = [Y2WUsers getInstance].getCurrentUser.imToken; //token
        [manager getChannel:^(NSError *error, Y2WRTCChannel *channel) {
            
            if (error) {
<<<<<<< HEAD
                [UIAlertView showTitle:manager.channelId ?: @"" message:error.description];

=======
>>>>>>> 7b7020d0bed3227d23c9982a2a76306bb10dc107
                // 加入失败，返回错误
                return;
            }
            // 使用channel对象管理连接
            
//            if (self.model.) {

//            }
            if ([self.model.avcall isEqualToString:@"groupavcall"]) {
                GroupVideoCommunicationViewController *communication = [[GroupVideoCommunicationViewController alloc]initWithAVCallModel:self.model withChannel:channel];
                //            [self presentViewController:communication animated:YES completion:nil];
                
                UIViewController *presentingViewController = self.presentingViewController;
                [self dismissViewControllerAnimated:YES completion:^{
                    [presentingViewController presentViewController:communication animated:YES completion:nil];
                }];

            }
            else
            {
                CommunicationViewController *comm = [[CommunicationViewController alloc]initWithAVCallModel:self.model Channel:channel];
                
                UIViewController *presentingViewController = self.presentingViewController;
                [self dismissViewControllerAnimated:YES completion:^{
                    [presentingViewController presentViewController:comm animated:YES completion:nil];
                }];
            }
            
        }];

    }
}

#pragma mark - Setter and Getter

- (ReceiveAndCloseView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[ReceiveAndCloseView alloc]initWithIsSender:self.isSender];
        _bottomView.delegate = self;
        _bottomView.frame = CGRectMake(0, self.view.height - 100, self.view.width, 100);
    }
    return _bottomView;
}

- (UIImageView *)typeImageView
{
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc]init];
        if ([self.model.type isEqualToString:@"audio"])
            _typeImageView.image = [UIImage imageNamed:@"音视频_语音通话提示图"];
        else
            _typeImageView.image = [UIImage imageNamed:@"音视频_视频通话提示图"];
    }
    return _typeImageView;
}

- (UILabel *)inviteLabel
{
    if (!_inviteLabel) {
        _inviteLabel = [[UILabel alloc]init];
        _inviteLabel.font = [UIFont systemFontOfSize:24];
        _inviteLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _inviteLabel.textAlignment = NSTextAlignmentCenter;
        _inviteLabel.height = 16;
        _inviteLabel.width = self.view.width;
        _inviteLabel.left = 0;
        _inviteLabel.text = @"邀请您进行音视频通话";
    }
    return _inviteLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:24];
        _nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.height = 25;
        _nameLabel.width = self.view.width;
        _nameLabel.left = 0;
    }
    return _nameLabel;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.2].CGColor;
        _avatarImageView.layer.borderWidth = 10;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 70;
        _avatarImageView.width = _avatarImageView.height = 140;

    }
    return _avatarImageView;
}

- (UIButton *)avatarBtn
{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarBtn.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.2].CGColor;
        _avatarBtn.layer.borderWidth = 10;
        _avatarBtn.layer.masksToBounds = YES;
        _avatarBtn.layer.cornerRadius = 70;
        _avatarBtn.width = _avatarBtn.height = 140;
    }
    return _avatarBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
