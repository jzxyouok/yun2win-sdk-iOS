//
//  ContactsViewController.m
//  API
//
//  Created by ShingHo on 16/1/19.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ContactsViewController.h"
#import "ConversationViewController.h"
#import "SearchUserViewController.h"
#import "UserPickerViewController.h"
#import "ContactPickerConfig.h"
#import "MemberModelCell.h"
#import "Y2WContact.h"
#import "MemberGroupsModel.h"

@interface ContactsViewController ()<UITableViewDataSource,UITableViewDelegate,Y2WContactsDelegate>

@property (nonatomic, retain) Y2WContacts *contacts;

@property (nonatomic, retain) MemberGroupsModel *model;

@property (nonatomic, retain) UISearchBar *searchBar;

@property (nonatomic, retain) UITableView *tableView;

@end


@implementation ContactsViewController

- (void)dealloc {
    
    [self.contacts removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavItem];
    [self.view addSubview:self.tableView];
    
    [self reloadData];
    [self.contacts addDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)setUpNavItem{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_加号"] style:UIBarButtonItemStylePlain target:self action:@selector(showAlert)];
}





#pragma mark - ———— Y2WContactsDelegate ———— -

- (void)contactsWillChangeContent:(Y2WContacts *)contacts {
    
}

- (void)contacts:(Y2WContacts *)contacts onAddContact:(Y2WContact *)contact {
//    ContactModel *contactModel = [[ContactModel alloc] initWithContact:contact];
//    [self.model addContact:contactModel];
}

- (void)contacts:(Y2WContacts *)contacts onDeleteContact:(Y2WContact *)contact {
    NSLog(@"删除");
}

- (void)contacts:(Y2WContacts *)contacts onUpdateContact:(Y2WContact *)contact {
    NSLog(@"更新");
}

- (void)contactsDidChangeContent:(Y2WContacts *)contacts {
    [self reloadData];
}





#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.groupModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model groupModelForRowAtSection:section].contacts.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MemberModelCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MemberModelCell class])];
    
    cell.model = [self.model groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.model titles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.model sectionForGroupTitle:title];
}


#pragma mark - ———— UITableViewDelegate ———— -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
    label.backgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
    label.textColor = [UIColor colorWithHexString:@"353535"];
    label.font = [UIFont systemFontOfSize:14];
    
    NSString *text = [[self.model groupModelForRowAtSection:section] groupTitle];
    NSMutableAttributedString *aText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 10;
    [aText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    label.attributedText = aText;
    return label;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.model groupModelForRowAtSection:section] groupTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<MemberModelInterface> *model = [self.model groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
    return model.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSObject<MemberModelInterface> *model = [self.model groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];

    if ([model isKindOfClass:[ContactModel class]]) {
        Y2WContact *contact = [(ContactModel *)model contact];
        [self pushToSessionWithContact:contact];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSObject<MemberModelInterface> *model = [self.model groupModelForRowAtSection:indexPath.section].contacts[indexPath.row];
        if ([model isKindOfClass:[ContactModel class]]) {
            Y2WContact *contact = [(ContactModel *)model contact];
            [self deleteContact:contact];
        }
    }];
    return @[action];
}








#pragma mark - ———— Response ———— -

- (void)reloadData {
    _model = [[MemberGroupsModel alloc] init];

    for (Y2WContact *contact in [self.contacts getContacts]) {
        ContactModel *contactModel = [[ContactModel alloc] initWithContact:contact];
        [self.model addContact:contactModel];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        self.tableView.backgroundView.hidden = self.model.groupModels.count;
    });
}

- (void)showAlert {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *createSessionAction = [UIAlertAction actionWithTitle:@"发起群聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createSession];
    }];
    
    UIAlertAction *addFriendAction = [UIAlertAction actionWithTitle:@"添加好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addFriend];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:addFriendAction];
    [alertVC addAction:createSessionAction];
    
    [self showDetailViewController:alertVC sender:nil];
}

- (void)addFriend {
    
    SearchUserViewController *searchUserViewController = [[SearchUserViewController alloc] init];
    [self pushViewController:searchUserViewController];
}

- (void)createSession {
    
    ContactPickerConfig *config = [[ContactPickerConfig alloc] init];
    
    UserPickerViewController *userPickerVC = [[UserPickerViewController alloc] initWithConfig:config];
    [userPickerVC selectMembersCompletion:^(NSArray<NSObject<MemberModelInterface> *> *members) {
        [self createSessionWith:members];
    } cancel:nil];
    
    [self pushViewController:userPickerVC];
}

- (void)createSessionWith:(NSArray<NSObject<MemberModelInterface> *> *)members {
    [self.navigationItem startAnimating];
    
    [self.contacts.user.sessions.remote addWithName:nil type:@"group" secureType:@"public" avatarUrl:nil success:^(Y2WSession *session) {
        // 创建成功准备添加成员
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
        
        
        // 调用添加方法
        [session.members.remote addSessionMembers:sessionMembers success:^{
            
            [self.navigationItem stopAnimating];
            
        } failure:^(NSError *error) {
            
            [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
        }];
        
    } failure:^(NSError *error) {
        
        [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
    }];
}

- (void)pushToSessionWithContact:(Y2WContact *)contact {
    
    [self.navigationItem startAnimating];
    
    [contact getSessionDidCompletion:^(Y2WSession *session, NSError *error) {
        
        [self.navigationItem stopAnimating];
        
        if (error) {
            [UIAlertView showTitle:@"错误" message:error.description];
            return;
        }
        
        ConversationViewController *conversationVC = [[ConversationViewController alloc] initWithSession:session];
        [self pushViewController:conversationVC];
    }];
}

// 删除联系人
- (void)deleteContact:(Y2WContact *)contact {

    [self.navigationItem startAnimating];
    [self.contacts.remote deleteContact:contact success:^{
        [self.navigationItem stopAnimating];
        
        // 删除用户会话
        Y2WUserConversation *conversation = contact.getUserConversation;
        if (conversation) [self deleteConversation:conversation];
        
    } failure:^(NSError *error) {
        [self.navigationItem stopAnimating];
        [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
    }];
}

// 删除用户会话
- (void)deleteConversation:(Y2WUserConversation *)conversation {
    
    [self.navigationItem startAnimating];
    
    Y2WUserConversations *conversations = self.contacts.user.userConversations;
    [conversations.remote deleteUserConversation:conversation success:^{
        [self.navigationItem stopAnimating];

    } failure:^(NSError *error) {
        [self.navigationItem stopAnimating];

        [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
    }];
}





#pragma mark - ———— getter ———— -

- (Y2WContacts *)contacts {
    
    if (!_contacts) {
        _contacts = [Y2WUsers getInstance].getCurrentUser.contacts;
    }
    return _contacts;
}

- (MemberGroupsModel *)model {
    
    if (!_model) {
        _model = [[MemberGroupsModel alloc] init];
    }
    return _model;
}

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.tintColor = [UIColor redColor];
    }
    return _searchBar;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.sectionIndexColor = [ThemeManager sharedManager].currentColor;
        _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
        _tableView.tableHeaderView = self.searchBar;
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
