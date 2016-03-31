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

@property (weak, nonatomic) IBOutlet UITextField *psdTextField;

@property (weak, nonatomic) IBOutlet UITextField *VerifyPsdTextField;
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
    [self.psdTextField resignFirstResponder];
    [self.VerifyPsdTextField resignFirstResponder];
    return YES;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ok:(id)sender {

    [[Y2WUsers getInstance].remote registerWithAccount:self.accountTextField.text
                                              password:[self.psdTextField.text MD5Hash]
                                                  name:@"name"
                                               success:^{
                                                   
                                                   [UIAlertView showTitle:nil message:@"注册成功"];
                                                   [self.navigationController popViewControllerAnimated:YES];

                                             } failure:^(NSError *error) {
                                                 
                                                 [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
                                             }];
    
    Y2WCurrentUser *currentUser;
    

    /**
     *  创建一个用户群组管理对象，初始化并添加依赖
     */
    Y2WUserSessions *userSessions = [[Y2WUserSessions alloc] initWithCurrentUser:currentUser];
    Y2WUserSession *userSession;
    
//    [userSessions.remote addUserSession:<#(Y2WUserSession *)#> success:<#^(void)success#> failure:<#^(NSError *error)failure#>]
    
    
    /**
     *  取消收藏群组
     *
     * @param userSession: 要移除的群组对象
     */
    [userSessions.remote deleteUserSession:userSession success:^{
        
        // 删除成功
        
    } failure:^(NSError *error) {
       
        // 删除失败
    }];
}


- (BOOL)checkAccount{
    NSString *account = [self.accountTextField text];
    return account.length > 0 && account.length <= 20;
}

- (BOOL)checkNickname{
    NSString *nickname= [self.VerifyPsdTextField text];
    return nickname.length > 0 && nickname.length <= 10;
}

- (BOOL)checkPassword{
    NSString *checkPassword = [self.psdTextField text];
    return checkPassword.length >= 6 && checkPassword.length <= 20;
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
