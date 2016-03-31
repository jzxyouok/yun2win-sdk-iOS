//
//  SessionMembersViewController.m
//  API
//
//  Created by QS on 16/3/24.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "SessionMembersViewController.h"
#import "UserPickerViewController.h"
#import "ContactPickerConfig.h"
#import "MemberGroupsModel.h"
#import "MemberModelCell.h"
#import "SessionMemberModel.h"

@interface SessionMembersViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) Y2WSessionMembers *sessionMembers;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) MemberGroupsModel *members;

@end

@implementation SessionMembersViewController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithSessionMembers:(Y2WSessionMembers *)sessionMembers {
    if (self = [super init]) {
        self.sessionMembers = sessionMembers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavItem];
    [self.view addSubview:self.tableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:Y2WSessionMemberDidChangeNotification object:nil];
    
    [self reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)setUpNavItem{
    self.navigationItem.title = @"群成员";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_返回"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_加号"] style:UIBarButtonItemStylePlain target:self action:@selector(showAlert)];
}



#pragma mark - ———— Response ———— -

- (void)showAlert {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *addMemberAction = [UIAlertAction actionWithTitle:@"添加群成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addMember];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:addMemberAction];
    
    [self showDetailViewController:alertVC sender:nil];
}

- (void)addMember {
    ContactPickerConfig *config = [[ContactPickerConfig alloc] init];
    
    UserPickerViewController *userPickerVC = [[UserPickerViewController alloc] initWithConfig:config];
    [userPickerVC selectMembersCompletion:^(NSArray<NSObject<MemberModelInterface> *> *members) {

        // 构建需要添加的成员对象
        NSMutableArray *sessionMembers = [NSMutableArray array];
        for (NSObject<MemberModelInterface> *member in members) {
            
            Y2WSessionMember *sessionMember = [[Y2WSessionMember alloc] init];
            sessionMember.name = member.name;
            sessionMember.userId = member.uid;
            sessionMember.avatarUrl = member.imageUrl;
            sessionMember.role = @"user";
            sessionMember.status = @"active";
            [sessionMembers addObject:sessionMember];
        }


        [self.navigationItem startAnimating];
        __unsafe_unretained SessionMembersViewController *weakSelf = self;
        [self.sessionMembers.remote addSessionMembers:sessionMembers success:^{
            
            [weakSelf.navigationItem stopAnimating];
            
        } failure:^(NSError *error) {
            [weakSelf.navigationItem stopAnimating];
            [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
        }];

    } cancel:nil];
    
    [self pushViewController:userPickerVC];
}



#pragma mark - ———— Response ———— -

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}






- (void)reloadData {
    
    self.members = [[MemberGroupsModel alloc] init];
    
    NSArray *datas = [self.sessionMembers getMembers];
    
    for (Y2WSessionMember *sessionMember in datas) {
        SessionMemberModel *model = [[SessionMemberModel alloc] initWithSessionMember:sessionMember];
        [self.members addContact:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.tableView.backgroundView.hidden = self.members.groupModels.count;
    });
}






#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.members.groupModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.members groupModelForRowAtSection:section].contacts.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MemberModelCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MemberModelCell class])];
    
    cell.model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.members titles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.members sectionForGroupTitle:title];
}


#pragma mark - ———— UITableViewDelegate ———— -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
    label.backgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
    label.textColor = [UIColor colorWithHexString:@"353535"];
    label.font = [UIFont systemFontOfSize:14];
    
    NSString *text = [[self.members groupModelForRowAtSection:section] groupTitle];
    NSMutableAttributedString *aText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 10;
    [aText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    label.attributedText = aText;
    return label;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.members groupModelForRowAtSection:section] groupTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<MemberModelInterface> *model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    return model.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSObject<MemberModelInterface> *model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    
    
//    [[Y2WUsers getInstance].getCurrentUser.sessions getSessionWithTargetId:model.uid type:@"p2p" success:^(Y2WSession *session) {
//        
//        ConversationViewController *conversationVC = [[ConversationViewController alloc] initWithSession:session];
//        [self pushViewController:conversationVC];
//        
//    } failure:^(NSError *error) {
//        [UIAlertView showTitle:@"错误" message:error.description];
//    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<MemberModelInterface> *model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    if ([model.uid.uppercaseString isEqualToString:[Y2WUsers getInstance].getCurrentUser.userId]) return NO;
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSObject<MemberModelInterface> *model = [self.members groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];

        if ([model isKindOfClass:[SessionMemberModel class]]) {
            Y2WSessionMember *member = [(SessionMemberModel *)model sessionMember];

            [self.navigationItem startAnimating];
            [self.sessionMembers.remote deleteSessionMember:member success:^{
                [self.navigationItem stopAnimating];
                
            } failure:^(NSError *error) {
                [self.navigationItem stopAnimating];
                [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
            }];
        }
    }];
    return @[action];
}







#pragma mark - ———— getter ———— -

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.sectionIndexColor = [ThemeManager sharedManager].currentColor;
        _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.sectionHeaderHeight = 16;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ConversationList_bgImg"]];
        _tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        [_tableView registerClass:[MemberModelCell class] forCellReuseIdentifier:NSStringFromClass([MemberModelCell class])];
    }
    return _tableView;
}

@end
