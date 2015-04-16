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
#import "PDFBrowserViewController.h"
#import "UIView+Category.h"

@interface MainListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_listTableView;
    NSArray *_listArray;
    BOOL _addReadCounts;
    NSInteger _currentCellIndex;
    NSInteger _selectedIndex;
}
@end

@implementation MainListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    self.title = @"杂志名";
    self.view.backgroundColor = [UIColor whiteColor];

    // 左侧按钮
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 25, 26) andBackImageWithName:@"aniu_07.png"];
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
    
    [self requestMainDataWithURLString:[NSString stringWithFormat:@"%@?id=%@",kMainListUrlString,_magazineId]];
}

#pragma mark - 网络请求
#pragma mark -- 开始请求
- (void)requestMainDataWithURLString:(NSString *)urlStr
{
    NetManager *netManager = [[NetManager alloc]init];
    netManager.delegate = self;
    netManager.action = @selector(requestFinished:);
    [netManager requestDataWithUrlString:urlStr];
     [UIView addLoadingViewInView:self.view];
}
#pragma mark --网络请求完成
- (void)requestFinished:(NetManager *)netManager
{
    // 删除加载View
    [UIView removeLoadingVIewInView:self.view];
    if (netManager.downLoadData)
    {
        // 成功
        // 解析
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        _listArray = [dict objectForKey:@"data"];
        [_listTableView reloadData];
    }
    else
    {
        // 失败
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
    if ([[dict objectForKey:@"urlpdf"] length]>5)
    {
        // PDF 跳转PDF页面
        NSLog(@"跳转PDF页面");
        PDFBrowserViewController *pdfBrowseVC = [[PDFBrowserViewController alloc]init];
        pdfBrowseVC.filePath = [dict objectForKey:@"urlpdf"];
        pdfBrowseVC.articalId = [dict objectForKey:@"articleid"];
        pdfBrowseVC.target = self;
        pdfBrowseVC.action = @selector(addReadCounts);
        [self.navigationController pushViewController:pdfBrowseVC animated:YES];
    }
    else if ([[dict objectForKey:@"urlhtml"] length]>5)
    {
        // html
        JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
        if ([[dict objectForKey:@"urlvideo"] length]>5)
        {
            // 视频
            detailVC.vidioUrl = [dict objectForKey:@"urlvideo"];
        }
        detailVC.delegate = self;
        detailVC.action = @selector(addReadCounts);
        detailVC.articalDic = dict;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
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
    NSLog(@"enterSearchViewController");
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)addReadCounts
{
    _addReadCounts = YES;
    [_listTableView reloadData];
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
