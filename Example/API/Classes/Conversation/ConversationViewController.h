//
//  ConversationViewController.h
//  API
//
//  Created by ShingHo on 16/1/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y2WUserConversation.h"
#import "MessageCellDelegate.h"

@interface ConversationViewController : UIViewController<Y2WMessagesDelegate>

- (instancetype)initWithSession:(Y2WSession *)session;

@end