//
//  IMClientProtocol.h
//  API
//
//  Created by ShingHo on 16/3/29.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMSessionProtocol <NSObject>

@property (nonatomic, copy) NSString *imSessionId;

@property (nonatomic, assign) NSTimeInterval mts;

@end

@protocol IMMessageProtocol <NSObject>

@property (nonatomic, copy) NSString *y2wMessageId;

@property (nonatomic, assign) NSTimeInterval mts;

@property (nonatomic, strong) id message;

@end