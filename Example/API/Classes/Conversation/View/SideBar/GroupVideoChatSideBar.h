//
//  GroupVideoChatSideBar.h
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupVideoChatSideBarItem.h"

@class GroupVideoChatSideBarItem;

@protocol GroupVideoChatSideBarDelegate <NSObject>

- (void)onTapSideBarItem:(GroupVideoChatSideBarItem*)item;

@end

@interface GroupVideoChatSideBar : UIView

@property (nonatomic, retain) NSArray<GroupVideoChatSideBarItem *> *items;

@property (nonatomic, weak) id<GroupVideoChatSideBarDelegate> delegate;

@end



