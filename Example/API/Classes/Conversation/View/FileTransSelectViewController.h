//
//  FileTransSelectViewController.h
//  API
//
//  Created by ShingHo on 16/4/26.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileModel;
@protocol FileTransSelectViewControllerDelegate <NSObject>

- (void)sendFileModel:(FileModel *)model;

@end

@interface FileTransSelectViewController : UIViewController

@property (nonatomic, weak) id<FileTransSelectViewControllerDelegate> delegate;

@end
