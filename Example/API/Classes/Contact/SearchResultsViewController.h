//
//  SearchResultsViewController.h
//  API
//
//  Created by ShingHo on 16/4/27.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController<UISearchResultsUpdating>

@property (nonatomic, strong) Y2WContacts *contacts;

@property (nonatomic, strong) Y2WSession *session;

@property (nonatomic, strong) Y2WSessionMembers *sessionMembers;
@end
