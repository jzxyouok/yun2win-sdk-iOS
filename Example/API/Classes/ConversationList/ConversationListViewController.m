//
//  ConversationListViewController.m
//  API
//
//  Created by ShingHo on 16/1/19.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ConversationListViewController.h"
#import "ConversationViewController.h"
#import "Y2WUserConversations.h"
#import "ConversationListCell.h"
#import "MainViewController.h"

@interface ConversationListViewController () <UITableViewDataSource,UITableViewDelegate,Y2WUserConversationsDelegate>

@property (nonatomic, retain) Y2WUserConversations *userConversations;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation ConversationListViewController

- (void)dealloc {
    [self.userConversations removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavItem];
    [self.view addSubview:self.tableView];
    
    [self reloadData];
    [self.userConversations addDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)setUpNavItem{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
}







#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConversationListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ConversationListCell class])];
  
    cell.conversation = self.datas[indexPath.row];
    
    return cell;
}


#pragma mark - ———— UITableViewDelegate ———— -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Y2WUserConversation *conversation = self.datas[indexPath.row];
    [self pushToSessionWithConversation:conversation];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.navigationItem startAnimating];

        Y2WUserConversation *conversation = self.datas[indexPath.row];
        [conversation.userConversations.remote deleteUserConversation:conversation success:^{
            
            [self.navigationItem stopAnimating];
            [UIAlertView showTitle:nil message:@"删除成功"];
            
        } failure:^(NSError *error) {
            
            [self.navigationItem stopAnimating];
            [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
        }];
    }];
    return @[deleteAction];
}





#pragma mark - ———— Y2WUserConversationsDelegate ———— -

- (void)userConversationsWillChangeContent:(Y2WUserConversations *)userConversations {
    
}

- (void)userConversations:(Y2WUserConversations *)userConversations onAddUserConversation:(Y2WUserConversation *)userConversation {
}

- (void)userConversations:(Y2WUserConversations *)userConversations onDeleteUserConversation:(Y2WUserConversation *)userConversation {
    
}

- (void)userConversations:(Y2WUserConversations *)userConversations onUpdateUserConversation:(Y2WUserConversation *)userConversation {
    
}

- (void)userConversationsDidChangeContent:(Y2WUserConversations *)userConversations {
    NSLog(@"adfadsfadsf");
    [self reloadData];
}





#pragma mark - ———— Response ———— -

- (void)pushToSessionWithConversation:(Y2WUserConversation *)conversation {
    
    [self.navigationItem startAnimating];
    
    [conversation getSessionDidCompletion:^(Y2WSession *session, NSError *error) {
        
        [self.navigationItem stopAnimating];
        
        if (error) {
            [UIAlertView showTitle:nil message:error.description];
            return;
        }
        
        ConversationViewController *conversationVC = [[ConversationViewController alloc] initWithSession:session];
        [self pushViewController:conversationVC];
    }];
}




- (void)reloadData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.datas = [self.userConversations getUserConversations];
        self.datas = [self.datas sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
        
        [self.tableView reloadData];
        self.tableView.backgroundView.hidden = self.datas.count;
    });
}



#pragma mark - ———— getter ———— -

- (Y2WUserConversations *)userConversations {
    
    if (!_userConversations) {
        _userConversations = [Y2WUsers getInstance].getCurrentUser.userConversations;
    }
    return _userConversations;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ConversationList_bgImg"]];
        _tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        [_tableView registerClass:[ConversationListCell class] forCellReuseIdentifier:NSStringFromClass([ConversationListCell class])];
    }
    return _tableView;
}

@end