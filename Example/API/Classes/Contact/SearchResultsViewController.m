//
//  SearchResultsViewController.m
//  API
//
//  Created by ShingHo on 16/4/27.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "ConversationViewController.h"
#import "MemberModelCell.h"
#import "ContactModel.h"
#import "SessionMemberModel.h"

@interface SearchResultsViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchList;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.searchList removeAllObjects];
    if (self.contacts) {
        NSArray *tempContacts = [self.contacts getContactWithKey:searchController.searchBar.text];
        for (Y2WContact *contact in tempContacts) {
            ContactModel *model = [[ContactModel alloc]initWithContact:contact];
            [self.searchList addObject:model];
        }
    }
    else if(self.sessionMembers)
    {
        NSArray *tempMembers = [self.sessionMembers getMembersWithKey:searchController.searchBar.text];
        for (Y2WSessionMember *member in tempMembers) {
            SessionMemberModel *model = [[SessionMemberModel alloc]initWithSessionMember:member];
            [self.searchList addObject:model];
        }
    }
    
    
    [self.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate


#pragma mrk - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberModelCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MemberModelCell class])];
    cell.model = self.searchList[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSObject<MemberModelInterface> *model = self.searchList[indexPath.row];
    
    if ([model isKindOfClass:[ContactModel class]]) {
        Y2WContact *contact = [(ContactModel *)model contact];
        [self pushToSessionWithContact:contact];
    }
    if ([model isKindOfClass:[SessionMemberModel class]]) {
//        Y2WContact *contact = [(ContactModel *)model contact];
//        [self pushToSessionWithContact:contact];
    }
}

#pragma mark - Helper
- (void)pushToSessionWithContact:(Y2WContact *)contact {
    
    [contact getSessionDidCompletion:^(Y2WSession *session, NSError *error) {
        
        if (error) {
            [UIAlertView showTitle:@"错误" message:error.description];
            return;
        }
        ConversationViewController *conversationVC = [[ConversationViewController alloc] initWithSession:session];
        conversationVC.hidesBottomBarWhenPushed = YES;
        [self.presentingViewController pushViewController:conversationVC animated:YES];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    }];
}

#pragma mark - Setter and Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -45, self.view.width, self.view.height) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MemberModelCell class] forCellReuseIdentifier:NSStringFromClass([MemberModelCell class])];
        [self.view addSubview:_tableView];

    }
    return _tableView;
}

- (NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
