//
//  MainViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainViewController.h"

#import "DeviceManager.h"       // 版本信息
#import "LeftViewController.h"  // 左侧
#import "ShowPicture.h"         // 放大图View
#import "PictureShowView.h"     // 轮播图 View
#import "MainNewView.h"         // 最新杂志View
#import "JSZLCateView.h"        // 技术专栏分类

#import "MainDetailViewController.h"            // 主页详情（杂志详情）
#import "JiShuZhuanLanViewController.h"         // 技术专栏
#import "JiShuZhuanLanDetailViewController.h"   // 技术专栏详情
#import "JiShuZhuanLanMoreViewController.h"     // 技术专栏更多
#import "SettingCenterViewController.h"         // 设置
#import "SearchViewController.h"                // 搜索
#import "PersonCenterViewController.h"          // 下拉刷新
#import "YRSideViewController.h"                // 侧滑
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "NetManager.h"   // 网络请求
#import "UIView+Category.h" // 加载动画
#import "EGORefreshTableHeaderView.h"

#import "JiShuZhuanLanDetailViewController.h"

#import "EJTMainView.h"
#import "ProductCateView.h"

#import "EJTListViewController.h"
#import "EJTMenuViewController.h"
#import "ProductDetailViewController.h"

@interface MainViewController ()<LeftViewControllerDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>
{
    UIScrollView *_backScrollV;
    JSZLCateView *_jSZLCateV;
    PictureShowView *_pictureV;
    MainNewView *_mainNewV;
    NSDictionary *_newMagazineDict;
    NSMutableArray *_newMagazineImageArray;
    BOOL _reloading;
    EGORefreshTableHeaderView *_refresV;
    int _currentTopY;
    EJTMainView *eJTView;
    ProductCateView *_productCateV;
    BOOL _requestEJTCate;
}
@end

@implementation MainViewController
// 图片轮播View高度
#define kTopImageShowViewHeight (kScreenHeight*130/480)
// 最新杂志View 高度
#define kMainNewViewHeight 240
// 技术专栏分类单位行高 (70*kScreenHeight/480)
#define kJSZLAloneHeight 80
// 技术专栏头部高度
#define kJSZLHeadHeight 40

//(40*kScreenHeight/480)
#define kProductHangHeight 40
#define kProductHeadHeight 40

/// (310*kScreenHeight/480)
#define kEJTViewHeight 340


#pragma mark - 组成e检通菜单分类数据
- (NSArray *)makeUpEJTMenuDataWithArray:(NSArray *)array
{
    NSMutableArray *mainArr1 = [[NSMutableArray alloc]init];
    NSMutableArray *mainArr2 = [[NSMutableArray alloc]init];
    NSMutableArray *mainArr3 = [[NSMutableArray alloc]init];
    for (NSDictionary *subDic in array)
    {
        NSString *classifycode = [subDic objectForKey:@"classifycode"];
        if (classifycode.length == 3)
        {
            [mainArr1 addObject:subDic];
        }
        if (classifycode.length == 5)
        {
            [mainArr2 addObject:subDic];
        }
        if (classifycode.length == 7)
        {
            [mainArr3 addObject:subDic];
        }
    }
    
    NSMutableArray *oneArray = [[NSMutableArray alloc]init];
    for (NSDictionary *subDict1 in mainArr1)
    {
        NSString *code1 = [subDict1 objectForKey:@"classifycode"];
        NSMutableArray *twoArray = [[NSMutableArray alloc]init];
        for (NSDictionary *subDict2 in mainArr2)
        {
            NSString *code2 = [subDict2 objectForKey:@"classifycode"];
            if ([code2 hasPrefix:code1])
            {
                NSMutableArray *threeArray = [[NSMutableArray alloc]init];
                for (NSDictionary *subDict3 in mainArr3)
                {
                    NSString *code3 = [subDict3 objectForKey:@"classifycode"];
                    if ([code3 hasPrefix:code2])
                    {
                        [threeArray addObject:subDict3];
                    }
                }
                NSDictionary *dict2 = @{@"submenus":threeArray,@"info":subDict2};
                [twoArray addObject:dict2];
            }
        }
        NSDictionary *dict1 = @{@"submenus":twoArray,@"info":subDict1};
        [oneArray addObject:dict1];
    }
    return oneArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([DeviceManager deviceVersion]>=7)
    {
        //界面调整
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:216/255.0 green:0 blue:0 alpha:1]}];
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.title = @"医检在线";
    
    //在导航视图底添加分割线
    UIView *navDividingLine = [[UIView alloc] init];
    if (navDividingLine != nil)
    {
        navDividingLine.frame = CGRectMake(0, 0, kScreenWidth, 1);
        navDividingLine.backgroundColor = [UIColor redColor];
        [self.view addSubview:navDividingLine];
    }

    // 左侧按钮
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30) andBackImageWithName:@"tubiao_04.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(popToLeftMenu);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchVC);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    _backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-65)];
    _backScrollV.delegate =self;
    _backScrollV.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+10);
    [self.view addSubview:_backScrollV];
    
     // 图片轮播View
    _pictureV = [[PictureShowView alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-10, kTopImageShowViewHeight)];
    _pictureV.target = self;
    _pictureV.action = @selector(pictureShowMethod:);
    [_backScrollV addSubview:_pictureV];
    
    // 最新杂志
    _mainNewV = [[[NSBundle mainBundle]loadNibNamed:@"MainNewView" owner:self options:0] lastObject];
    _mainNewV.frame = CGRectMake(5, 15+kTopImageShowViewHeight, kScreenWidth-10, kMainNewViewHeight);
    _mainNewV.target = self;
    _mainNewV.action = @selector(enLargeImage:);
    [_backScrollV addSubview:_mainNewV];
    
    UITapGestureRecognizer *tapMainV = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterMagazineViewController:)];
    [_mainNewV addGestureRecognizer:tapMainV];
    
    // 技术专栏
    // 先计算技术专栏的高度
    
    _jSZLCateV = [[[NSBundle mainBundle]loadNibNamed:@"JSZLCateView" owner:self options:0] lastObject];
    _jSZLCateV.frame = CGRectMake(5, 25+kTopImageShowViewHeight+kMainNewViewHeight, kScreenWidth-10, kJSZLAloneHeight);
    _jSZLCateV.target = self;
    _jSZLCateV.action = @selector(enterJSZLVireController:);
    [_backScrollV addSubview:_jSZLCateV];
    
    _reloading = NO;
    [self createRefreshView];
    
    _currentTopY = (int)(25+kTopImageShowViewHeight+kMainNewViewHeight);
    eJTView = [[[NSBundle mainBundle]loadNibNamed:@"EJTMainView" owner:self options:0] lastObject];
    eJTView.frame = CGRectMake(5, _currentTopY+kJSZLAloneHeight+10, kScreenWidth-10, kEJTViewHeight);
//    eJTView.index = 12;
    eJTView.target=self;
    eJTView.action=@selector(productMethod:);
    [_backScrollV addSubview:eJTView];
    
    
    _productCateV = [[[NSBundle mainBundle]loadNibNamed:@"ProductCateView" owner:self options:0] lastObject];
    [_productCateV setFrame:CGRectMake(5, _currentTopY+kJSZLAloneHeight+20+kEJTViewHeight, kScreenWidth-10, kProductHeadHeight+kProductHangHeight*1)];
    _productCateV.delegate = self;
    _productCateV.action = @selector(productCateMethod:);
    [_backScrollV addSubview:_productCateV];
    
    _backScrollV.contentSize = CGSizeMake(kScreenWidth, _currentTopY + kJSZLAloneHeight + kEJTViewHeight + 20 + kProductHeadHeight+kProductHangHeight*1);
    
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
    [self requestMainDataWithURLString:kMainUrlString];
    
    _requestEJTCate = YES;
    [self requestMainDataWithURLString:kEJTCateUrl];
}

#pragma mark - 产品点击事件
- (void)productMethod:(NSDictionary *)proDic{
//    NSLog(@"%@",proDic);
    ProductDetailViewController *proDV=[[ProductDetailViewController alloc] init];
    proDV.proDetail=proDic;
    [self.navigationController pushViewController:proDV animated:YES];
}
#pragma mark - 菜单过渡界面
- (void)productCateMethod:(ProductCateView *)proCateV
{
    // 菜单界面
    EJTMenuViewController *menuVC =[[ EJTMenuViewController alloc]init];
    menuVC.firstMenu = proCateV.selectedButtonIndex;
//    NSLog(@"%d",menuVC.type);
    [self.navigationController pushViewController:menuVC animated:YES];
}

#pragma mark - 网络请求
#pragma mark -- 开始请求
- (void)requestMainDataWithURLString:(NSString *)urlStr
{
    NetManager *netManager = [NetManager getShareManager];
    netManager.delegate = self;
    netManager.action = @selector(requestFinished:);
    [netManager requestDataWithUrlString:urlStr];
}
#pragma mark --网络请求完成
- (void)requestFinished:(NetManager *)netManager
{
    if (_reloading)
    {
        [self stopRefresh];
    }
    else
    {
        [self.view removeLoadingVIewInView:self.view andTarget:self];
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
//    NSLog(@"@@@@@@@:%@",netManager.downLoadData);
    
    if ([dict objectForKey:@"productclassifyList"])  _requestEJTCate= YES;
    else _requestEJTCate= NO;
    
    if (_requestEJTCate)
    {
        if (netManager.downLoadData)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
            if ([dict objectForKey:@"productclassifyList"])
            {
                NSArray *eJtMenuArray = [self makeUpEJTMenuDataWithArray:[dict objectForKey:@"productclassifyList"]];
//                NSLog(@"@@@@@@@:%@",eJtMenuArray);
                [[NSUserDefaults standardUserDefaults] setObject:eJtMenuArray forKey:@"MENUARRAY"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    else
    {
        if (netManager.downLoadData)
        {
            // 成功
            // 解析
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
            [self addControlsWithDictionary:[dict objectForKey:@"data"]];
//            NSLog(@"")
        }
        else
        {
            // 失败
            [self.view addAlertViewWithMessage:@"请求不到数据，请重试" andTarget:self];
        }
    }
}

#pragma mark --根据数据来添加UI控件
- (void)addControlsWithDictionary:(NSDictionary *)dict
{
    // 最新文章的数据
    _newMagazineDict = [[dict objectForKey:@"newMagazineList"] objectAtIndex:0];
    NSInteger imageCount = [[_newMagazineDict objectForKey:@"picturenum"] integerValue];
    _newMagazineImageArray = [[NSMutableArray alloc]init];
    for (int i = 1; i <= imageCount; i ++)
    {
        NSString *key = [NSString stringWithFormat:@"pictureurl%d",i];
        NSString *imageUrl = [_newMagazineDict objectForKey:key];
        [_newMagazineImageArray addObject:imageUrl];
    }
    _mainNewV.imageDataArray = _newMagazineImageArray;
    _mainNewV.mainMagazineDict = _newMagazineDict;
    
    // 轮播图片数据
    NSArray *pictureShowArray = [dict objectForKey:@"pictureList"];
    _pictureV.imageInfoArray = pictureShowArray;
    
    // 技术专栏标签
    NSArray *jSZLArray = [dict objectForKey:@"technologyList"];
    NSInteger hang = jSZLArray.count%4?jSZLArray.count/4+1:jSZLArray.count/4;
    NSInteger jSZLHeight = kJSZLHeadHeight + hang*kJSZLAloneHeight;
    CGRect rect = _jSZLCateV.frame;
    rect.size.height = jSZLHeight;
    _jSZLCateV.frame = rect;
    _jSZLCateV.cateDataArray = jSZLArray;
    
    // e检通数据
    NSArray *ejtArray = [dict objectForKey:@"productList"];
    //e检通View frame
    CGRect ejtRect = eJTView.frame;
    ejtRect.origin.y = _currentTopY + jSZLHeight +10;
    eJTView.frame = ejtRect;
    eJTView.productInfoArray = ejtArray;
    
    // e检通分类数据
    CGRect ejtCateRect = _productCateV.frame;
    ejtCateRect.origin.y = _currentTopY + jSZLHeight +10 + eJTView.frame.size.height+10;
    _productCateV.frame = ejtCateRect;
    _productCateV.productArray = [dict objectForKey:@"productclassifyList"];// @[@"仪器",@"试剂",@"耗材"]; //[dict objectForKey:@"productclassifyList"];

    // 改变scrollView可滑动
    NSInteger y = _currentTopY+jSZLHeight + 20 +ejtRect.size.height + ejtCateRect.size.height +10;
    if (y<kScreenHeight)
    {
        y = kScreenHeight + 20;
    }
    _backScrollV.contentSize = CGSizeMake(kScreenWidth, y);
    _backScrollV.showsVerticalScrollIndicator = NO;
}

#pragma mark - 左侧菜单
-(void)popToLeftMenu
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
}

#pragma mark - 进入 MainDetailViewController
- (void)enterMagazineViewController:(UITapGestureRecognizer *)tap
{
    MainDetailViewController *mainDetailVC = [[MainDetailViewController alloc]init];
    mainDetailVC.imagesArray = _newMagazineImageArray;
    mainDetailVC.detailDict = _newMagazineDict;
    [self.navigationController pushViewController:mainDetailVC animated:YES];
}

#pragma mark - 图片轮播-->进入详情
- (void)pictureShowMethod:(PictureShowView *)pictureShowV
{
    NSDictionary *currentDict = [pictureShowV.imageInfoArray objectAtIndex:pictureShowV.imageIndex];
    if ((![[currentDict objectForKey:@"articleinfo"] isEqual:[NSNull null]])&&[currentDict objectForKey:@"articleinfo"])
    {
        JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
        detailVC.articalDic = [currentDict objectForKey:@"articleinfo"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if ((![[currentDict objectForKey:@"productpic"] isEqual:[NSNull null]])&&[currentDict objectForKey:@"productpic"])
    {
        ProductDetailViewController *proDV=[[ProductDetailViewController alloc] init];
        proDV.proDetail=[currentDict objectForKey:@"productpic"];
        [self.navigationController pushViewController:proDV animated:YES];
    }
    
}
#pragma mark - 进入技术专栏界面
- (void)enterJSZLVireController:(JSZLCateView *)jSZLCateView
{
//    NSLog(@"进入技术专栏界面");
    if (jSZLCateView.enterMoreVC)
    {
        // 更多界面
        JiShuZhuanLanMoreViewController *moreVC = [[JiShuZhuanLanMoreViewController alloc]init];
        moreVC.typeId = [[jSZLCateView.cateDataArray objectAtIndex:jSZLCateView.selectedIndex] objectForKey:@"id"];
//        NSLog(@"%@",moreVC.typeId);
        [self.navigationController pushViewController:moreVC animated:YES];
    }
    else
    {
        // 技术专栏主页
        JiShuZhuanLanViewController *jszlVC = [[JiShuZhuanLanViewController alloc]init];
        [self.navigationController pushViewController:jszlVC animated:YES];
    }
}

#pragma mark - 搜索
- (void)enterSearchVC
{
    // 搜索
//    NSLog(@"enterSearchViewController");
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - LeftViewControllerDelegate(侧滑回到主页)
- (void)pushViewControllerWithIndex:(NSInteger)type
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController hideSideViewController:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
    switch (type)
    {
        case MainPage:
        {
            // 主页
        }
            break;
        case JiShuZhuanLan:
        {
            JiShuZhuanLanViewController *jSZLViewController = [[JiShuZhuanLanViewController alloc]init];
            jSZLViewController.enterFromHome = YES;
            [self.navigationController pushViewController:jSZLViewController animated:YES];
        }
            break;
        case WangQi:
        {
            MenuViewController *menuVC=[[MenuViewController alloc] init];
            menuVC.enterFromHome = YES;
            [self.navigationController pushViewController:menuVC animated:YES];
        }
            break;
        case PersonCenter:
        {
            PersonCenterViewController *personVC = [[PersonCenterViewController alloc]init];
            [self.navigationController pushViewController:personVC animated:YES];
        }
            break;
        case SettingCenter:
        {
            SettingCenterViewController *settingVC = [[SettingCenterViewController alloc]init];
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }
            break;
            case LogIn:
        {
            // 登陆
            LoginViewController *loginVC=[[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
            break;
        case Register:
        {
            // 注册
            RegisterViewController *registerVC = [[RegisterViewController alloc]init];
            [self presentViewController:registerVC animated:YES completion:nil];
        }
            break;
        case EJianTong:
        {
            // e检通
            EJTListViewController *eJTVC = [[EJTListViewController alloc]init];
            eJTVC.firstMenu = 0;
            eJTVC.seconMenu = 0;
            eJTVC.thirdMenu = 0;
            eJTVC.classifyid = @"1D7A353CB48C471BB1A9696F070E6DDD";// 此处暂时写死
            eJTVC.enterFormHome = YES;
            [self.navigationController pushViewController:eJTVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 放大图片
- (void)enLargeImage:(MainNewView *)mainNewView
{
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.needSwipeShowMenu=NO;
    
    ShowPicture *pictureV = [[ShowPicture alloc]initWithFrame:self.view.bounds];
    [pictureV setSelectedIndex:mainNewView.clickImageIndex andImageDataArray:mainNewView.imageDataArray];
    pictureV.target = self;
    pictureV.action = @selector(pictureCallBack:);
    [self.view addSubview:pictureV];
}

#pragma mark - 删除图片展示View
- (void)pictureCallBack:(ShowPicture *)picV
{
    [picV removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.needSwipeShowMenu=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createRefreshView
{
    if (_refresV && [_refresV superview]) {
        [_refresV removeFromSuperview];
    }
    _refresV = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refresV.delegate = self;
    [_backScrollV addSubview:_refresV];
    [_refresV refreshLastUpdatedDate];
}


#pragma mark --EGORefreshTableHeaderDelegate
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if (_reloading == NO)
    {
        _reloading = YES;
        [self requestMainDataWithURLString:kMainUrlString];
    }
}

- (void)stopRefresh
{
    _reloading = NO;
    [_refresV egoRefreshScrollViewDataSourceDidFinishedLoading:_backScrollV];
    [_backScrollV reloadInputViews];
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresV egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresV egoRefreshScrollViewDidEndDragging:scrollView];
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
