//
//  MessageBubbleInterface.h
//  API
//
//  Created by QS on 16/3/16.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageCellModelInterface.h"

@protocol MessageBubbleInterface <MessageCellModelInterface>

+ (instancetype)create;

@end
