//
//  GroupVideoChatSideBar.h
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupVideoChatSideBarItem.h"

@class GroupVideoChatSideBarItem,GroupVideoChatSideBar;

@protocol GroupVideoChatSideBarDelegate <NSObject>

- (void)groupVideoChatSideBar:(GroupVideoChatSideBar *)sidbar didSelectItem:(GroupVideoChatSideBarItem *)item;


- (void)groupVideoChatSideBarWillShow;

- (void)groupVideoChatSideBarWillHide;

@end





@interface GroupVideoChatSideBar : UIView

@property (nonatomic, assign) id<GroupVideoChatSideBarDelegate>delegate;

@property (nonatomic, retain) NSArray<GroupVideoChatSideBarItem *> *items;



- (void)reloadData;


- (void)show;
- (void)hide;

@end

