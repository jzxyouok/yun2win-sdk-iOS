//
//  MessageFileBubbleView.m
//  API
//
//  Created by ShingHo on 16/4/15.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "MessageFileBubbleView.h"
#import "Y2WFileMessage.h"

@interface MessageFileBubbleView ()
@property (nonatomic, retain) MessageModel *model;

@property (nonatomic, strong) UIImageView *fileIcon;
//
@property (nonatomic, strong) UILabel *fileNameLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, retain) NSMutableDictionary *bubbleImages;

@end

@implementation MessageFileBubbleView

+ (instancetype)create {
    MessageFileBubbleView *view = [super buttonWithType:UIButtonTypeCustom];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 15;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    
    view.fileIcon = [[UIImageView alloc]init];
    view.fileIcon.left = 10;
    view.fileIcon.top = 10;
    view.fileIcon.height = 50;
    view.fileIcon.width = 50;
    [view addSubview:view.fileIcon];
    
    view.fileNameLabel = [[UILabel alloc]init];
    view.subTitleLabel.textAlignment = NSTextAlignmentLeft;
    view.fileNameLabel.left = 70;
    view.fileNameLabel.top = 10;
    view.fileNameLabel.height = 40;
    view.fileNameLabel.width = 170;
    view.fileNameLabel.numberOfLines = 3;
    view.fileNameLabel.font = [UIFont boldSystemFontOfSize:14];
    view.fileNameLabel.textColor = [UIColor colorWithHexString:@"353535"];
    [view addSubview:view.fileNameLabel];

    view.subTitleLabel = [[UILabel alloc]init];
    view.subTitleLabel.textAlignment = NSTextAlignmentRight;
    view.subTitleLabel.font = [UIFont systemFontOfSize:12];
    view.subTitleLabel.textColor = [UIColor colorWithRed:53/255 green:53/255 blue:53/255 alpha:0.5];
    view.subTitleLabel.top = 50;
    view.subTitleLabel.right = 190;
    view.subTitleLabel.height = 15;
    view.subTitleLabel.width = 50;
    [view addSubview:view.subTitleLabel];
    
//    view.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
//    view.progressView.trackTintColor = [UIColor whiteColor];
//    view.progressView.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
//    view.progressView.tintColor = [UIColor colorWithHexString:@"#ffc950"];
//    view.progressView.layer.masksToBounds = YES;
//    view.progressView.layer.borderWidth = 0.5;
//    view.progressView.layer.borderColor = [UIColor colorWithHexString:@"@c8c8c8c"].CGColor;
//    view.progressView.left = 10;
//    view.progressView.right = view.width - 10;
//    view.progressView.height = 5;
//    view.progressView.bottom = view.height - 5;
//    [view addSubview:view.progressView];

    return view;
}



- (void)refreshData:(MessageModel *)data {
    _model = data;
    Y2WBaseMessage *temp_message = _model.message;
    Y2WFileMessage *message = (Y2WFileMessage *)temp_message;

    if (_model.isMe) {
        self.backgroundColor = [UIColor colorWithHexString:@"6ce5dc"];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    
    self.fileIcon.image = [self distinguishFileIcon:message.content[@"name"]];
    self.fileNameLabel.text = message.content[@"name"];
    if ([message.filePath isKindOfClass:[NSString class]]) {
        if (!message.filePath.length) self.subTitleLabel.text = @"未下载";
        else    self.subTitleLabel.text = @"已下载";
    }

}

- (UIImage *)chatBubbleImageForState:(UIControlState)state outgoing:(BOOL)outgoing{
    if (!_bubbleImages) _bubbleImages = [NSMutableDictionary dictionary];
    
    if (outgoing) {
        if (state == UIControlStateNormal)
        {
            UIImage *image = _bubbleImages[@"本方气泡-默认"];
            if (!image) {
                
                image = [[UIImage imageNamed:@"本方气泡-默认"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,15,14,22) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"本方气泡-默认"] = image;
            }
            return image;
            
        }else if (state == UIControlStateHighlighted)
        {
            UIImage *image = _bubbleImages[@"本方气泡-按下"];
            if (!image) {
                
                image = [[UIImage imageNamed:@"本方气泡-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,15,14,22) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"本方气泡-按下"] = image;
            }
            return image;
        }
        
    }else {
        if (state == UIControlStateNormal) {
            
            UIImage *image = _bubbleImages[@"对方气泡-默认"];
            if (!image) {
                
                image = [[UIImage imageNamed:@"对方气泡-默认"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,22,14,15) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"对方气泡-默认"] = image;
            }
            return image;
            
        }else if (state == UIControlStateHighlighted) {
            
            UIImage *image = _bubbleImages[@"对方气泡-按下"];
            if (!image) {
                
                image = [[UIImage imageNamed:@"对方气泡-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(14,22,14,15) resizingMode:UIImageResizingModeStretch];
                
                _bubbleImages[@"对方气泡-按下"] = image;
            }
            return image;
        }
    }
    return nil;
}

#pragma mark - Helper
- (UIImage *)distinguishFileIcon:(NSString *)title
{
    NSString *suffixString = [title pathExtension];
    if ([suffixString isEqualToString:@"jpeg"] ||
        [suffixString isEqualToString:@"png"] ||
        [suffixString isEqualToString:@"jpg"]) {
        return [UIImage imageNamed:@"File_image"];
    }
    if([suffixString isEqualToString:@"mp3"]){
        return [UIImage imageNamed:@"File_audio"];
    }
    if ([suffixString isEqualToString:@"mp4"]) {
        return [UIImage imageNamed:@"File_video"];
    }
    if ([suffixString isEqualToString:@"doc"] || [suffixString isEqualToString:@"docx"]) {
        return [UIImage imageNamed:@"File_doc"];
    }
    if ([suffixString isEqualToString:@"xls"] || [suffixString isEqualToString:@"xlsx"]) {
        return [UIImage imageNamed:@"File_xls"];
    }
    if ([suffixString isEqualToString:@"ppt"] || [suffixString isEqualToString:@"pptx"]) {
        return [UIImage imageNamed:@"File_ppt"];
    }
    if ([suffixString isEqualToString:@"pdf"]) {
        return [UIImage imageNamed:@"File_pdf"];
    }
    return [UIImage imageNamed:@"File_unknow"];
}

@end
