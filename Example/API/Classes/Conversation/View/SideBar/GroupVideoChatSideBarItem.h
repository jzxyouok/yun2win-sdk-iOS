//
//  GroupVideoChatSideBarItem.h
//  Y2W_RTC
//
//  Created by QS on 16/5/9.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ItemType) {
    Item_hangup = 101,
    Item_mute,
    Item_speaker,
    Item_video,
    Item_changeCamera,
    Item_addMember
};

@interface GroupVideoChatSideBarItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *selectedTitle;

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) UIImage *selectedImage;

@property (nonatomic, retain) UIImage *highlightedImage;


@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) ItemType itemType;

@end