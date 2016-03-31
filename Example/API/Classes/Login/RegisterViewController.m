//
//  RegisterViewController.m
//  API
//
//  Created by ShingHo on 16/1/19.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "RegisterViewController.h"
#import "HttpRequest.h"
#import "URL.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *psdTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accountTextField resignFirstResponder];
    [self.nickNameTextField resignFirstResponder];
    [self.psdTextField resignFirstResponder];
    return YES;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ok:(id)sender {

    [[Y2WUsers getInstance].remote registerWithAccount:self.accountTextField.text
                                              password:self.psdTextField.text
                                                  name:self.nickNameTextField.text
                                               success:^{
                                                   [UIAlertView showTitle:nil message:@"注册成功"];

                                                   if ([self.delegate respondsToSelector:@selector(loginWithAccount:password:)]) {
                                                       [self.delegate loginWithAccount:self.accountTextField.text
                                                                              password:self.psdTextField.text];
                                                   }

                                             } failure:^(NSError *error) {
                                                 
                                                 [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
                                             }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
