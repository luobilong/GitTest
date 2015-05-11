//
//  EJTListViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/28.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EJTListViewController.h"
#import "MenuButton.h"
#import "EJTListCell.h"
#import "NetManager.h"
#import "UIView+Category.h"
#import "UIImageView+WebCache.h"
#import "SearchViewController.h"
#import "ProductDetailViewController.h"
#import "MenuCell.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"

#import "EGORefreshTableHeaderView.h"


@interface EJTListViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    NSMutableArray *_firstMenuArray;
    NSMutableArray *_seconMenudArray;
    NSMutableArray *_thirdMenuArray;
    
    NSMutableArray *_mainArray;
    NSArray *_pXrray;
    
    UITableView *_smallTabV;
    UITableView *_leftTabV;
    UITableView *_rightTabV;
    UITableView *_mainTabV;
    
    BOOL _paiXu;
    int _currentRequestPage;
    UIView *_loadingMoreView;
    NSDictionary *_loadingPageDic;
    BOOL _loadMore;
    
    BOOL _reloading;
    EGORefreshTableHeaderView *_refresV;
}
@end

@implementation EJTListViewController

#define kLeftButtonTag 100
#define kRightButtonTag 102
#define kMiddleButtonTag 101

#define KleftTabTag 11
#define kRightTabTag 12
#define kSmallTabTag 13
#define kMainTabTag 14

#define kLeftCellTag 6666
#define kRightCellTag 7777
#define kSmallCellTag 8888

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([DeviceManager deviceVersion]>=7)
    {
        //界面调整
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    if (_enterFormHome == NO)
    {
        // 左侧按钮
        NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 40) andBackImageWithName:@"返回角.png"];
        leftButton.delegate = self;
        leftButton.action = @selector(backToPrePage);
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    else
    {
        NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30) andBackImageWithName:@"tubiao_04.png"];
        leftButton.delegate = self;
        leftButton.action = @selector(popToLeftMenu);
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchVC);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _paiXu = NO;
    _mainArray = [[NSMutableArray alloc]init];
    [self makeUpMenuArray];
    
    NSString *firstMenuTitle = [[[_firstMenuArray objectAtIndex:_firstMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
    self.title = firstMenuTitle;
    
    NSString *secondStr=[[[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
    NSString *thirdStr=[[_thirdMenuArray objectAtIndex:_thirdMenu] objectForKey:@"classifyname"];
    self.title=[secondStr stringByAppendingFormat:@" -> %@",thirdStr];
    
    MenuButton *leftBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = kLeftButtonTag;
    [leftBtn setFrame:CGRectMake(0, 0, kScreenWidth/3, 30)];
    [leftBtn setTitle:firstMenuTitle forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    
    NSString *secMenuString = [[[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
    MenuButton *middleBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    middleBtn.tag = kLeftButtonTag+1;
    [middleBtn setFrame:CGRectMake(kScreenWidth/3, 0, kScreenWidth/3, 30)];
    [middleBtn setTitle:secMenuString forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [middleBtn setTitleColor:[UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:middleBtn];
    
    MenuButton *rigBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    rigBtn.tag = kLeftButtonTag+2;
    [rigBtn setFrame:CGRectMake(kScreenWidth*2/3, 0, kScreenWidth/3, 30)];
    [rigBtn setTitle:@"排序" forState:UIControlStateNormal];
    [rigBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rigBtn];
    [rigBtn setTitleColor:[UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1] forState:UIControlStateNormal];

    _leftTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 31, kScreenWidth/2, kScreenHeight-95) style:UITableViewStylePlain];
    _leftTabV.delegate = self;
    _leftTabV.dataSource = self;
    _leftTabV.tag = KleftTabTag;
    [self.view addSubview:_leftTabV];
    
    _rightTabV = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 31, kScreenWidth/2, kScreenHeight-95) style:UITableViewStylePlain];
    _rightTabV.delegate = self;
    _rightTabV.dataSource = self;
    _rightTabV.tag = kRightTabTag;
    [self.view addSubview:_rightTabV];
    
    _smallTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 31, kScreenWidth, kScreenHeight-95) style:UITableViewStylePlain];
    _smallTabV.delegate = self;
    _smallTabV.dataSource = self;
    _smallTabV.tag = kSmallTabTag;
    [self.view addSubview:_smallTabV];
    
    _leftTabV.hidden = YES;
    _rightTabV.hidden = YES;
    _smallTabV.hidden = YES;
    _leftTabV.backgroundColor = [UIColor clearColor];
    _rightTabV.backgroundColor = [UIColor clearColor];
    _smallTabV.backgroundColor = [UIColor clearColor];
    
    _leftTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _smallTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _smallTabV.layer.masksToBounds = YES;
    _smallTabV.layer.cornerRadius = 2;
    _smallTabV.layer.borderWidth = 1;
    _smallTabV.layer.borderColor = [UIColor colorWithWhite:230/255.0 alpha:1].CGColor;
    
    _mainTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, kScreenHeight-100) style:UITableViewStylePlain];
    _mainTabV.delegate = self;
    _mainTabV.dataSource = self;
    _mainTabV.tag = kMainTabTag;
    _mainTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTabV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainTabV];
    
    _pXrray = @[@"按时间排序",@"按浏览量排序"];
    _reloading = NO;
    _currentRequestPage = 1;
    _classifyid = [[_thirdMenuArray objectAtIndex:_thirdMenu] objectForKey:@"classifyid"];
    [self startRequestMainDataWithAnimotion:YES];
    
    [self createRefreshView];
}

#pragma mark - 搜索
- (void)enterSearchVC
{
    // 搜索
//    NSLog(@"enterSearchViewController");
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - 返回上一页
- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求产品信息列表
- (void)startRequestMainDataWithAnimotion:(BOOL)animotion
{
    if (animotion)
    {
        [self.view addLoadingViewInSuperView:self.view andTarget:self];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@?classifyid=%@&currentPage=%d&pageSize=10",kEJTProductListUrl,_classifyid,_currentRequestPage];
//    NSLog(@"~~~~~~%@",urlStr);
    [self requestWithUrl:urlStr];
}

#pragma mark - 网络请求
- (void)requestWithUrl:(NSString *)urlString
{
    NetManager *manager = [NetManager getShareManager];
    manager.delegate = self;
    manager.action = @selector(requestFinished:);
    [manager requestDataWithUrlString:urlString];
}

#pragma mark - 网络回调
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
    if (netManager.downLoadData)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
//        NSLog(@"%@",dict);
        if ([[dict objectForKey:@"respCode"] integerValue] == 1000)
        {
            // 成功
            NSArray *productList = [[dict objectForKey:@"data"] objectForKey:@"productList"];
            _loadingPageDic = [dict objectForKey:@"pageBean"];
            [self createLoadingMoreView];
            if (!_loadMore)
            {
                [_mainArray removeAllObjects];
            }
            _loadMore = NO;
            for (NSDictionary *dict in productList)
            {
                [_mainArray addObject:dict];
            }
            [_mainTabV reloadData];
            CGRect rect = _mainTabV.frame;
            if (_mainArray.count*160+_loadingMoreView.frame.size.height<kScreenHeight-100)
            {
                rect.size.height = _mainArray.count*160+_loadingMoreView.frame.size.height;
            }
            else
            {
                rect.size.height = kScreenHeight-100;
            }
            _mainTabV.frame = rect;
        }
        else
        {
//            NSLog(@"%@",[dict objectForKey:@"remark"]);
        }
    }
    else
    {
//        NSLog(@"%@",netManager.failError);
    }
//    NSLog(@"网络");
}

#pragma mark - UITableView Delegate
#pragma mark -- 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == KleftTabTag)
    {
        // left
        return _seconMenudArray.count;
    }
    else if (tableView.tag == kRightTabTag)
    {
        return _thirdMenuArray.count;
    }
    else if (tableView.tag == kSmallTabTag)
    {
        if (_paiXu)
        {
            return _pXrray.count;
        }
        else
        {
            return _firstMenuArray.count;
        }
    }
    else if (tableView.tag == kMainTabTag)
    {
        return _mainArray.count;
    }
    return 0;
}

#pragma mark -- cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMainTabTag)
    {
        return 160;
    }
    return 35;
}

#pragma mark -- 绘制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMainTabTag)
    {
        static NSString *cellId = @"MainEJTCell";
        EJTListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EJTListCell" owner:self options:0] lastObject];
        }
        NSDictionary *dict = [_mainArray objectAtIndex:indexPath.row];
        if ([[dict objectForKey:@"producticon"] length]>2)
        {
            [cell.imageV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"producticon"]] placeholderImage:[UIImage imageNamed:@"wangqi.png"]];
        }
        else
        {
            cell.imageV.image = [UIImage imageNamed:@"暂无图片.jpg"];
        }
        if ([[dict objectForKey:@"producttitle"] length]>2)
        {
            cell.titleLabel.text = [dict objectForKey:@"producttitle"];
        }
        if ([[dict objectForKey:@"company"] length]>2)
        {
            cell.qKLabel.text = [dict objectForKey:@"company"];//暂时公司
        }
        if ([dict objectForKey:@"seenum"] != nil)
        {
            cell.yLCountLabel.text = [NSString stringWithFormat:@"%ld",[[dict objectForKey:@"seenum"] integerValue]];
        }
        return cell;
    }
    else if (tableView.tag == KleftTabTag || tableView.tag == kRightTabTag)
    {
        static NSString *cellId = @"MenuCell";
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:0] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.target = self;
        switch (tableView.tag)
        {
            case KleftTabTag:
            {
                cell.titleLabel.text = [[[_seconMenudArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyname"];
                cell.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
                cell.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
                cell.action = @selector(leftMenu:);
                cell.tag = indexPath.row + kLeftCellTag;
                if (indexPath.row == _seconMenu)
                {
                    cell.selectedLable.hidden = NO;
                    cell.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
                }
            }
                break;
            case kRightTabTag:
            {
//                NSLog(@"%@",[_thirdMenuArray objectAtIndex:0]);
                cell.titleLabel.text = [[_thirdMenuArray objectAtIndex:indexPath.row] objectForKey:@"classifyname"];
                cell.titleLabel.textColor = [UIColor colorWithWhite:128/255.0 alpha:1];
                cell.titleLabel.font = [UIFont systemFontOfSize:kTwoFontSize];
                cell.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
                cell.action = @selector(rightMenu:);
                cell.tag = indexPath.row + kRightCellTag
                ;
                if (!(_thirdMenu < _thirdMenuArray.count))
                {
                    _thirdMenu = 0;
                }
                if (indexPath.row == _thirdMenu)
                {
                    cell.titleLabel.textColor = [UIColor redColor];
                }
            }
                break;
            default:
                break;
        }
        return cell;
    }
    else
    {
        static NSString *cellId = @"pxCell";
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:0] lastObject];
            cell.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
        }
        cell.target = self;
        cell.tag = indexPath.row + kSmallCellTag;
        cell.backgroundColor = [UIColor colorWithWhite:235/255.0 alpha:1];
        switch (tableView.tag)
        {
            case kSmallTabTag:
            {
                if (_paiXu)
                {
                    cell.titleLabel.text = [_pXrray objectAtIndex:indexPath.row];
                    UIButton *btn = (UIButton *)[self.view viewWithTag:kRightButtonTag];
                    if ([btn.titleLabel.text isEqualToString:[_pXrray objectAtIndex:indexPath.row]])
                    {
                        cell.selectedLable.hidden = NO;
                        cell.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
                    }
                    cell.action = @selector(paiXuMenu:);
                }
                else
                {
                    cell.action = @selector(firstMenu:);
                    if (indexPath.row == _firstMenu)
                    {
                        cell.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
                        cell.selectedLable.hidden = NO;
                    }
                    cell.titleLabel.text = [[[_firstMenuArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyname"];
                }
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMainTabTag)
    {
        // 选中产品信息 进入产品详情
        NSDictionary *proD = [_mainArray objectAtIndex:indexPath.row];
        ProductDetailViewController *proDetail=[[ProductDetailViewController alloc] init];
        proDetail.proDetail=proD;
        [self.navigationController pushViewController:proDetail animated:YES];
    }
}

#pragma mark -- 去掉多余的线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == kMainTabTag)
    {
        return _loadingMoreView.frame.size.height;
    }
    return 0.1;
}
#pragma mark - 尾部视图 加载更多
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == kMainTabTag)
    {
        return _loadingMoreView;
    }
    return nil;
}

#pragma mark - 创建尾部视图
- (void)createLoadingMoreView
{
    NSInteger sumPages = [[_loadingPageDic objectForKey:@"totalPage"] intValue];
    if (_currentRequestPage<sumPages)
    {
        _loadingMoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10, 5, kScreenWidth-20, 20)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:@"加载更多...." forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:128/255.0 alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
        [btn addTarget:self action:@selector(loadMoreButonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_loadingMoreView addSubview:btn];
    }
    else
    {
        _loadingMoreView = nil;
    }
}

#pragma mark - 加载更多按钮点击事件
- (void)loadMoreButonClicked:(UIButton *)btn
{
    // 加载更多
    _loadMore = YES;
    _currentRequestPage ++;
    [self startRequestMainDataWithAnimotion:YES];
}

#pragma mark - 二级菜单点击事件回调
- (void)leftMenu:(MenuCell *)cell
{
    [self changeSelectedCell:cell andBaseTag:kLeftCellTag andSumCounts:_seconMenudArray.count];
    _seconMenu = cell.tag - kLeftCellTag;
    _thirdMenu = 0;
    
    _seconMenudArray = [[_firstMenuArray objectAtIndex:_firstMenu] objectForKey:@"submenus"];
    UIButton *btn = (UIButton *)[self.view viewWithTag:kMiddleButtonTag];
    [btn setTitle:[[[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"info"] objectForKey:@"classifyname"] forState:UIControlStateNormal];
    _thirdMenuArray = [[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"submenus"];
    _rightTabV.hidden = NO;
    [self.view bringSubviewToFront:_rightTabV];
    [self changeTableViewFrameWithTag:_rightTabV.tag andCount:_thirdMenuArray.count];
    [_rightTabV reloadData];
}

#pragma mark - 三级菜单点击事件回调
- (void)rightMenu:(MenuCell *)cell
{
    [self changeSelectedCell:cell andBaseTag:kRightCellTag andSumCounts:_thirdMenuArray.count];
    _thirdMenu = cell.tag - kRightCellTag;
    
    _leftTabV.hidden = YES;
    _rightTabV.hidden = YES;
    UIButton *btn = (UIButton *)[self.view viewWithTag:kMiddleButtonTag];
    [btn setTitle:[[_thirdMenuArray objectAtIndex:_thirdMenu] objectForKey:@"classifyname"] forState:UIControlStateNormal];
    [self changeOriginalWithButtonTag:kMiddleButtonTag];
    
    // 网络请求
    _currentRequestPage = 1;
    _classifyid = [[_thirdMenuArray objectAtIndex:_thirdMenu] objectForKey:@"classifyid"];
    [self startRequestMainDataWithAnimotion:YES];
    
    
    NSString *secondStr=[[[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
    NSString *thirdStr=[[_thirdMenuArray objectAtIndex:_thirdMenu] objectForKey:@"classifyname"];
    self.title=[secondStr stringByAppendingFormat:@" -> %@",thirdStr];
}

#pragma mark - 排序菜单点击事件回调
- (void)paiXuMenu:(MenuCell *)cell
{
    NSInteger index = cell.tag - kSmallCellTag;
    NSString *titl = [_pXrray objectAtIndex:index];
    UIButton *btn = (UIButton *)[self.view viewWithTag:102];
    [btn setTitle:titl forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [btn setTitleColor:[UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1] forState:UIControlStateNormal];
    _smallTabV.hidden = YES;
    [self changeOriginalWithButtonTag:kRightButtonTag];
    if (_mainArray.count > 0)
    {
        switch (index)
        {
            case 0:
            {
                [self timeSort];
            }
                break;
            case 1:
            {
                [self seenumberSort];
            }
                break;
            default:
                break;
        }
        [_mainTabV reloadData];
        _mainTabV.contentOffset = CGPointMake(0, 0);
    }
    else
    {
        [self.view addAlertViewWithMessage:@"没有数据不能排序" andTarget:self];
    }
}

#pragma mark - 一级菜单点击事件回调
- (void)firstMenu:(MenuCell *)cell
{
    _firstMenu = cell.tag - kSmallCellTag;
    _seconMenu = 0;
    
    NSString *titl = [[[_firstMenuArray objectAtIndex:_firstMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
    UIButton *btn = (UIButton *)[self.view viewWithTag:kLeftButtonTag];
    [btn setTitle:titl forState:UIControlStateNormal];
    self.title = titl;
    _smallTabV.hidden = YES;
    [self changeOriginalWithButtonTag:kLeftButtonTag];
    _seconMenudArray = [[_firstMenuArray objectAtIndex:_firstMenu] objectForKey:@"submenus"];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:kMiddleButtonTag];
    [btn2 setTitle:[[[_seconMenudArray objectAtIndex:0] objectForKey:@"info"] objectForKey:@"classifyname"] forState:UIControlStateNormal];
    
    _currentRequestPage = 1;
    _classifyid = [[[_firstMenuArray objectAtIndex:_firstMenu] objectForKey:@"info"] objectForKey:@"classifyid"];
    [self startRequestMainDataWithAnimotion:YES];
}

#pragma mark - 改变cell选中状态（任何时刻只能有一个被选中）
- (void)changeSelectedCell:(MenuCell *)cell andBaseTag:(NSInteger)tag andSumCounts:(NSInteger)counts
{
    for (int i = 0;i < counts;i ++)
    {
        MenuCell *newCell = (MenuCell *)[self.view viewWithTag:i+tag];
        if (cell.tag == newCell.tag)
        {
            newCell.selectedLable.hidden = NO;
            newCell.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
        }
        else
        {
            newCell.selectedLable.hidden = YES;
            if (tag == kLeftCellTag)
            {
                newCell.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
            }
            else
            {
                newCell.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
            }
        }
    }
}


#pragma mark - 组建菜单数据结构
- (void)makeUpMenuArray
{
    _firstMenuArray = [[NSMutableArray alloc]init];
    _seconMenudArray = [[NSMutableArray alloc]init];
    _thirdMenuArray = [[NSMutableArray alloc]init];

    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    _firstMenuArray = [defauls objectForKey:@"MENUARRAY"];
//    NSLog(@"%@",_firstMenuArray);
    _seconMenudArray = [[[defauls objectForKey:@"MENUARRAY"] objectAtIndex:_firstMenu] objectForKey:@"submenus"];
//    NSLog(@"%@",_seconMenudArray);
    _thirdMenuArray = [[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"submenus"];
//    NSLog(@"%@",_thirdMenuArray);
}

#pragma mark - 触空白收起菜单
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesBegan");
    _smallTabV.hidden = YES;
    _leftTabV.hidden = YES;
    _rightTabV.hidden = YES;
    [self changeOriginalWithButtonTag:kLeftButtonTag];
    [self changeOriginalWithButtonTag:kMiddleButtonTag];
    [self changeOriginalWithButtonTag:kRightButtonTag];
}


#pragma mark - 菜单按钮被点击
- (void)buttonClicked:(MenuButton *)btn
{
    if (btn.selected)
    {
        btn.selected = NO;
        _smallTabV.hidden = YES;
        _leftTabV.hidden = YES;
        _rightTabV.hidden = YES;
    }
    else
    {
        [self changeButtonSelectedWithButtonTag:btn.tag];
        switch (btn.tag)
        {
            case kLeftButtonTag:
            {
                _paiXu = NO;
                [self.view bringSubviewToFront:_smallTabV];
                _smallTabV.hidden = NO;
                [_smallTabV reloadData];
                [self changeTableViewFrameWithTag:_smallTabV.tag andCount:_firstMenuArray.count];
                [self makeTableViewAlone:NO];
            }
                break;
            case kLeftButtonTag+1:
            {
//                NSLog(@"产品分类");
                [self makeTableViewAlone:YES];
                _seconMenudArray = [[_firstMenuArray objectAtIndex:_firstMenu] objectForKey:@"submenus"];
                [self changeTableViewFrameWithTag:_leftTabV.tag andCount:_seconMenudArray.count];
                if (!(_seconMenu < _seconMenudArray.count))
                {
                    _seconMenu = 0;
                }
                _thirdMenuArray = [[_seconMenudArray objectAtIndex:_seconMenu] objectForKey:@"submenus"];
                [self.view bringSubviewToFront:_leftTabV];
                _leftTabV.hidden = NO;
                [_leftTabV reloadData];
                [self.view bringSubviewToFront:_rightTabV];
                _rightTabV.hidden = NO;
                [_rightTabV reloadData];
            }
                break;
            case kLeftButtonTag+2:
            {
                [self makeTableViewAlone:NO];
                _paiXu = YES;
                [self.view bringSubviewToFront:_smallTabV];
                _smallTabV.hidden = NO;
                [_smallTabV reloadData];
                [self changeTableViewFrameWithTag:_smallTabV.tag andCount:_pXrray.count];
            }
                break;
            default:
                break;
        }
    }
}

- (void)changeOriginalWithButtonTag:(NSInteger)buttonTag
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:buttonTag];
    btn.selected = NO;
}

#pragma mark - 改变按钮选中状态
- (void)changeButtonSelectedWithButtonTag:(NSInteger)tag
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
    for (int i = 0; i < 3; i ++)
    {
        UIButton *newBtn = (UIButton *)[self.view viewWithTag:i+kLeftButtonTag];
        if (btn.tag == newBtn.tag)
        {
            newBtn.selected = YES;
        }
        else
        {
            newBtn.selected = NO;
        }
    }
}

#pragma mark - 控制产品菜单、排序菜单、主菜单不能同时出现
- (void)makeTableViewAlone:(BOOL)product
{
    _smallTabV.hidden = product;
    _leftTabV.hidden = !product;
    _rightTabV.hidden = !product;
}

#pragma mark - 刷新一级分类（排序）列表（变换位置）
- (void)reloadSmallTableViewWithPaiXu:(BOOL)isPx
{
    _paiXu = isPx;
    [self.view bringSubviewToFront:_smallTabV];
    
    CGRect rect = _smallTabV.frame;
    if (isPx)
    {
        rect.origin.x = kScreenWidth*2/3;
    }
    else
    {
        rect.origin.x = 0;
    }
    _smallTabV.frame = rect;
    _smallTabV.hidden = NO;
    [_smallTabV reloadData];
}

#pragma mark - 根据数据改变菜单的高度
- (void)changeTableViewFrameWithTag:(NSInteger)tag andCount:(NSInteger)counts
{
    UITableView *tabV = (UITableView *)[self.view viewWithTag:tag];
    CGRect rect = tabV.frame;
    if (counts*35<kScreenHeight-100)
    {
        rect.size.height = counts*35;
    }
    else
    {
        rect.size.height = kScreenHeight-100;
    }
    tabV.frame = rect;
}

#pragma mark - 时间排序
- (void)timeSort
{
    for (int i = 0; i < _mainArray.count-1; i ++)
    {
        NSDictionary *dict = [_mainArray objectAtIndex:i];
        NSDate *date1 = [self stringChangToDate:[dict objectForKey:@"updatetime"]];
        for (int j = i +1; j < _mainArray.count; j++)
        {
            NSDictionary *dict2 = [_mainArray objectAtIndex:j];
            NSDate *date2 = [self stringChangToDate:[dict2 objectForKey:@"updatetime"]];
            if ([date1 compare:date2] == NSOrderedAscending)
            {
                [self exchangeObjectIndex:i andIndex:j];
            }
        }
    }
}
#pragma mark -- 交换位置（排序）
- (void)exchangeObjectIndex:(NSInteger)x andIndex:(NSInteger )y
{
    NSDictionary *dic = [_mainArray objectAtIndex:x];
    NSDictionary *dict2 = [_mainArray objectAtIndex:y];
    [_mainArray replaceObjectAtIndex:x withObject:dict2];
    [_mainArray replaceObjectAtIndex:y withObject:dic];
}

#pragma mark -- 字符串转时间
- (NSDate *)stringChangToDate:(NSString *)string
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    return inputDate;
}

#pragma mark - 浏览量排序
- (void)seenumberSort
{
    if (_mainArray.count > 1)
    {
        for (int i = 0; i < _mainArray.count-1; i ++)
        {
            NSDictionary *dict = [_mainArray objectAtIndex:i];
            NSInteger seenum1 = [[dict objectForKey:@"seenum"] integerValue];
            for (int j = i +1; j < _mainArray.count; j++)
            {
                NSDictionary *dict2 = [_mainArray objectAtIndex:j];
                NSInteger seenum2 = [[dict2 objectForKey:@"seenum"] integerValue];
                if (seenum1<=seenum2)
                {
                    [self exchangeObjectIndex:i andIndex:j];
                }
            }
        }

    }
}

#pragma mark - 左侧菜单
-(void)popToLeftMenu
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --下拉刷新
- (void)createRefreshView
{
    if (_refresV && [_refresV superview]) {
        [_refresV removeFromSuperview];
    }
    _refresV = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refresV.delegate = self;
    [_mainTabV addSubview:_refresV];
    [_refresV refreshLastUpdatedDate];
}

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
        [self startRequestMainDataWithAnimotion:NO];
    }
}

- (void)stopRefresh
{
    _reloading = NO;
    [_refresV egoRefreshScrollViewDataSourceDidFinishedLoading:_mainTabV];
    [_refresV reloadInputViews];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kMainTabTag)
    {
        [_refresV egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag == kMainTabTag)
    {
        [_refresV egoRefreshScrollViewDidEndDragging:scrollView];
    }
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
