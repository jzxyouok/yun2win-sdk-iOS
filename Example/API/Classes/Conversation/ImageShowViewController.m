    //
//  ImageShowViewController.m
//  API
//
//  Created by ShingHo on 16/6/27.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ImageShowViewController.h"

@interface ImageShowViewController ()

@property (nonatomic, strong) Y2WImageMessage *message;

@property (nonatomic, strong) UIImageView *imgView;

@end

static BOOL isShow = NO;

@implementation ImageShowViewController

- (instancetype)initWithMessage:(Y2WImageMessage *)message
{
    if (self = [super init]) {
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图片展示";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_返回"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.imgView.image = [self imageForPath:self.message.imagePath];

}

#pragma mark - reponder
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIImage *)imageForPath:(NSString *)path
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

#pragma mark - Setter And Getter

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64);
        [self.view addSubview:_imgView];

    }
    return _imgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
