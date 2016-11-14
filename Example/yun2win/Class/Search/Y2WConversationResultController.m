//
//  Y2WConversationResultController.m
//  API
//
//  Created by QS on 16/8/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WConversationResultController.h"
#import "ConversationViewController.h"
#import "ConversationListCell.h"

@interface Y2WConversationResultController ()

@property (nonatomic, retain) NSArray *results;

@property (nonatomic, retain) dispatch_queue_t queue;

@end

@implementation Y2WConversationResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = dispatch_queue_create("Y2WConversationResultController", DISPATCH_QUEUE_SERIAL);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[ConversationListCell class] forCellReuseIdentifier:NSStringFromClass([ConversationListCell class])];
}




- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.results = nil;
    [self.tableView reloadData];
    NSString *text = searchController.searchBar.text;
    if (!text.length) {
        return;
    }
    
    dispatch_async(self.queue, ^{
        NSMutableArray *results = [NSMutableArray array];
        
        Y2WCurrentUser *user = [Y2WUsers getInstance].getCurrentUser;
        
        // 消息
        RLMResults *messageBases = [MessageBase objectsInRealm:user.realm where:@"searchText CONTAINS[c] %@",text];
        messageBases = [messageBases sortedResultsUsingDescriptors:@[[RLMSortDescriptor sortDescriptorWithProperty:@"createdAt" ascending:NO]]];
        for (MessageBase *base in messageBases) {
            Y2WSearchReslutModel *model = [[Y2WSearchReslutModel alloc] initWithUserMessageBase:base searchText:text];
            if (model) {
                [results addObject:model];
            }
        }
        
        // 会话
        NSArray *userConversations = [user.userConversations getUserConversations];
        for (Y2WUserConversation *userConversation in userConversations) {
            if ([self modelByTargetId:userConversation.targetId type:userConversation.type]) {
                continue;
            }
            if ([userConversation.name findValue:text].count || [userConversation.text findValue:text].count) {
                [results addObject:[[Y2WSearchReslutModel alloc] initWithUserConversation:userConversation searchText:text]];
            }
        }
        
        // 联系人
        NSArray *contacts = [user.contacts getContacts];
        for (Y2WContact *contact in contacts) {
            if ([self modelByTargetId:contact.userId type:@"p2p"]) {
                continue;
            }
            if ([contact.getName findValue:text].count) {
                [results addObject:[[Y2WSearchReslutModel alloc] initWithUserContact:contact searchText:text]];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.results = results;
            [self.tableView reloadData];
        });
    });
}



- (Y2WSearchReslutModel *)modelByTargetId:(NSString *)targetId type:(NSString *)type {
    for (Y2WSearchReslutModel *model in self.results.copy) {
        if ([model.targetId isEqualToString:targetId] && [model.type isEqualToString:type]) {
            return model;
        }
    }
    return nil;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ConversationListCell class]) forIndexPath:indexPath];
    
    cell.searchReslutModel = self.results[indexPath.row];

    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *results = self.results.copy;
    Y2WSearchReslutModel *searchReslutModel = results[indexPath.row];

    [[Y2WUsers getInstance].getCurrentUser.sessions getSessionWithTargetId:searchReslutModel.targetId type:searchReslutModel.type success:^(Y2WSession *session) {

        UINavigationController *navigationController = (UINavigationController *)self.presentingViewController;
        ConversationViewController *detailViewController = [[ConversationViewController alloc] initWithSession:session];
        [navigationController pushViewController:detailViewController animated:NO];
        [self dismissViewControllerAnimated:YES completion:^{
           
        }];
        
    } failure:^(NSError *error) {
        [UIAlertView showTitle:nil message:error.message];
    }];
}


@end
