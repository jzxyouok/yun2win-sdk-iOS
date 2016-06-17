//
//  Y2WFileMessage.h
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WBaseMessage.h"

@interface Y2WFileMessage : Y2WBaseMessage

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, strong) NSString *fileUrl;

@property (nonatomic, assign) NSInteger fileSize;

@end
