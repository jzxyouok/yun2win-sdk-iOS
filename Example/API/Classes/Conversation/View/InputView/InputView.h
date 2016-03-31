//
//  InputView.h
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputViewProtocol.h"
#import "InputTextView.h"
#import "MoreInputView.h"


@interface InputView : UIView

@property (nonatomic, assign) id<InputViewUIDelegate> UIDelegate;
@property (nonatomic, assign) id<InputViewActionDelegate> ActionDelegate;
@property (nonatomic, assign) id<InputViewMoreDelegate> MoreDelegate;

@property (nonatomic, retain) InputTextView *textView;

@property (nonatomic, retain) UIButton *moreBtn;

@property (nonatomic, retain) MoreInputView *moreInputView;

@end
