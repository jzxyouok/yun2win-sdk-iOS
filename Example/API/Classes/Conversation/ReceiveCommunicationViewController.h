//
//  ReceiveCommunicationViewController.h
//  API
//
//  Created by ShingHo on 16/5/12.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCallModel.h"

@interface ReceiveCommunicationViewController : UIViewController

- (instancetype)initWithModel:(AVCallModel *)model IsSender:(BOOL)isSender;

@end
