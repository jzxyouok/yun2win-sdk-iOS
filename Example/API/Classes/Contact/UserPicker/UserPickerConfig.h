//
//  UserPickerConfig.h
//  API
//
//  Created by QS on 16/3/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, UserPickerType) {
    UserPickerTypeContact,
};


@protocol UserPickerConfig <NSObject>

@optional

/**
 *  默认已经勾选的人或群组
 */
@property (nonatomic, retain) NSArray *alreadySelectedMemberIds;

/**
 *  需要过滤的人或群组id
 */
@property (nonatomic, retain) NSArray *filterIds;


/**
 *  联系人选择器中的数据源类型
 */
- (UserPickerType)type;

/**
 *  联系人选择器标题
 */
- (NSString *)title;

/**
 *  是否允许多选
 *
 *  @return 是否
 */
- (BOOL)allowsMultipleSelection;

/**
 *  最多选择的人数
 */
- (NSInteger)maxSelectedNum;

/**
 *  超过最多选择人数时的提示
 */
- (NSString *)selectedOverFlowTip;

@end
