//
//  EditSubViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EditSubViewController.h"
//#import "NetManager.h"
#import "UIView+Category.h"
#import "AFNetworkTool.h"

@interface EditSubViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    BOOL _success;
    NSDictionary *_cateDict;
}
@end

@implementation EditSubViewController
#define kTextFieldTag 123
#define KloadingViewTag 12345

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _cateDict = @{@"昵称":@"nickname",@"手机号":@"phone",@"邮箱":@"email"};
    
    self.title = [NSString stringWithFormat:@"%@编辑",[_dataDict objectForKey:@"Title"]];
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:215/255.0 green:0 blue:0 alpha:1];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastPage)];
    self.navigationItem.leftBarButtonItem = leftItem;
    // 右侧完成按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(alertFinished)];
    self.navigationItem.rightBarButtonItem = rightItem;

    UIView *alertBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    alertBackV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:alertBackV];
    
    UILabel *cateLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 30)];
    cateLab.text = [_dataDict objectForKey:@"Title"];
    cateLab.font = [UIFont systemFontOfSize:kOneFontSize];
    cateLab.textAlignment = NSTextAlignmentLeft;
    cateLab.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1];
    [alertBackV addSubview:cateLab];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(120, 5, kScreenWidth-140, 30)];
    textField.tag = kTextFieldTag;
    textField.font = [UIFont systemFontOfSize:kOneFontSize];
    textField.textColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1];
    textField.clearButtonMode=UITextFieldViewModeAlways;
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.delegate = self;
    textField.text = [_dataDict objectForKey:@"Content"];
    [alertBackV addSubview:textField];
}

#pragma mark - 返回上一页
- (void)backToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 修改提交
- (void)alertFinished
{
    // 修改完成
    UITextField *textField = (UITextField *)[self.view viewWithTag:kTextFieldTag];
    BOOL _commit = NO; // 是否提交
    // 先判断修改的信息格式是否正确
    if (_alterType == Telephone)
    {
        if ([textField.text length] == 11)
        {
//            NSLog(@"%@",textField.text);
            _commit = YES;
        }
        else
        {
            [self createAlertViewWithMessage:@"手机号必须是11位"];
        }
    }
    else if (_alterType == EMail)
    {
        if ([textField.text rangeOfString:@"@"].location != NSNotFound&&([textField.text hasSuffix:@"com"]||[textField.text hasSuffix:@"cn"]))
        {
            _commit = YES;
        }
        else
        {
            [self createAlertViewWithMessage:@"邮箱格式不正确"];
        }
    }
    
    // 格式正确后 提交服务端
    if (_commit)
    {
        NSArray *baseUrlArray = @[kAlterUserNameURL,kAlterTelephoneURL,kAlterEmailURL];
        NSArray *paramsArray = @[@"screenname",@"tel",@"email"];
        NSDictionary *paramDic = @{@"userid":_userID,[paramsArray objectAtIndex:_alterType]:textField.text};
        [self.view addLoadingViewInSuperView:self.view andTarget:self];
        [AFNetworkTool postJSONWithUrl:[baseUrlArray objectAtIndex:_alterType] parameters:paramDic success:^(id responseObject)
         {
             [self.view removeLoadingVIewInView:self.view andTarget:self];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             NSInteger respCode = [[dic objectForKey:@"respCode"] integerValue];
             if (respCode == 1000)
             {
                 // 成功
                 _success = YES;
                 [self createAlertViewWithMessage:[NSString stringWithFormat:@"%@修改成功",[_dataDict objectForKey:@"Title"]]];
                 [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:[_cateDict objectForKey:[_dataDict objectForKey:@"Title"]]];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
             else
             {
                 _success = NO;
                 [self createAlertViewWithMessage:[NSString stringWithFormat:@"%@修改失败",[_dataDict objectForKey:@"Title"]]];
             }
         } fail:^{
             [self.view removeLoadingVIewInView:self.view andTarget:self];
             [self createAlertViewWithMessage:@"找不到网络"];
         }];
    }
}

#pragma mark - 创建alertView
- (void)createAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:kTextFieldTag];
    if (_success)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate reloadNewInfoWithString:textField.text andAlterType:_alterType];
    }
}

#pragma mark - 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *textF = (UITextField *)[self.view viewWithTag:kTextFieldTag];
    [textF resignFirstResponder];
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
