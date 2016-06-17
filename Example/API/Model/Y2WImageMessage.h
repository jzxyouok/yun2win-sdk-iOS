//
//  Y2WImageMessage.h
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WBaseMessage.h"

@interface Y2WImageMessage : Y2WBaseMessage

@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) NSString *thumImagePath;

@property (nonatomic, copy) NSString *thumImageUrl;



@end
