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
#import "ConversationTableManager.h"

@interface ConversationListViewController () <UITableViewDataSource,UITableViewDelegate,TableViewIndexPathChangeDelegate>

@property (nonatomic, retain) ConversationTableManager *tableManager;

@property (nonatomic, retain) UITableView *tableView;

//@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavItem];
    [self.view addSubview:self.tableView];
    [self tableManager];
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
    return self.tableManager.conversationDatas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ConversationListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ConversationListCell class])];
  
    cell.conversation = self.tableManager.conversationDatas[indexPath.row];

    return cell;
}


#pragma mark - ———— UITableViewDelegate ———— -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Y2WUserConversation *conversation = self.tableManager.conversationDatas[indexPath.row];
    [self pushToSessionWithConversation:conversation];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.navigationItem startAnimating];

        Y2WUserConversation *conversation = self.tableManager.conversationDatas[indexPath.row];
        [conversation.userConversations.remote deleteUserConversation:conversation success:^{
            
            [self.navigationItem stopAnimating];
//            [UIAlertView showTitle:nil message:@"删除成功"];
            
        } failure:^(NSError *error) {
            
            [self.navigationItem stopAnimating];
            [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
        }];
    }];
    return @[deleteAction];
}







#pragma mark - ———— Y2WUserConversationsDelegate ———— -

- (void)tableViewIndexPathWillChangeContent:(id)manager {
    [self.tableView beginUpdates];
}

- (void)tableViewIndexPathManager:(id)manager
                      atIndexPath:(NSIndexPath *)indexPath
                     newIndexPath:(NSIndexPath *)newIndexPath
                    forChangeType:(TableViewIndexPathChangeType)type {
    NSLog(@"\n-----\n%@\n%@\n%@\n-----",@(type),indexPath,newIndexPath);
    switch(type) {
            
        case TableViewIndexPathChangeInsert:
            [_tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
            
        case TableViewIndexPathChangeDelete:
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case TableViewIndexPathChangeUpdate:
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case TableViewIndexPathChangeMove:
            [_tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }    
}


- (void)tableViewIndexPathDidChangeContent:(id)manager {
    [self.tableView endUpdates];
    
    self.tableView.backgroundView.hidden = self.tableManager.conversationDatas.count;
}



#pragma mark - ———— Response ———— -

- (void)pushToSessionWithConversation:(Y2WUserConversation *)conversation {
    
    [self.navigationItem startAnimating];
    
    [conversation getSessionDidCompletion:^(Y2WSession *session, NSError *error) {
        
        [self.navigationItem stopAnimating];
        
        if (error) {
            [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
            return;
        }
        
        ConversationViewController *conversationVC = [[ConversationViewController alloc] initWithSession:session];
        [self pushViewController:conversationVC];
    }];
}






#pragma mark - ———— getter ———— -

- (ConversationTableManager *)tableManager {
    if (!_tableManager) {
        _tableManager = [[ConversationTableManager alloc] init];
        _tableManager.delegate = self;
    }
    return _tableManager;
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