//
//  LoginViewController.h
//  API
//
//  Created by ShingHo on 16/1/18.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginWithAccount:(NSString *)account password:(NSString *)password;

@end


@interface LoginViewController : UIViewController

@end
