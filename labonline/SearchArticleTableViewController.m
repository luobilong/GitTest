//
//  SearchArticleTableViewController.m
//  labonline
//
//  Created by 引领科技 on 15/5/21.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SearchArticleTableViewController.h"
#import "UIView+Category.h"
#import "AFNetworkTool.h"
#import "EJTListCell.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailViewController.h"
#import "SearchCell.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface SearchArticleTableViewController (){
    NSArray *_searchDataArray;//搜索回来的数据
    
    BOOL _reloading;
    EGORefreshTableHeaderView *_refresV;

}

@end

@implementation SearchArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 36) andBackImageWithName:@"返回角.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(popBack);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"检索结果";
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _searchDataArray = [[NSMutableArray alloc]init];
     NSDictionary *paramDic = @{@"labelid":@"1",@"label":_searchStr,@"querytype":_querytypeStr};
    [self requestWithUrl:kSearchUrl Params:paramDic];

    [self createRefreshView];
}

#pragma mark --网络请求
- (void)requestWithUrl:(NSString *)url Params:(NSDictionary *)dict
{
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
             _searchDataArray = [[dic objectForKey:@"data"] objectForKey:@"resultList"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchDataArray.count;;
}

#pragma mark -- 绘制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:self options:0] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [_searchDataArray objectAtIndex:indexPath.row];
    cell.titleLable.text = [dic objectForKey:@"title"];
    cell.detailLable.text = [dic objectForKey:@"type"];
    cell.LookCountLable.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"seenum"] integerValue]];

    return cell;
}

#pragma mark -- 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark -- 选中cell 进入详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_searchDataArray objectAtIndex:indexPath.row];
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.articalDic = dict;
    detailVC.delegate = self;
    detailVC.action = @selector(addReadCounts);
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - 增加阅读数
- (void)addReadCounts
{
    NSDictionary *paramDic = @{@"labelid":@"1",@"label":_searchStr,@"querytype":_querytypeStr};
    [self requestWithUrl:kSearchUrl Params:paramDic];

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
        NSDictionary *paramDic = @{@"labelid":@"1",@"label":_searchStr,@"querytype":_querytypeStr};
        [self requestWithUrl:kSearchUrl Params:paramDic];
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
