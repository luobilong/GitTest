//
//  LoginViewController.h
//  labonline
//
//  Created by 引领科技 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"
#import "AFNetworkTool.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (strong,nonatomic) YRSideViewController *sideViewController;

- (IBAction)doLogin:(id)sender;
- (IBAction)doRegister:(id)sender;

@end
