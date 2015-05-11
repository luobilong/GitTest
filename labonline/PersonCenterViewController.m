//
//  PersonCenterViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/1.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PersonColumeView.h"
#import "MyCommentViewController.h"
#import "MyCollectionViewController.h"
#import "OffLIneVidioViewController.h"
#import "MyMagazineViewController.h"
#import "EditPersonViewController.h"
#import "MainViewController.h"
#import "YRSideViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SearchViewController.h"


@interface PersonCenterViewController ()<EditPersonViewControllerDelegate>
{
    NSMutableArray *_dataArray;
    NSString *_userId;
}
@end

@implementation PersonCenterViewController
#define kHeadImageBtnTag 1122
#define kUserNameLableTag 1123

#define kOutButtonTag 23
#define kPersonColumeViewTag 24

#define kImageBUttonHeight 80
#define kColumeHeight 40
#define kOutButtonHeight 35
#define kOUtButtonWidth 150


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 基本设置
    self.title = @"个人中心";
    self.view.backgroundColor =[UIColor whiteColor];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // 左侧返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 35, 36)];
    [button setBackgroundImage:[UIImage imageNamed:@"tubiao_04.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popToLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"aniu_09.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(enterSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 头像 本地获取头像和昵称
    UIButton *personImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [personImageButton setFrame:CGRectMake((kScreenWidth-kImageBUttonHeight)/2, 20, kImageBUttonHeight, kImageBUttonHeight)];
    personImageButton.tag = kHeadImageBtnTag;
    
    if ([defaults objectForKey:@"icon"]&&[[defaults objectForKey:@"icon"] hasPrefix:@"http"])
    {
        NSData *imageDa = [NSData dataWithContentsOfURL:[NSURL URLWithString:[defaults objectForKey:@"icon"]]];
        [personImageButton setBackgroundImage:[UIImage imageWithData:imageDa]  forState:UIControlStateNormal];
    }
    else
    {
        [personImageButton setBackgroundImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    }

    personImageButton.layer.masksToBounds = YES;
    personImageButton.layer.cornerRadius = kImageBUttonHeight/2;
    personImageButton.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
    personImageButton.layer.borderWidth = 1;
    [personImageButton addTarget:self action:@selector(enterPersonEditViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:personImageButton];
    
    // 用户名
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 20+kImageBUttonHeight, kScreenWidth-100, 30)];
    nameLable.tag = kUserNameLableTag;
    if ([defaults objectForKey:@"nickname"])
    {
        nameLable.text = [defaults objectForKey:@"nickname"];
    }
    else
    {
        nameLable.text = [defaults objectForKey:@"username"];
    }
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.textColor = [UIColor redColor];
    nameLable.font = [UIFont systemFontOfSize:kOneFontSize];
    [self.view addSubview:nameLable];
    
    // 构成数据
    [self makeUpData];
    // 栏目分类
    for (int i = 0; i < _dataArray.count; i ++)
    {
        PersonColumeView *personColumeV = [[PersonColumeView alloc]initWithFrame:CGRectMake(20, 60+kImageBUttonHeight+i*(kColumeHeight+10), kScreenWidth-40, kColumeHeight)];
        personColumeV.dataDict = [_dataArray objectAtIndex:i];
        personColumeV.currentViewIndex = i+kPersonColumeViewTag;
        personColumeV.target = self;
        personColumeV.action = @selector(enterSibColume:);
        [self.view addSubview:personColumeV];
    }
    
    // 退出按钮
    NSInteger outHeight = 60+kImageBUttonHeight+_dataArray.count*(kColumeHeight+10)+20;
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [outButton setFrame:CGRectMake((kScreenWidth - kOUtButtonWidth)/2, outHeight, kOUtButtonWidth, kOutButtonHeight)];
    [outButton setTitle:@"退出账号" forState:UIControlStateNormal];
    outButton.backgroundColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
    outButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    outButton.layer.masksToBounds = YES;
    outButton.layer.cornerRadius = kOutButtonHeight/2;
    outButton.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
    outButton.layer.borderWidth = 1;
    [outButton addTarget:self action:@selector(outCurrentUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outButton];
    
    if ([defaults objectForKey:@"id"])
    {
        _userId = [defaults objectForKey:@"id"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIButton *btn = (UIButton *)[self.view viewWithTag:kHeadImageBtnTag];
    if ([defaults objectForKey:@"icon"]&&[[defaults objectForKey:@"icon"] hasPrefix:@"http"])
    {
        NSData *imageDa = [NSData dataWithContentsOfURL:[NSURL URLWithString:[defaults objectForKey:@"icon"]]];
        [btn setBackgroundImage:[UIImage imageWithData:imageDa]  forState:UIControlStateNormal];
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    }
    
    UILabel *lab = (UILabel *)[self.view viewWithTag:kUserNameLableTag];
    lab.text = [defaults objectForKey:@"nickname"];
}

#pragma mark - 组成数据源
- (void)makeUpData
{
    _dataArray = [[NSMutableArray alloc]init];
    NSArray *imageArray = @[@"我的杂志.png",@"我的评论.png",@"我的收藏.png",@"离线视频.png"];
    NSArray *titleArray = @[@"我的文章",@"我的评论",@"我的收藏",@"离线视频"];
    for (int i = 0; i < imageArray.count; i++)
    {
        NSDictionary *dict = @{@"ImageName":[imageArray objectAtIndex:i],@"Title":[titleArray objectAtIndex:i]};
        [_dataArray addObject:dict];
    }
}
#pragma mark - 左侧菜单
-(void)popToLeftMenu
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
}
#pragma mark - 进入不同分组
- (void)enterSibColume:(PersonColumeView *)columeV
{
    switch (columeV.tag-kPersonColumeViewTag)
    {
        case 0:
        {
            // 我的文章
            MyMagazineViewController *magazineVC = [[MyMagazineViewController alloc]init];
            [self.navigationController pushViewController:magazineVC animated:YES];
        }
            break;
        case 1:
        {
            // 我的评论
            MyCommentViewController *myCommonVC = [[MyCommentViewController alloc]init];
            myCommonVC.userid = _userId;
            [self.navigationController pushViewController:myCommonVC animated:YES];
        }
            break;
        case 2:
        {
            // 我的收藏
            MyCollectionViewController *myCollectionVC = [[MyCollectionViewController alloc]init];
            myCollectionVC.userId = _userId;
            [self.navigationController pushViewController:myCollectionVC animated:YES];
        }
            break;
        case 3:
        {
            // 离线视频
            OffLIneVidioViewController *offLineVidioVC = [[OffLIneVidioViewController alloc]init];
            [self.navigationController pushViewController:offLineVidioVC animated:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 进入个人中心编辑页
- (void)enterPersonEditViewController:(UIButton *)btn
{
    EditPersonViewController *editVC = [[EditPersonViewController alloc]init];
    editVC.delegate = self;
    editVC.userID = _userId;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)iconAlertSuccess:(BOOL)sucseess
{
    if (sucseess)
    {
        // 重新登录 请求数据 username=zhy&password=1
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"userName"]&&[defaults objectForKey:@"password"])
        {
//            NSLog(@"%@\n%@",[defaults objectForKey:@"userName"],[defaults objectForKey:@"password"]);
            NSDictionary *dic = @{@"username":[defaults objectForKey:@"userName"],@"password":[defaults objectForKey:@"password"]};
            [AFNetworkTool postJSONWithUrl:COCIM_INTERFACE_LOGIN parameters:dic success:^(id responseObject)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                if ([[dict objectForKey:@"respCode"] integerValue] == 1000)
                {
                    NSDictionary *userInfo = [[dict objectForKey:@"userinfo"] lastObject];
                    NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
                    [userDe setObject:[userInfo objectForKey:@"icon"] forKey:@"icon"];
                    [userDe synchronize];
                    
                    UIButton *btn = (UIButton *)[self.view viewWithTag:kHeadImageBtnTag];
                    NSData *imageDa = [NSData dataWithContentsOfURL:[NSURL URLWithString:[userInfo objectForKey:@"icon"]]];
                    [btn setBackgroundImage:[UIImage imageWithData:imageDa] forState:UIControlStateNormal];
                    
                    UILabel *lab = (UILabel *)[self.view viewWithTag:kUserNameLableTag];
                    lab.text = [userInfo objectForKey:@"nickname"];
                }
            } fail:^{
                
            }];

        }
    }
}

#pragma mark - 退出当前账号
- (void)outCurrentUser
{
    // 退出当前账号
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //移除UserDefaults中存储的用户信息
    NSArray *keyArray = @[@"id",@"nickname",@"phone",@"email",@"icon"];
    for (NSString *keys in keyArray)
    {
        [userDefaults removeObjectForKey:keys];
    }
    [userDefaults removeObjectForKey:@"userName"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults synchronize];
    
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    if ([delegate.window.rootViewController isKindOfClass:[LoginViewController class]]) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }];
//    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
//    }

}


#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
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
