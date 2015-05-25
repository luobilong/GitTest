//
//  JiShuZhuanLanMoreViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JiShuZhuanLanMoreViewController.h"
#import "JiShuZhuanLanMoreCell.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "SearchViewController.h"
#import "NetManager.h"
#import "UIView+Category.h"
#import "EGORefreshTableHeaderView.h"



@interface JiShuZhuanLanMoreViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *_tableView;
//    NSArray *_articalArray;
    NSMutableArray *_articalArray;
    NSInteger _currentEnterCell;//进入的cell
    BOOL _addReadCounts;
    EGORefreshTableHeaderView *_refresV;
    BOOL _reloading;
    BOOL _netRequesting;
    
    int _currentRequestPage;
    UIView *_loadingMoreView;
    NSDictionary *_loadingPageDic;
    BOOL _loadMore;
}
@end

@implementation JiShuZhuanLanMoreViewController


#pragma mark - 网络请求
#pragma mark -- 开始请求
- (void)requestMainDataWithURLString:(NSString *)urlStr
{
    _netRequesting = YES;
    NetManager *netManager = [NetManager getShareManager];
    netManager.delegate = self;
    netManager.action = @selector(requestFinished:);
    [netManager requestDataWithUrlString:urlStr];
    
}
#pragma mark --网络请求完成
- (void)requestFinished:(NetManager *)netManager
{
    _netRequesting = NO;
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
        // 成功
        // 解析
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        if ([[dict objectForKey:@"respCode"] integerValue] == 1000)
        {
            _loadingPageDic = [dict objectForKey:@"pageBean"];
            [self createLoadingMoreView];
            if (!_loadMore)
            {
                [_articalArray removeAllObjects];
            }
//            _articalArray = [[dict objectForKey:@"data"] objectForKey:@"article"];
            [_articalArray addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"article"]];
//            NSLog(@"%@",dict);
            _loadMore = NO;
            [_tableView reloadData];
        }
        
    }
    else
    {
        // 失败
        [self.view addAlertViewWithMessage:@"请求不到数据，请重试" andTarget:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_netRequesting)
    {
        [[NetManager getShareManager] cancelRequestOperation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _reloading = NO;
    self.title = @"生物检验";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    // 设置左右按钮
    // 左侧按钮
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 40) andBackImageWithName:@"返回角.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(popToPrePage);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchViewController);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _addReadCounts = NO;

    // tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10,kScreenWidth, kScreenHeight-75-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
    _articalArray = [[NSMutableArray alloc]init];
    _currentRequestPage=1;
    NSString *newStrUrl=[kJSZLMoreUrlString stringByAppendingFormat:@"&urrentPage=%d&pageSize=10",_currentRequestPage];
    [self requestMainDataWithURLString:[NSString stringWithFormat:newStrUrl,_typeId]];
    [self createRefreshView];
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
#pragma mark - 尾部视图 加载更多
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _loadingMoreView;
}
#pragma mark -- 去掉多余的线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _loadingMoreView.frame.size.height;
}

#pragma mark - 加载更多按钮点击事件
- (void)loadMoreButonClicked:(UIButton *)btn
{
    // 加载更多
    _loadMore = YES;
    _currentRequestPage ++;
    
    NSString *newStrUrl=[kJSZLMoreUrlString stringByAppendingFormat:@"&currentPage=%d&pageSize=10",_currentRequestPage];
    [self requestMainDataWithURLString:[NSString stringWithFormat:newStrUrl,_typeId]];
}

#pragma mark - 返回上一页
- (void)popToPrePage
{
    // back
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    JiShuZhuanLanMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JiShuZhuanLanMoreCell" owner:self options:0] lastObject];
    }
    cell.subDict = [_articalArray objectAtIndex:indexPath.row];
    if (_addReadCounts&&(indexPath.row==_currentEnterCell))
    {
        cell.youLanCountsLable.text = [NSString stringWithFormat:@"%ld",[[[_articalArray objectAtIndex:indexPath.row] objectForKey:@"seenum"] integerValue]+1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentEnterCell = indexPath.row;
    NSDictionary *subDic = [_articalArray objectAtIndex:indexPath.row];
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.articalDic = subDic;
    detailVC.delegate = self;
    detailVC.action = @selector(addReadCounts);
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - 增加阅读数
- (void)addReadCounts
{
//    _addReadCounts = YES;
//    [_tableView reloadData];
    [self requestMainDataWithURLString:[NSString stringWithFormat:kJSZLMoreUrlString,_typeId]];
}

#pragma mark --下拉刷新
- (void)createRefreshView
{
    if (_refresV && [_refresV superview]) {
        [_refresV removeFromSuperview];
    }
    _refresV = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refresV.delegate = self;
    [_tableView addSubview:_refresV];
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
        [self requestMainDataWithURLString:[NSString stringWithFormat:kJSZLMoreUrlString,_typeId]];
    }
}

- (void)stopRefresh
{
    _reloading = NO;
    [_refresV egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    [_refresV reloadInputViews];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresV egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresV egoRefreshScrollViewDidEndDragging:scrollView];
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
