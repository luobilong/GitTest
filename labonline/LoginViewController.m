//
//  LoginViewController.m
//  labonline
//
//  Created by 引领科技 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "LoginViewController.h"
#import "LeftViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        self = [storyboard instantiateViewControllerWithIdentifier:@"loginV"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userNameTxt.delegate=self;
    _passwordTxt.delegate=self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doLogin:(id)sender {
    NSString *username=_userNameTxt.text;
    NSString *password=_passwordTxt.text;
//    UserModel *um=[[UserModel alloc] init];
    
    NSString *loginUrl=[COCIM_INTERFACE_LOGIN stringByAppendingFormat:@"?username=%@&password=%@",username,password];
//    NSLog(@"%@",loginUrl);
    [AFNetworkTool netWorkStatus];
    [AFNetworkTool JSONDataWithUrl:loginUrl success:^(id json) {
        int respCode=[[json objectForKey:@"respCode"] intValue];
        if (respCode==1000) {
//            NSDictionary *data=[[json objectForKey:@"userinfo"] objectAtIndex:0];
//            
//            [um setValuesForKeysWithDictionary:data];
//            NSLog(@"%@",um);
            NSArray *keyArray = @[@"id",@"nickname",@"phone",@"email",@"icon"];
            NSDictionary *userInfo = [[json objectForKey:@"userinfo"] lastObject];
//            NSLog(@"%@",userInfo);
            NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
            [userDe setObject:username forKey:@"userName"];
            [userDe setObject:password forKey:@"password"];
            for (NSString *keys in keyArray)
            {
                if (![[userInfo objectForKey:keys] isEqual:[NSNull null]])
                {
                    [userDe setObject:[userInfo objectForKey:keys] forKey:keys];
                }
            }
            [userDe synchronize];
            
//            [self presentViewController:_sideViewController animated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"登录" message:@"用户名密码错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        // 提示:NSURLConnection异步方法回调,是在子线程
        // 得到回调之后,通常更新UI,是在主线程
        //        NSLog(@"%@", [NSThread currentThread]);
    } fail:^{
//        NSLog(@"请求失败");
    }];
    
    
}

- (IBAction)doRegister:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    RegisterViewController *reVC=[[RegisterViewController alloc] initWithNibName:nil bundle:nil];
//    [self presentViewController:reVC animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    _userNameTxt.text=@"";
    _passwordTxt.text=@"";
}
@end
