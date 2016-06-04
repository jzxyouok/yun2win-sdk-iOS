//
//  SessionsInfoChangedViewController.m
//  API
//
//  Created by ShingHo on 16/4/27.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "SessionsInfoChangedViewController.h"
#import "Y2WUserSession.h"
@interface SessionsInfoChangedViewController ()

@property (nonatomic, strong) Y2WSession *session;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UITextField *textFiled;

@end

@implementation SessionsInfoChangedViewController

- (instancetype)initWithUserSession:(Y2WSession *)session changedType:(NSString *)type
{
    self = [super init];
    if (self) {
        self.session = session;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavItem];
    self.view.backgroundColor = [UIColor colorWithHexString:@"DAEBEB"];
    [self.view addSubview:self.textFiled];

}

- (void)setUpNavItem{
    self.navigationItem.title = @"群名称";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_返回"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_加号"] style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}

#pragma mark - ———— Response ———— -

- (void)save {
    [self.session.sessions.remote updateWithName:self.textFiled.text type:nil secureType:nil avatarUrl:nil session:self.session success:^(Y2WSession *session) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.top = 80;
        _textView.left = 20;
        _textView.right = self.view.width - 20;
        _textView.height = 50;
    }
    return _textView;
}

- (UITextField *)textFiled
{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, self.view.width-40, 50)];
        _textFiled.backgroundColor = [UIColor whiteColor];
//        _textFiled.top = 100;
//        _textFiled.left = 100;
//        _textFiled.right = 200;
//        _textFiled.height = 50;
        _textFiled.text = self.session.name;
    }
    return _textFiled;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
