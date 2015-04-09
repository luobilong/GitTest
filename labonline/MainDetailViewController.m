//
//  MainDetailViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/31.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainDetailViewController.h"
#import "MainListViewController.h"
#import "MenuViewController.h"
#import "ShowPicture.h"
#import "SearchViewController.h"


#define kBackViewTag 55
#define kMagazineCoverButtonTag 56
#define KCoverButtonWidth 115
#define KCoverButtonHeight 135
#define kDownLoadButtonTag 88
#define kBrowseButtonTag 89
#define kWangQiButtonTag 90
#define kImageButtonTag 123

#define kShowImagesViewTag 333
#define kShowScrollViewTag 334
#define kPageControlTag 335
#define kImageViewHeight 80

@interface MainDetailViewController ()<UIScrollViewDelegate>

@end

@implementation MainDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    self.title = @"杂志名";
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 左侧按钮
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 26) andBackImageWithName:@"aniu_07.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(backToPrePage);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchVCFromDetail);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 底部背景
    NSInteger backViewWidth = kScreenWidth-10;
    NSInteger backViewheight = kScreenHeight-64-30;
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(5, 5, backViewWidth, backViewheight)];
    backV.backgroundColor = [UIColor whiteColor];
    backV.layer.masksToBounds = YES;
    backV.layer.cornerRadius = 5;
    backV.tag = kBackViewTag;
    [self.view addSubview:backV];
    
    // 可滑动
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:backV.bounds];
    scrollV.backgroundColor = [UIColor clearColor];
    scrollV.delegate = self;
    scrollV.showsVerticalScrollIndicator = NO;
    [backV addSubview:scrollV];
    
    // 杂志封面
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton setFrame:CGRectMake(10, 10, KCoverButtonWidth, KCoverButtonHeight)];
    [coverButton setBackgroundImage:[UIImage imageNamed:@"wangqi.png"] forState:UIControlStateNormal];
    coverButton.tag = kMagazineCoverButtonTag;
    [scrollV addSubview:coverButton];
    // 基本信息
    // 标题
    UILabel *cateLable = [[UILabel alloc]initWithFrame:CGRectMake(20+KCoverButtonWidth, 15,backViewWidth-20-KCoverButtonWidth, 20)];
    cateLable.text = @"期刊分类标题";
    cateLable.textAlignment = NSTextAlignmentLeft;
    cateLable.textColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1];
    cateLable.font = [UIFont systemFontOfSize:kOneFontSize];
    [scrollV addSubview:cateLable];
    // 期刊
    UILabel *qiKanLable = [[UILabel alloc]initWithFrame:CGRectMake(20+KCoverButtonWidth, 35,backViewWidth-20-KCoverButtonWidth, 20)];
    qiKanLable.text = @"期刊数：2015年2月刊";
    qiKanLable.textAlignment = NSTextAlignmentLeft;
    qiKanLable.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
    qiKanLable.font = [UIFont systemFontOfSize:kTwoFontSize];
    [scrollV addSubview:qiKanLable];
    
    // 收藏
    UILabel *shouCangLable = [[UILabel alloc]initWithFrame:CGRectMake(20+KCoverButtonWidth, 55,backViewWidth-20-KCoverButtonWidth, 20)];
    shouCangLable.text = @"收藏：10次";
    shouCangLable.textAlignment = NSTextAlignmentLeft;
    shouCangLable.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
    shouCangLable.font = [UIFont systemFontOfSize:kTwoFontSize];
    [scrollV addSubview:shouCangLable];
    
    // 按钮公用属性
    UIColor *borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    UIColor *backColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    UIColor *textColor = [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1];
    //阅读
    UIButton *browseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [browseButton setFrame:CGRectMake(KCoverButtonWidth+20, 120, 48, 22)];
    [browseButton setTitle:@"阅读" forState:UIControlStateNormal];
    [browseButton setTitleColor:textColor forState:UIControlStateNormal];
    browseButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    browseButton.layer.masksToBounds = YES;
    browseButton.layer.cornerRadius = 10;
    browseButton.layer.borderColor = borderColor.CGColor;
    browseButton.layer.borderWidth = 1;
    browseButton.backgroundColor = backColor;
    browseButton.tag = kBrowseButtonTag;
    [browseButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollV addSubview:browseButton];
    // 往期
    UIButton *wangQiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wangQiButton setFrame:CGRectMake(KCoverButtonWidth+20+55, 120, 48, 22)];
    [wangQiButton setTitle:@"往期" forState:UIControlStateNormal];
    [wangQiButton setTitleColor:textColor forState:UIControlStateNormal];
    wangQiButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    wangQiButton.layer.masksToBounds = YES;
    wangQiButton.layer.cornerRadius = 10;
    wangQiButton.layer.borderColor = borderColor.CGColor;
    wangQiButton.layer.borderWidth = 1;
    wangQiButton.backgroundColor = backColor;
    wangQiButton.tag = kWangQiButtonTag;
    [wangQiButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollV addSubview:wangQiButton];
    
    NSInteger wid = backV.frame.size.width;
    NSInteger btnWidth = (wid-20)/5;
    NSInteger btnHeight = kImageViewHeight;
    for (int i = 0; i < _iamgesArray.count; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kImageButtonTag + i;
        [btn setFrame:CGRectMake(10+i*btnWidth, 155, btnWidth, btnHeight)];
        [btn setBackgroundImage:[UIImage imageNamed:[_iamgesArray objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollV addSubview:btn];
    }

    
    NSString *desStr = @"    美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n   美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n   美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n   美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。\n     美国国家安全局发表声明说，当天上午9时左右，两名化装成女性的男子驱车试图冲击位于马里兰州米德堡的国家安全局总部大门，国家安全局保卫人员开枪阻挡，车上一名男子被当场打死，另一人受重伤。一名国家安全局警官在事件中受伤。";
    CGRect rect = [desStr boundingRectWithSize:CGSizeMake(backViewWidth-20, 99999)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kOneFontSize]} context:nil];
    UILabel *desLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 170+kImageViewHeight,backViewWidth-20, rect.size.height)];
    desLab.text = desStr;
    desLab.textAlignment = NSTextAlignmentLeft;
    desLab.numberOfLines = 0;
    desLab.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
    desLab.font = [UIFont systemFontOfSize:kOneFontSize];
    [scrollV addSubview:desLab];
    
    if (backViewheight-170-kImageViewHeight-rect.size.height<=10)
    {
        scrollV.contentSize = CGSizeMake(0, 170+kImageViewHeight+rect.size.height+20);
    }
}

#pragma mark - 放大图片
- (void)imageButtonClicked:(UIButton *)btn
{
    self.navigationController.navigationBarHidden = YES;
    ShowPicture *pictureV = [[ShowPicture alloc]initWithFrame:self.view.bounds];
    [pictureV setSelectedIndex:btn.tag-kImageButtonTag andImageDataArray:_iamgesArray];
    pictureV.target = self;
    pictureV.action = @selector(pictureCallBack:);
    [self.view addSubview:pictureV];
}
- (void)pictureCallBack:(ShowPicture *)pictureV
{
    [pictureV removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 按钮点击事件
- (void)buttonClicked:(UIButton *)btn
{
    switch (btn.tag)
    {
        case kWangQiButtonTag:
        {
            // 往期
            MenuViewController *menuVC=[[MenuViewController alloc] init];
            [self.navigationController pushViewController:menuVC animated:YES];
        }
            break;
        case kBrowseButtonTag:
        {
            // 文章列表
            MainListViewController *listVC = [[MainListViewController alloc]init];
            [self.navigationController pushViewController:listVC animated:YES];
        }
            break;
        case kDownLoadButtonTag:
        {
            // 下载
        }
            break;
        default:
            break;
    }
}

#pragma mark - 返回上一页
- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 进入搜索界面
- (void)enterSearchVCFromDetail
{
    // 搜索
    NSLog(@"enterSearchViewController");
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
