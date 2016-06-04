//
//  InputToolbar.m
//  API
//
//  Created by ZakiHo on 16/1/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "InputToolbar.h"
#import "UIView+Y2W.h"

@interface InputToolbar()

@property (nonatomic,strong) UIView *sep;

@end

@implementation InputToolbar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];

        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon_toolview_voice_normal"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon_toolview_voice_pressed"] forState:UIControlStateHighlighted];
        [_voiceBtn sizeToFit];
        [self addSubview:_voiceBtn];
        
        
        _emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emoticonBtn setImage:[UIImage imageNamed:@"icon_toolview_emotion_normal"] forState:UIControlStateNormal];
        [_emoticonBtn setImage:[UIImage imageNamed:@"icon_toolview_emotion_pressed"] forState:UIControlStateHighlighted];
        [_emoticonBtn sizeToFit];
        [self addSubview:_emoticonBtn];
        
        _moreMediaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreMediaBtn setImage:[UIImage imageNamed:@"icon_toolview_add_normal"] forState:UIControlStateNormal];
        [_moreMediaBtn setImage:[UIImage imageNamed:@"icon_toolview_add_pressed"] forState:UIControlStateHighlighted];
        [_moreMediaBtn sizeToFit];
        [self addSubview:_moreMediaBtn];
        
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recordButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_recordButton setBackgroundImage:[[UIImage imageNamed:@"icon_input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_recordButton sizeToFit];
        [self addSubview:_recordButton];
        
        _inputTextBkgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_inputTextBkgImage setImage:[[UIImage imageNamed:@"icon_input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch]];
        [self addSubview:_inputTextBkgImage];
        
        _inputTextView = [[YtWInputTextView alloc] initWithFrame:CGRectZero];
        [self addSubview:_inputTextView];
        
        _sep = [[UIView alloc] initWithFrame:CGRectZero];
        _sep.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_sep];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGFloat height = 46.f;
    return CGSizeMake(size.width,height);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat spacing               = 6.f;
    CGFloat textViewMargin        = 2.f;
    //左边话筒按钮
    self.voiceBtn.y2w_left = spacing;
    self.voiceBtn.y2w_centerY     = self.y2w_height * .5f;
    //中间输入框按钮
    self.inputTextBkgImage.y2w_width = self.y2w_width - 5 * spacing - self.emoticonBtn.y2w_width - self.voiceBtn.y2w_width - self.moreMediaBtn.y2w_width;
    self.inputTextBkgImage.y2w_height = self.y2w_height - spacing * 2;
    self.inputTextBkgImage.y2w_left = self.voiceBtn.y2w_right + spacing;
    self.inputTextBkgImage.y2w_centerY = self.voiceBtn.y2w_centerY;
    self.inputTextView.frame = CGRectInset(self.inputTextBkgImage.frame, textViewMargin, textViewMargin);
    //中间点击录音按钮
    self.recordButton.frame    = self.inputTextBkgImage.frame;
    //右边表情按钮
    self.emoticonBtn.y2w_left     = self.recordButton.y2w_right + spacing;
    self.emoticonBtn.y2w_centerY  = self.y2w_height * .5f;
    //右边加号按钮
    self.moreMediaBtn.y2w_left    = self.emoticonBtn.y2w_right + spacing;
    self.moreMediaBtn.y2w_centerY = self.y2w_height * .5f;
    CGFloat sepHeight = .5f;
    //底部分割线
    _sep.y2w_size     = CGSizeMake(self.y2w_width, sepHeight);
    _sep.y2w_bottom   = self.y2w_height - sepHeight;
}


@end
