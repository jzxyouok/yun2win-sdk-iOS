//
//  MemberInfoView.h
//  API
//
//  Created by ShingHo on 16/5/26.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberInfoView : UIImageView

@property (nonatomic, assign) BOOL videoMode;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, assign) BOOL isCalling;

@end
