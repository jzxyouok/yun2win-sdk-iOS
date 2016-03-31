//
//  InputView.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "InputView.h"

@interface InputView ()<UITextViewDelegate>

@end
@implementation InputView {
    CGFloat keyBoardHeight;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textView];
        [self addSubview:self.moreBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.width = self.superview.width;
    self.moreBtn.right = self.width;
    [self layoutTextView];
    
    self.bottom = self.superview.height - keyBoardHeight;
}


- (void)layoutTextView {
    if (!self.needShowTextView) {
        self.textView.hidden = YES;
        return;
    }
    
    self.textView.width = self.moreBtn.left - self.textView.left;
    self.textView.left = self.textView.top = 5;
    self.textView.height = self.height - 10;

//    self.textView.height = [self.textView sizeThatFits:CGSizeMake(self.textView.width, 100)].height;
//    
//    height = self.textView.height + 10;
}



#pragma mark - ———— Helper ———— -

- (BOOL)needShowTextView {
    return YES;
}



#pragma mark - ———— UITextViewDelegate ———— -

- (void)textViewDidChange:(UITextView *)textView {
    [self setNeedsLayout];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![@"\n" isEqualToString:text]) return YES;
    if (!textView.text.length) return NO;

    if ([self.ActionDelegate respondsToSelector:@selector(inputView:onSendText:)]) {
        [self.ActionDelegate inputView:self onSendText:textView.text];
        
        textView.text = @"";
        [textView deleteBackward];
    }
    
    return NO;
}




#pragma mark - ———— UIKeyboardNotification ———— -

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (!self.window) return;//如果当前vc不是堆栈的top vc，则不需要监听

    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        
        if (beginFrame.origin.y > endFrame.origin.y) {
//            [self.UIDelegate inputView:self showKeyboard:YES];

//            self.top -= endFrame.size.height;

        }else {
//            [self.UIDelegate inputView:self showKeyboard:NO];

//            self.top += endFrame.size.height;
        }

//        self.top = endFrame.origin.y - self.height;
//        self.top -= (beginFrame.origin.y - endFrame.origin.y);
//        [self.UIDelegate inputView:self didChangeTop:self.top];
        
    } completion:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.window) return;

    [self.UIDelegate inputView:self showKeyboard:YES];

    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    keyBoardHeight = endFrame.size.height;
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.bottom = self.superview.height - keyBoardHeight;
        [self.UIDelegate inputView:self didChangeTop:self.top];

    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.UIDelegate inputView:self showKeyboard:NO];
    
    NSDictionary *userInfo = notification.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    keyBoardHeight = 0;
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.bottom = self.superview.height - keyBoardHeight;
        [self.UIDelegate inputView:self didChangeTop:self.top];
        
    } completion:nil];
}


- (BOOL)endEditing:(BOOL)force {
    BOOL sForce = [super endEditing:force];
    
    if ([self.textView isFirstResponder]) {
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
        [self.textView resignFirstResponder];
    }
    return sForce;
}



#pragma mark - ———— Response ———— -

- (void)showMoreInput:(UIButton *)button {
    button.selected = !button.isSelected;
    
    self.textView.inputView = button.isSelected ? self.moreInputView : nil;
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}




#pragma mark - ———— setter ———— -

- (void)setMoreDelegate:(id<InputViewMoreDelegate>)MoreDelegate {
    self.moreInputView.delegate = MoreDelegate;
}




#pragma mark - ———— getter ———— -

- (InputTextView *)textView {
    if (!_textView) {
        _textView = [[InputTextView alloc] init];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        _textView.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
        _textView.layer.borderWidth = 1;
    }
    return _textView;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"输入框-更多-默认"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"输入框-更多-按下"] forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(showMoreInput:) forControlEvents:1<<6];
        _moreBtn.width = _moreBtn.height = self.height;
    }
    return _moreBtn;
}

- (MoreInputView *)moreInputView {
    if (!_moreInputView) {
        _moreInputView = [[MoreInputView alloc] initWithFrame:CGRectMake(0, 0, self.width, 195)];
    }
    return _moreInputView;
}

@end
