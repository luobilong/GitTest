//
//  JiShuZhuanLanViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JiShuZhuanLanViewController.h"
#import "PictureShowView.h"
#import "JiShuZhuanLanCell.h"
#import "JiShuZhuanLanSubView.h"
#import "JiShuZhuanLanMoreViewController.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "YRSideViewController.h"
#import "AppDelegate.h"
#import "SearchViewController.h"
#import "NetManager.h"
#import "UIView+Category.h"
#import "EGORefreshTableHeaderView.h"

@interface JiShuZhuanLanViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *jiShuZhuanLanTableView;
    NSArray *_articleListArray;
    NSInteger _currentCellIndex;//进入的cell
    NSInteger _currentSubVIndex;
    BOOL _addReadCounts;
    EGORefreshTableHeaderView *_refresV;
    BOOL _reloading;
    BOOL _netRequesting;
}
@end

@implementation JiShuZhuanLanViewController
#define kImageShowViewHeight (kScreenHeight*130/480)
#define kCellHeight 245
#define kCellBaseHeight 45
#define kCellAloneArticalHeight 40



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _reloading = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"技术专栏";
    
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 设置左右按钮
    // 左侧按钮
    NavigationButton *leftButton;
    if (_enterFromHome)
    {
        leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30) andBackImageWithName:@"tubiao_04.png"];
        leftButton.action = @selector(popToLeftMenu);
    }
    else
    {
        leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 40) andBackImageWithName:@"返回角.png"];
        leftButton.action = @selector(popToPrePage);
    }
    leftButton.delegate = self;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    // right
    NavigationButton *rightButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25) andBackImageWithName:@"aniu_09.png"];
    rightButton.delegate = self;
    rightButton.action = @selector(enterSearchViewController);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _addReadCounts = NO;
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, kImageShowViewHeight+10)];
    headerV.backgroundColor = [UIColor clearColor];
    PictureShowView *pictureV = [[PictureShowView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, kImageShowViewHeight)];
    pictureV.target = self;
    pictureV.imageInfoArray = @[];
    pictureV.action = @selector(pictureShowMethod:);
    pictureV.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:pictureV];
    
    jiShuZhuanLanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    jiShuZhuanLanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    jiShuZhuanLanTableView.delegate = self;
    jiShuZhuanLanTableView.dataSource = self;
    jiShuZhuanLanTableView.showsVerticalScrollIndicator = NO;
    jiShuZhuanLanTableView.tableHeaderView = headerV;
    [self.view addSubview:jiShuZhuanLanTableView];
    
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
    [self requestMainDataWithURLString:kJSZLUrlString];
    [self createRefreshView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_netRequesting)
    {
        [[NetManager getShareManager] cancelRequestOperation];
    }
}

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
        // 删除加载View
        [self.view removeLoadingVIewInView:self.view andTarget:self];
    }
    if (netManager.downLoadData)
    {
        // 成功
        // 解析
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        _articleListArray = [[dict objectForKey:@"data"] objectForKey:@"articleList"];
        [jiShuZhuanLanTableView reloadData];
    }
    else
    {
        // 失败
        [self.view addAlertViewWithMessage:@"请求不到数据，请重试" andTarget:self];
    }
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articleListArray.count>=5?5:_articleListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"JiShuZhuanLanCell";
    JiShuZhuanLanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JiShuZhuanLanCell" owner:self options:0] lastObject];
        cell.target = self;
        cell.jszlViewClickedAction = @selector(enterDetailViewController:);
        cell.buttonClickSelector = @selector(enterMoreViewController:);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dataIndex = indexPath.row;
    if (_addReadCounts&&(indexPath.row == _currentCellIndex))
    {
        cell.addReadCounts = YES;
        cell.currentArticalIndex = _currentSubVIndex;
    }
     cell.articleDict = [_articleListArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArr = [[_articleListArray objectAtIndex:indexPath.row] objectForKey:@"article"];
    NSInteger count = (subArr.count>5)?5:subArr.count;
//    NSLog(@"%ld",count);
    return kCellBaseHeight + kCellAloneArticalHeight*count;
}


#pragma mark - 图片轮播-->进入详情
- (void)pictureShowMethod:(PictureShowView *)pictureShowV
{
    NSDictionary *dict = [[pictureShowV.imageInfoArray objectAtIndex:pictureShowV.imageIndex] objectForKey:@"articleinfo"];

    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.articalDic = dict;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- 跳转到技术专栏详情界面
- (void)enterDetailViewController:(JiShuZhuanLanSubView *)jszlSubV
{
    // 此处为了增加阅读数
    if ([jszlSubV.superview isKindOfClass:[JiShuZhuanLanCell class]])
    {
        JiShuZhuanLanCell *cell = (JiShuZhuanLanCell *)jszlSubV.superview;
        _currentCellIndex = cell.dataIndex;
        _currentSubVIndex = cell.currentArticalIndex;
    }
   
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.articalDic = jszlSubV.subDict;
    detailVC.delegate = self;
    detailVC.action = @selector(addReadCounts);
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark --跳转到技术专栏更多界面
- (void)enterMoreViewController:(JiShuZhuanLanCell *)cell
{
    // 进入更多
    // 更多 跳转页面
    JiShuZhuanLanMoreViewController *moreVC = [[JiShuZhuanLanMoreViewController alloc]init];
    moreVC.typeId = [[_articleListArray objectAtIndex:cell.dataIndex] objectForKey:@"type_id"];
    [self.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark - 返回上一页
- (void)popToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 左侧菜单
-(void)popToLeftMenu
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
}

#pragma mark - 搜索界面
- (void)enterSearchViewController
{
    // 进入搜索界面
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 增加阅读数
- (void)addReadCounts
{
    _addReadCounts = YES;
    [jiShuZhuanLanTableView reloadData];
}


#pragma mark --下拉刷新
- (void)createRefreshView
{
    if (_refresV && [_refresV superview]) {
        [_refresV removeFromSuperview];
    }
    _refresV = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refresV.delegate = self;
    [jiShuZhuanLanTableView addSubview:_refresV];
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
        [self requestMainDataWithURLString:kJSZLUrlString];
    }
}

- (void)stopRefresh
{
    _reloading = NO;
    [_refresV egoRefreshScrollViewDataSourceDidFinishedLoading:jiShuZhuanLanTableView];
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
