//
//  TimeStampLabel.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "TimeStampLabel.h"

@interface TimeStampLabel ()
@property (nonatomic, retain) UILabel *label;
@end

@implementation TimeStampLabel

- (instancetype)init {

    if (self = [super init]) {
        _label = [[UILabel alloc] init];
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    [_label sizeToFit];
    _label.centerX = self.width/2;
}



- (void)setText:(NSString *)text {

    _text = [text copy];
    _label.text = _text;
    
    [self setNeedsLayout];
}
@end
