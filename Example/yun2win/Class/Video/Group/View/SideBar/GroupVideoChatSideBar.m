//
//  GroupVideoChatSideBar.m
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "GroupVideoChatSideBar.h"
#import "GroupVideoChatSideBarItemCell.h"

@interface GroupVideoChatSideBar ()<UITableViewDelegate,UITableViewDataSource,GroupVideoChatSideBarItemCellDelegate>

@property (nonatomic, retain) UIButton *maskingButton;

@property (nonatomic, retain) UITableView *itemsView;

@end


@implementation GroupVideoChatSideBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.maskingButton];
        [self addSubview:self.itemsView];
        self.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.maskingButton.frame = self.bounds;
}



#pragma mark - ———— public ———— -

- (void)show {
    if ([self.delegate respondsToSelector:@selector(groupVideoChatSideBarWillShow)]) {
        [self.delegate groupVideoChatSideBarWillShow];
    }
    self.hidden = NO;
    
    self.itemsView.frame = CGRectMake(self.frame.size.width, 0, 72, self.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.itemsView.frame = CGRectMake(self.frame.size.width - 72, 0, 72, self.frame.size.height);
    }];
}

- (void)hide {
    if ([self.delegate respondsToSelector:@selector(groupVideoChatSideBarWillHide)]) {
        [self.delegate groupVideoChatSideBarWillHide];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.itemsView.frame = CGRectMake(self.frame.size.width, 0, 72, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)reloadData {
    [self.itemsView reloadData];
}










#pragma mark - ———— UITableViewDelegate ———— -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupVideoChatSideBarItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupVideoChatSideBarItemCell class]) forIndexPath:indexPath];
    
    cell.item = self.items[indexPath.section];
    cell.delegate = self;
    
    return cell;
}





#pragma mark - ———— GroupVideoChatSideBarItemCellDelegate ———— -

- (void)groupVideoChatSideBarItemCell:(GroupVideoChatSideBarItemCell *)cell buttonClickItem:(GroupVideoChatSideBarItem *)item {
    if (!item) return;

    if ([self.delegate respondsToSelector:@selector(groupVideoChatSideBar:didSelectItem:)]) {
        [self.delegate groupVideoChatSideBar:self didSelectItem:item];
    }
    
    [self reloadData];
}










#pragma mark - ———— getter ———— -

- (UIButton *)maskingButton {
    if (!_maskingButton) {
        _maskingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maskingButton addTarget:self action:@selector(hide) forControlEvents:1<<6];
    }
    return _maskingButton;
}

- (UITableView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 72, self.frame.size.height) style:UITableViewStyleGrouped];
        _itemsView.canCancelContentTouches = NO;
        _itemsView.delaysContentTouches = NO;
        _itemsView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _itemsView.showsVerticalScrollIndicator = NO;
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.frame = CGRectMake(0, 0, 72, self.frame.size.height);
        effectView.alpha = 0.3;
        _itemsView.backgroundView = effectView;
        _itemsView.backgroundColor = [UIColor clearColor];

        _itemsView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _itemsView.sectionHeaderHeight = 5;
        _itemsView.sectionFooterHeight = 5;
        _itemsView.rowHeight = 80;
        _itemsView.delegate = self;
        _itemsView.dataSource = self;
        
        [_itemsView registerClass:[GroupVideoChatSideBarItemCell class]
           forCellReuseIdentifier:NSStringFromClass([GroupVideoChatSideBarItemCell class])];
    }
    return _itemsView;
}

@end
