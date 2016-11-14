//
//  GroupVideoChatSideBarItemCell.m
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "GroupVideoChatSideBarItemCell.h"



@interface GroupVideoChatSideBarItemCell()

@property (nonatomic, retain) UIButton *imageButton;

@end


@implementation GroupVideoChatSideBarItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageButton];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageButton.frame = CGRectMake((self.frame.size.width - 50)/2, 0, 50, 50);
    self.textLabel.frame = CGRectMake(0, 50, self.frame.size.width, 20);
}




#pragma mark - ———— public ———— -

- (void)setItem:(GroupVideoChatSideBarItem *)item {
    _item = item;
    
    [self.imageButton setImage:_item.image forState:UIControlStateNormal];
    [self.imageButton setImage:_item.selectedImage forState:UIControlStateSelected];
    
    self.imageButton.selected = _item.selected;
    self.textLabel.text = _item.selected ? _item.selectedTitle : _item.title;
}







- (void)buttonClick {
    if ([self.delegate respondsToSelector:@selector(groupVideoChatSideBarItemCell:buttonClickItem:)]) {
        [self.delegate groupVideoChatSideBarItemCell:self buttonClickItem:self.item];
    }
}


#pragma mark - ———— getter ———— -

- (UIButton *)imageButton {
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageButton addTarget:self action:@selector(buttonClick) forControlEvents:1<<6];
    }
    return _imageButton;
}

@end
