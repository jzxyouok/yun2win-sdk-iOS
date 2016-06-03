//
//  InputView.h
//  API
//
//  Created by ZakiHo on 16/1/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, InputType){
    InputTypeText = 1,
    InputTypeEmotion = 2,
    InputTypeAudio = 3,
    InputTypeMedia = 4,
};

typedef NS_ENUM(NSInteger, AudioRecordPhase) {
    AudioRecordPhaseStart,
    AudioRecordPhaseRecording,
    AudioRecordPhaseCancelling,
    AudioRecordPhaseEnd
};


@protocol InputDelegate <NSObject>

@required
- (void)showInputView;
- (void)hideInputView;
- (void)inputViewSizeToHeight:(CGFloat)toHeight
                showInputView:(BOOL)show;
@end

@interface InputView : UIView

@property (assign, nonatomic, getter=isRecording) BOOL recording;

- (instancetype)initWithFrame:(CGRect)frame;

@end
