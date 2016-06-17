//
//  GroupVideoChatSideBarItemCell.h
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupVideoChatSideBarItem.h"

@protocol GroupVideoChatSideBarItemCellDelegate <NSObject>

-(void)onTapItem:(GroupVideoChatSideBarItem*)item;

@end

@interface GroupVideoChatSideBarItemCell : UITableViewCell

@property (nonatomic, weak) GroupVideoChatSideBarItem *item;

@property (nonatomic, weak) id<GroupVideoChatSideBarItemCellDelegate> delegate;

@end