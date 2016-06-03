//
//  FileModel.h
//  API
//
//  Created by ShingHo on 16/4/26.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,FileType) {
    Image_FileType = 1,
    Audio_FileType = 2,
    Video_FileType = 3,
    DOC_FileType = 4,
    XLS_FileType = 5,
    PPT_FileType = 6,
    PDF_FileType = 7,
    File_FileType
};

@interface FileModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) FileType type;

@property (nonatomic, strong) UIImage *typeImage;

@property (nonatomic, copy) NSString *path;

- (instancetype)initWithFileTitle:(NSString *)title FilePath:(NSString *)path;

- (FileType)distinguishFileType:(NSString *)suffixString;

- (UIImage *)distinguishFileImage:(FileType)type;

@end
