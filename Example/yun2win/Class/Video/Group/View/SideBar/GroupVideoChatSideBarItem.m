//
//  GroupVideoChatSideBarItem.m
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "GroupVideoChatSideBarItem.h"

@implementation GroupVideoChatSideBarItem



- (NSString *)selectedTitle {
    if (_selectedTitle)
        return _selectedTitle;
    
    return _title;
}

- (UIImage *)selectedImage {
    if (!_selectedImage)
        return _selectedImage;
 
    return _selectedImage;
}

@end
