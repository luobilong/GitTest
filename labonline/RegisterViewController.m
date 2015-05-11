//
//  RegisterViewController.m
//  labonline
//
//  Created by 引领科技 on 15/4/7.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworkTool.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        self = [storyboard instantiateViewControllerWithIdentifier:@"registerV"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 添加手势 返回上一页
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToPrePage)];
    left.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:left];
}

- (void)backToPrePage
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)DoRegister:(id)sender {
    NSString *username=_username.text;
    NSString *password=_password.text;
    NSString *nickname=_nickName.text;
    NSString *phone=_phone.text;
    NSString *email=_email.text;

    if (username.length==0||password.length==0||nickname.length == 0||phone.length == 0||email.length == 0) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"登录" message:@"用户名密码不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"信息不完整" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else{
        NSString *loginUrl=[COCIM_INTERFACE_REG stringByAppendingFormat:@"?username=%@&password=%@&nickname=%@&phone=%@&email=%@",username,password,nickname,phone,email];
        [AFNetworkTool JSONDataWithUrl:loginUrl success:^(id json) {
            int respCode=[[json objectForKey:@"respCode"] intValue];
            if (respCode==1000) {
                //            NSDictionary *data=[[json objectForKey:@"userinfo"] objectAtIndex:0];
                //
                //            [um setValuesForKeysWithDictionary:data];
                //            NSLog(@"%@",um);
                NSDictionary *userInfo = [[json objectForKey:@"userinfo"] lastObject];
                NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
                [userDe setObject:username forKey:@"userName"];
                [userDe setObject:password forKey:@"password"];
                [userDe setObject:[userInfo objectForKey:@"id"] forKey:@"id"];
                [userDe setObject:[userInfo objectForKey:@"nickname"] forKey:@"nickname"];
                [userDe setObject:[userInfo objectForKey:@"phone"] forKey:@"phone"];
                [userDe setObject:[userInfo objectForKey:@"email"] forKey:@"email"];
                [userDe setObject:[userInfo objectForKey:@"icon"] forKey:@"icon"];
                [userDe synchronize];
                
                //            [self presentViewController:_sideViewController animated:YES completion:nil];
//                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([self respondsToSelector:@selector(presentingViewController)]) {//ios5
                    if (self.presentingViewController.presentingViewController) {//通过登录页面进入注册页面
                        [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
                    }else{//左侧菜单直接进入注册页面
                        [self.presentingViewController dismissModalViewControllerAnimated:YES];
                    }
                } else {//ios4
                    if (self.parentViewController.parentViewController) {
                        [self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
                    }else{
                        [self.parentViewController dismissModalViewControllerAnimated:YES];
                    }
                }
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"登录" message:@"用户名密码错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
            // 提示:NSURLConnection异步方法回调,是在子线程
            // 得到回调之后,通常更新UI,是在主线程
            //        NSLog(@"%@", [NSThread currentThread]);
        } fail:^{
//            NSLog(@"请求失败");
        }];
    }
}
@end
