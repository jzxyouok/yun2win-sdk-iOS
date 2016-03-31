//
//  LoginViewController.m
//  API
//
//  Created by ShingHo on 16/1/18.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainViewController.h"
#import "Y2WUser.h"
#import "Y2WCurrentUser.h"
#import "Y2WUsers.h"


@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UITextField *psdTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountTextField.delegate = self;
    self.psdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.psdTextField.secureTextEntry = YES;
    self.psdTextField.delegate = self;
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountTextField.text = @"qisong";
    self.psdTextField.text = @"123456";
    [self login];
}

- (IBAction)registration:(UIButton *)sender {

    RegisterViewController *re = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:re animated:YES];
}



- (void)login
{
    NSString *account = self.accountTextField.text;
    NSString *password = [self.psdTextField.text MD5Hash];
    
//    NSString *account = @"zhangsan";
//    NSString *password = @"123456";
    [[Y2WUsers getInstance].remote loginWithAccount:account
                                          password:password
                                           success:^(Y2WCurrentUser *currentUser) {
                                               
                                           } failure:^(NSError *error) {
                                               
                                           }];

    
    [[Y2WUsers getInstance].remote loginWithAccount:account password:password success:^(Y2WCurrentUser *currentUser) {
        
        MainViewController *main = [[MainViewController alloc]init];
        main.currentUser = currentUser;
        
        [[Y2WUsers getInstance].getCurrentUser.remote syncIMTokenDidCompletion:^(NSError *error) {
            
        }];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = main;
        
    } failure:^(NSError *error) {
  
        [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
    }];
}




#pragma mark - TextFieldDelegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.accountTextField resignFirstResponder];
    [self.psdTextField resignFirstResponder];
    return YES;
}

@end
