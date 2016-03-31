//
//  SortAndGroup.h
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SortAndGroup <NSObject>
@optional
@property (nonatomic, copy) NSString *groupTitle;

@property (nonatomic, copy) NSString *sortKey;

@end
