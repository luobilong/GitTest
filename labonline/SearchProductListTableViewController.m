//
//  SearchProductListTableViewController.m
//  labonline
//
//  Created by 引领科技 on 15/5/21.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SearchProductListTableViewController.h"
#import "UIView+Category.h"
#import "AFNetworkTool.h"
#import "EJTListCell.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface SearchProductListTableViewController (){
    NSMutableArray *_mainArray;
    
    int _currentRequestPage;
    UIView *_loadingMoreView;
    NSDictionary *_loadingPageDic;
    BOOL _loadMore;
//    NSInteger _currentSubVIndex;
//    NSInteger _currentCellIndex;//进入的cell

    BOOL _reloading;
    EGORefreshTableHeaderView *_refresV;
}

@end

#define pageCount 10

@implementation SearchProductListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 36) andBackImageWithName:@"返回角.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(popBack);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"检索结果";
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
     _mainArray = [[NSMutableArray alloc]init];
    _currentRequestPage=1;
    NSDictionary *paramDic = @{@"currentPage":@"1",@"keyword":_searchStr,@"pageSize":[NSString stringWithFormat:@"%d",pageCount]};
    [self requestWithUrl:kSearchProductUrl Params:paramDic];
    
    [self createRefreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mainArray.count;
}

#pragma mark --网络请求
- (void)requestWithUrl:(NSString *)url Params:(NSDictionary *)dict
{
    NSLog(@"%@",url);
    if (_reloading)
    {
        [self stopRefresh];
    }
    else
    {
        [self.view removeLoadingVIewInView:self.view andTarget:self];
    }
    [AFNetworkTool postJSONWithUrl:url parameters:dict success:^(id responseObject)
     {
         [self.view removeLoadingVIewInView:self.view andTarget:self];
         
         // 搜索结果
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
         if ([[dic objectForKey:@"respCode"] intValue] == 1000)
         {
             _loadingPageDic = [dic objectForKey:@"pageBean"];
             [self createLoadingMoreView];
//             NSLog(@"%@",_mainArray);
             if (!_loadMore)
             {
                 [_mainArray removeAllObjects];
             }
//             _mainArray = [[dic objectForKey:@"data"] objectForKey:@"productList"];直接这样赋值会导致上面removeAllObjects方法报错，应用如下方式给_mainArray赋值
             [_mainArray addObjectsFromArray:[[dic objectForKey:@"data"] objectForKey:@"productList"]];

             _loadMore = NO;
             [self.tableView reloadData];
         }
         else
         {
             [self.view addAlertViewWithMessage:[dic objectForKey:@"remark"] andTarget:self];
         }
         
     } fail:^{
         [self.view removeLoadingVIewInView:self.view andTarget:self];
         [self.view addAlertViewWithMessage:@"搜索失败" andTarget:self];
     }];
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
    
    NSDictionary *paramDic = @{@"currentPage":[NSString stringWithFormat:@"%d",_currentRequestPage],@"keyword":_searchStr,@"pageSize":[NSString stringWithFormat:@"%d",pageCount]};
    [self requestWithUrl:kSearchProductUrl Params:paramDic];
}

#pragma mark -- cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EJTListCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row
//                                                                                    inSection:indexPath.section]];
//    _currentCellIndex=indexPath.row;
//    _currentSubVIndex=[cell.yLCountLabel.text intValue]+1;
    // 选中产品信息 进入产品详情
    NSDictionary *proD = [_mainArray objectAtIndex:indexPath.row];
    ProductDetailViewController *proDetail=[[ProductDetailViewController alloc] init];
    proDetail.proDetail=proD;
    proDetail.delegate = self;
    proDetail.action = @selector(addReadCounts);
    [self.navigationController pushViewController:proDetail animated:YES];
}
#pragma mark - 增加阅读数
- (void)addReadCounts
{
    NSDictionary *paramDic = @{@"currentPage":[NSString stringWithFormat:@"%d",_currentRequestPage],@"keyword":_searchStr,@"pageSize":[NSString stringWithFormat:@"%d",pageCount]};
    [self requestWithUrl:kSearchProductUrl Params:paramDic];
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
#pragma mark - 返回上一页
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --下拉刷新
- (void)createRefreshView
{
    if (_refresV && [_refresV superview]) {
        [_refresV removeFromSuperview];
    }
    _refresV = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refresV.delegate = self;
    [self.tableView addSubview:_refresV];
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
        _currentRequestPage=1;
        NSDictionary *paramDic = @{@"currentPage":@"1",@"keyword":_searchStr,@"pageSize":[NSString stringWithFormat:@"%d",pageCount]};
        [self requestWithUrl:kSearchProductUrl Params:paramDic];
    }
}

- (void)stopRefresh
{
    _reloading = NO;
    [_refresV egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
