//
//  FileModel.m
//  API
//
//  Created by ShingHo on 16/4/26.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

- (instancetype)initWithFileTitle:(NSString *)title FilePath:(NSString *)path
{
    if (self = [super init]) {
        self.title = title;
        self.type = [self distinguishFileType:[title pathExtension]];
        self.typeImage = [self distinguishFileImage:self.type];
        self.path = path;
    }
    return self;
}

- (FileType)distinguishFileType:(NSString *)suffixString
{
    if ([suffixString isEqualToString:@"jpeg"] ||
        [suffixString isEqualToString:@"png"] ||
        [suffixString isEqualToString:@"jpg"]) {
        return Image_FileType;
    }
    if([suffixString isEqualToString:@"mp3"]){
        return Audio_FileType;
    }
    if ([suffixString isEqualToString:@"mp4"]) {
        return Video_FileType;
    }
    if ([suffixString isEqualToString:@"doc"] || [suffixString isEqualToString:@"docx"]) {
        return DOC_FileType;
    }
    if ([suffixString isEqualToString:@"xls"] || [suffixString isEqualToString:@"xlsx"]) {
        return XLS_FileType;
    }
    if ([suffixString isEqualToString:@"ppt"] || [suffixString isEqualToString:@"pptx"]) {
        return PPT_FileType;
    }
    if ([suffixString isEqualToString:@"pdf"]) {
        return DOC_FileType;
    }
    return File_FileType;
}

- (UIImage *)distinguishFileImage:(FileType)type
{
    switch (type) {
        case Image_FileType:
            return [UIImage imageNamed:@"File_image"];
        case Audio_FileType:
            return [UIImage imageNamed:@"File_audio"];
        case Video_FileType:
            return [UIImage imageNamed:@"File_video"];
        case DOC_FileType:
            return [UIImage imageNamed:@"File_doc"];
        case XLS_FileType:
            return [UIImage imageNamed:@"File_xls"];
        case PPT_FileType:
            return [UIImage imageNamed:@"File_ppt"];
        case PDF_FileType:
            return [UIImage imageNamed:@"File_pdf"];
        default:
            return [UIImage imageNamed:@"File_unknow"];
    }
}

@end
