//
//  InputViewProtocol.h
//  API
//
//  Created by QS on 16/3/15.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MoreItem.h"

@class InputView;
@protocol InputViewUIDelegate <NSObject>

- (void)inputView:(InputView *)inputView didChangeTop:(CGFloat)top;
- (void)inputView:(InputView *)inputView showKeyboard:(CGFloat)show;

@end

@protocol InputViewActionDelegate <NSObject>

- (void)inputView:(InputView *)inputView onSendText:(NSString *)text;

- (void)inputView:(InputView *)inputView onSendVoice:(NSString *)voicePath time:(NSInteger)timer;
@end

@protocol InputViewMoreDelegate <NSObject>

- (void)moreInputViewDidSelectItem:(MoreItem *)item;

@end
