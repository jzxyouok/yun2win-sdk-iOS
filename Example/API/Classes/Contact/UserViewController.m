//
//  UserViewController.m
//  API
//
//  Created by QS on 16/3/21.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()

@property (nonatomic, retain) Y2WUser *user;

@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;

@end

@implementation UserViewController

- (instancetype)initWithUser:(Y2WUser *)user {
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.addFriendBtn setBackgroundImage:[UIImage imageWithUIColor:[UIColor colorWithHexString:@"54DE79"]]
                                 forState:UIControlStateNormal];
    
    [self reloadData];
}


- (void)reloadData {
    
    self.avatarBtn.backgroundColor = [UIColor colorWithUID:self.user.userId];
    [self.avatarBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"默认个人头像"]];
    self.nameLabel.text = self.user.name;
    self.accountLabel.text = [@"账号 : " stringByAppendingString:self.user.account];
}




#pragma mark - ———— Response ———— -

- (IBAction)clickAvatar:(id)sender {
    
    
}


- (IBAction)addFriend:(id)sender {
    
    Y2WContact *contact = [[Y2WContact alloc] init];
    contact.userId = self.user.userId;
    contact.name = self.user.name;
    
    [[Y2WUsers getInstance].getCurrentUser.contacts.remote addContact:contact success:^{
        
        self.addFriendBtn.hidden = YES;
        [self reloadData];
        
        [UIAlertView showTitle:nil message:@"添加成功"];
        
    } failure:^(NSError *error) {
        
        [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
    }];
}

@end
