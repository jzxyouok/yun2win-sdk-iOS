//
//  SendMessageCheck.h
//  API
//
//  Created by ShingHo on 16/3/11.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusDefine.h"

@protocol SendMessageCheck <NSObject>

- (void)sendMessage:(ConnectionReturnCode)connectionReturnCode ;

@end
