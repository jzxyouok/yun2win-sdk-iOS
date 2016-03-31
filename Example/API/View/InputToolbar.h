//
//  InputToolbar.h
//  API
//
//  Created by ZakiHo on 16/1/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YtWInputTextView.h"

@interface InputToolbar : UIView

@property (nonatomic,strong) UIButton    *voiceBtn;

@property (nonatomic,strong) UIButton    *emoticonBtn;

@property (nonatomic,strong) UIButton    *moreMediaBtn;

@property (nonatomic,strong) UIButton    *recordButton;

@property (nonatomic,strong) UIImageView *inputTextBkgImage;

@property (nonatomic,strong) YtWInputTextView *inputTextView;

@end
