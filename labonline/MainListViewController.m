//
//  MainListViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/31.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainListViewController.h"
#import "MainListCell.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "SearchViewController.h"
#import "NetManager.h"
#import "UIView+Category.h"
#import "EGORefreshTableHeaderView.h"


@interface MainListViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *_listTableView;
    NSArray *_listArray;
    BOOL _addReadCounts;
    NSInteger _currentCellIndex;
    NSInteger _selectedIndex;
    EGORefreshTableHeaderView *_refresV;
    BOOL _reloading;
    BOOL _netRequest;
}
@end

@implementation MainListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    _reloading = NO;
    self.title = @"杂志名";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([DeviceManager deviceVersion]>=7)
    {
        //界面调整
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }

    // 左侧按钮
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 40) andBackImageWithName:@"返回角.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(backToPrePage);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchViewController);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _addReadCounts = NO;
//    _listArray = @[@"心脑血管疾病预防",@"宝洁医疗诊断相机设计",@"医学世界",@"心脑血管疾病预防"];
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-10) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_listTableView];
    
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
    [self requestMainDataWithURLString:[NSString stringWithFormat:@"%@?id=%@",kMainListUrlString,_magazineId]];
    [self createRefreshView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_netRequest)
    {
        [[NetManager getShareManager] cancelRequestOperation];
    }
}

#pragma mark - 网络请求
#pragma mark -- 开始请求
- (void)requestMainDataWithURLString:(NSString *)urlStr
{
    _netRequest = YES;
    NetManager *netManager = [NetManager getShareManager];
    netManager.delegate = self;
    netManager.action = @selector(requestFinished:);
    [netManager requestDataWithUrlString:urlStr];
}
#pragma mark --网络请求完成
- (void)requestFinished:(NetManager *)netManager
{
    _netRequest = NO;
    if (_reloading)
    {
        [self stopRefresh];
    }
    else
    {
        // 删除加载View
        [self.view removeLoadingVIewInView:self.view andTarget:self];
    }
    if (netManager.downLoadData)
    {
        // 成功
        // 解析
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        _listArray = [dict objectForKey:@"data"];
        
        if ([_listArray count])
        {
            if ([[[_listArray objectAtIndex:0] objectForKey:@"article"] count])
            {
                NSDictionary *subdict = [[[_listArray objectAtIndex:0] objectForKey:@"article"] lastObject];
                self.title = [subdict objectForKey:@"magazinename"];
            }
        }
        
        [_listTableView reloadData];
    }
    else
    {
        // 失败
        [self.view addAlertViewWithMessage:@"请求不到数据，请重试" andTarget:self];
    }
}


#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    MainListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MainListCell" owner:self options:0] lastObject];
        cell.target = self;
        cell.action = @selector(enterDetail:);
    }
    
    if (_addReadCounts && _currentCellIndex == indexPath.row)
    {
        cell.addReadCounts = YES;
        cell.selectedIndex = _selectedIndex;
    }
    cell.listDict = [_listArray objectAtIndex:indexPath.row];
    cell.cellIndex = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 根据文章数确定cell高度
    NSArray *subArr = [[_listArray objectAtIndex:indexPath.row] objectForKey:@"article"];
    return 30*subArr.count+35;;
}

#pragma mark - 进入文章详情
- (void)enterDetail:(MainListCell *)cell
{
    _currentCellIndex = cell.cellIndex;
    _selectedIndex = cell.selectedIndex;
    NSDictionary *dict = [[cell.listDict objectForKey:@"article"] objectAtIndex:cell.selectedIndex];
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.articalDic = dict;
    detailVC.delegate = self;
    detailVC.action = @selector(addReadCounts);
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 返回上一页
- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
//    NSLog(@"enterSearchViewController");
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)addReadCounts
{
    _addReadCounts = YES;
    [_listTableView reloadData];
}

#pragma mark --下拉刷新
- (void)createRefreshView
{
    if (_refresV && [_refresV superview]) {
        [_refresV removeFromSuperview];
    }
    _refresV = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refresV.delegate = self;
    [_listTableView addSubview:_refresV];
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
        [self requestMainDataWithURLString:[NSString stringWithFormat:@"%@?id=%@",kMainListUrlString,_magazineId]];
    }
}

- (void)stopRefresh
{
    _reloading = NO;
    [_refresV egoRefreshScrollViewDataSourceDidFinishedLoading:_listTableView];
    [_listTableView reloadInputViews];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresV egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresV egoRefreshScrollViewDidEndDragging:scrollView];
}



- (void)didReceiveMemoryWarning
{
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
