//
//  MessageCellModelInterface.h
//  API
//
//  Created by QS on 16/3/17.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@protocol MessageCellModelInterface <NSObject>

- (void)refreshData:(MessageModel *)data;

@end
