//
//  ConversationTableManager.h
//  API
//
//  Created by QS on 16/4/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewIndexPathChangeDelegate.h"

@interface ConversationTableManager : NSObject

@property (nonatomic, retain) NSMutableArray *conversationDatas;

@property (nonatomic, assign) id<TableViewIndexPathChangeDelegate>delegate;

@end
