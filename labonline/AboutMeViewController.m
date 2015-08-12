//
//  AboutMeViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/9.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "AboutMeViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController
#define kMainImageWidth 80
#define kAppNameLableWidth 100

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    
    NavigationButton *leftBtn = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 36) andBackImageWithName:@"返回角.png"];
    leftBtn.delegate = self;
    leftBtn.action = @selector(backLastPage);
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // 图标
    UIImageView *mainImgV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-kMainImageWidth)/2, 85, kMainImageWidth, kMainImageWidth)];
    mainImgV.image = [UIImage imageNamed:@"杂志图.png"];
    mainImgV.userInteractionEnabled = YES;
    [self.view addSubview:mainImgV];
    
    UILabel *appName = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-kAppNameLableWidth)/2, 85+kMainImageWidth, kAppNameLableWidth, 30)];
    appName.text = @"临床实验室";
    appName.textAlignment = NSTextAlignmentCenter;
    appName.textColor = [UIColor colorWithRed:214/255.0 green:0 blue:0 alpha:1];
    appName.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:appName];
    
    UILabel *versionLable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-kAppNameLableWidth)/2, 85+kMainImageWidth+30, kAppNameLableWidth, 20)];
    versionLable.text = @"V1.3";
    versionLable.textAlignment = NSTextAlignmentCenter;
    versionLable.textColor = [UIColor colorWithRed:214/255.0 green:0 blue:0 alpha:1];
    versionLable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:versionLable];
    
    NSString *text = @"  北京定向点金科技有限公司围绕医疗检验行业拓展市场，致力于服务检验医学界，为业内人士提供高附加值的信息资源与服务。定向点金旗下拥有《临床实验室》杂志、检验视界网(中文网站：www.ivdchina.org，英文网站：www.ivdchina.com)、创斯德利翻译公司、CFDA注册及临床试验代理、渠道建设及优化、活动及会议策划组织等共六项行业专业服务。定向点金把专著检验，专业服务作为公司发展的宗旨，将打造检验行业信息交流第一平台作为公司目标。定向点金—点识成金！";
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth-40, 9999)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kOneFontSize]} context:nil];
    
    UILabel *desLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 150+kMainImageWidth, kScreenWidth-40, rect.size.height)];
    desLable.text = text;
    desLable.textAlignment = NSTextAlignmentLeft;
    desLable.numberOfLines = 0;
    desLable.textColor = [UIColor colorWithWhite:142/255.0 alpha:1];
    desLable.font = [UIFont systemFontOfSize:kOneFontSize];
    [self.view addSubview:desLable];
    
    UILabel *shengMingLable = [[UILabel alloc]initWithFrame:CGRectMake(20, kScreenHeight-60, kScreenWidth-40, 40)];
    shengMingLable.text = @"版权所有：北京定向点金科技有限公司";
    shengMingLable.textAlignment = NSTextAlignmentCenter;
    shengMingLable.textColor = [UIColor colorWithWhite:142/255.0 alpha:1];
    shengMingLable.font = [UIFont systemFontOfSize:kOneFontSize];
    [self.view addSubview:shengMingLable];
}

- (void)backLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
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
