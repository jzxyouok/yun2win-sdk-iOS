//
//  IMMessage.h
//  API
//
//  Created by ShingHo on 16/3/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Y2W_IM_SDK/Y2W_IM_SDK.h>

@interface IMMessage : NSObject<IMMessageProtocol>

//@property (nonatomic, copy) NSString *command;
//
//@property (nonatomic, copy) NSString *y2wMessageId;
//
//@property (nonatomic, assign) NSTimeInterval mts;
//
//@property (nonatomic, strong) id message;

//- (instancetype)initWithCommand:(NSString *)command Mts:(NSTimeInterval)mts Message:(id)message;

- (instancetype)initWithMts:(NSTimeInterval)mts Message:(id)message;

@end
