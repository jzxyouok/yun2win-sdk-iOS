//
//  GroupVideoChatSideBarItemCell.h
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupVideoChatSideBarItem.h"

@class GroupVideoChatSideBarItemCell;
@protocol GroupVideoChatSideBarItemCellDelegate <NSObject>

- (void)groupVideoChatSideBarItemCell:(GroupVideoChatSideBarItemCell *)cell buttonClickItem:(GroupVideoChatSideBarItem *)item;

@end

@interface GroupVideoChatSideBarItemCell : UITableViewCell

@property (nonatomic, assign) id<GroupVideoChatSideBarItemCellDelegate>delegate;

@property (nonatomic, weak) GroupVideoChatSideBarItem *item;

@end