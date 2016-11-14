//
//  GroupVideoChatSideBarItem.h
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GroupVideoChatSideBarItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *selectedTitle;


@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) UIImage *selectedImage;


@property (nonatomic, assign) BOOL selected;

@end