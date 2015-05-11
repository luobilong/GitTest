//
//  MyCollectionViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionCell.h"
#import "NetManager.h"
#import "UIView+Category.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ProductCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailViewController.h"

@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UIScrollView *backScrollV;
    UITableView *_myCollectionTableView;
    UITableView *_myProductTableView;
    NSArray *_collectionArray;
    NSArray *_productArray;
    BOOL _deleteCollection;
    NSString *_articalId;
    NSString *_userid;
    BOOL _reloading;
    EGORefreshTableHeaderView *_refresV;
    
    BOOL _netRequesting;
    BOOL _removeProductCollection;
}

@end

@implementation MyCollectionViewController
#define kAskViewWidth 220
#define kAskViewHeight 100
#define kAskViewTag 5656

#define kSureButtonTag 5757
#define kNOtSureButtonTag 5758
#define kSuresButtonHeight 60

#define kLineLabelTag 6666
#define kLeftButtonTag 7777
#define kRightButtonTag 7778

#define kMyCollectionTableViewTag 888
#define kMyProductTableViewTag 889
#define kBackScrollViewTag 890
#define kProductRemoveButtonTag 900

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _deleteCollection = NO;
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // 左侧
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 35, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"返回角.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToPrePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, kScreenWidth/2, 30)];
    [leftBtn setTitle:@"文章收藏" forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1]];
    [leftBtn setTitleColor:[UIColor colorWithWhite:122/255.0 alpha:1] forState:UIControlStateNormal];
    leftBtn.selected = YES;
    leftBtn.tag = kLeftButtonTag;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    [leftBtn addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 30)];
    [rightBtn setTitle:@"产品收藏" forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1]];
    [rightBtn setTitleColor:[UIColor colorWithWhite:122/255.0 alpha:1] forState:UIControlStateNormal];
    rightBtn.tag = kRightButtonTag;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    [rightBtn addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    UILabel *linLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth/2, 2)];
    linLabel.tag = kLineLabelTag;
    linLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:linLabel];
    
    backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, kScreenHeight-100)];
    backScrollV.delegate = self;
    backScrollV.tag = kBackScrollViewTag;
    backScrollV.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-100);
    backScrollV.pagingEnabled = YES;
    backScrollV.showsHorizontalScrollIndicator = NO;
    backScrollV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backScrollV];
    
    _myCollectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, backScrollV.frame.size.height) style:UITableViewStylePlain];
    _myCollectionTableView.delegate = self;
    _myCollectionTableView.dataSource = self;
    _myCollectionTableView.showsVerticalScrollIndicator = NO;
    _myCollectionTableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _myCollectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myCollectionTableView.tag = kMyCollectionTableViewTag;
    [backScrollV addSubview:_myCollectionTableView];
    
    _myProductTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, backScrollV.frame.size.height) style:UITableViewStylePlain];
    _myProductTableView.delegate = self;
    _myProductTableView.dataSource = self;
    _myProductTableView.showsVerticalScrollIndicator = NO;
    _myProductTableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _myProductTableView.tag = kMyProductTableViewTag;
    _myProductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [backScrollV addSubview:_myProductTableView];
 
    // 获取收藏列表
    _reloading = NO;
    [self requestDataWithUrlString:[NSString stringWithFormat:@"%@?userid=%@",kMyCollectionUrlString,_userId]];
    [self createRefreshView];
}

#pragma mark - viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_netRequesting)
    {
        [[NetManager getShareManager] cancelRequestOperation];
    }
}

#pragma mark - 按钮点击事件
- (void)topButtonClicked:(UIButton *)btn
{
    UILabel *lineLab = (UILabel *)[self.view viewWithTag:kLineLabelTag];
    [UIView animateWithDuration:0.4 animations:^{
        lineLab.frame = CGRectMake(kScreenWidth/2*(btn.tag-kLeftButtonTag), 30, kScreenWidth/2, 2);
        backScrollV.contentOffset = CGPointMake(kScreenWidth*(btn.tag-kLeftButtonTag), 0);
    }];
}

#pragma mark - 网络请求
#pragma mark --- 开始请求
- (void)requestDataWithUrlString:(NSString *)urlString
{
    _netRequesting = YES;
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
    NetManager *netManager = [NetManager getShareManager];
    netManager.delegate = self;
    netManager.action = @selector(netManagerCallBack:);
    [netManager requestDataWithUrlString:urlString];
}

#pragma mark --- 网络回调
- (void)netManagerCallBack:(NetManager *)netManager
{
    _netRequesting = NO;
    if (_reloading)
    {
        [self stopRefresh];
    }
     [self.view removeLoadingVIewInView:self.view andTarget:self];
//    else
//    {
//        [self.view removeLoadingVIewInView:self.view andTarget:self];
//    }
    if (_deleteCollection)
    {
        _deleteCollection = NO;
        // 删除收藏
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        if ([[dic objectForKey:@"respCode"] integerValue] == 1000)
        {
            [self requestDataWithUrlString:[NSString stringWithFormat:@"%@?userid=%@",kMyCollectionUrlString,_userId]];
        }
        else
        {
            [self.view addAlertViewWithMessage:[dic objectForKey:@"remark"] andTarget:self];
        }
    }
    else
    {
        // 我的收藏列表
        if (netManager.failError)
        {
            // 失败
             [self.view addAlertViewWithMessage:@"请求数据失败，请重试" andTarget:self];
        }
        else if (netManager.downLoadData)
        {
            // 成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
            NSInteger respCode = [[dic objectForKey:@"respCode"] integerValue];
            if (respCode == 1000)
            {
                // 成功
                _collectionArray= [dic objectForKey:@"list"];
                _productArray = [dic objectForKey:@"productList"];
                [_myCollectionTableView reloadData];
                [_myProductTableView reloadData];
            }
            else
            {
                [self.view addAlertViewWithMessage:[dic objectForKey:@"remark"] andTarget:self];
            }
        }
    }
}



#pragma mark - 返回上一页
- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
#pragma mark -- 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kMyCollectionTableViewTag)
    {
        return _collectionArray.count;
    }
    else
    {
        return _productArray.count;
    }
}
#pragma mark -- 绘制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMyCollectionTableViewTag)
    {
        static NSString *cellIdentifer = @"MyCollectionCell";
        MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCollectionCell" owner:self options:0] lastObject];
            cell.target = self;
            cell.action = @selector(deleteMyCollection:);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.cellIndex = indexPath.row;
        cell.infoDict = [_collectionArray objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        static NSString *cellId = @"ProductCollectionCell";
        ProductCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ProductCollectionCell" owner:self options:0] lastObject];
        }
        NSDictionary *dict = [_productArray objectAtIndex:indexPath.row];
        cell.productTitleLabel.text = [dict objectForKey:@"producttitle"];
        cell.productDetailLabel.text = [dict objectForKey:@"company"];
        [cell.productImgV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"producticon"]] placeholderImage:[UIImage imageNamed:@"productCollection.png"]];
        [cell.productRemoveButton addTarget:self action:@selector(productRemoveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.productRemoveButton.tag = indexPath.row+kProductRemoveButtonTag;
        return cell;
    }
}

#pragma mark - 删除产品收藏
- (void)productRemoveButtonClicked:(UIButton *)btn
{
    _articalId = [[_productArray objectAtIndex:btn.tag-kProductRemoveButtonTag] objectForKey:@"productid"];
//    NSDictionary *dic = [_productArray objectAtIndex:btn.tag-kProductRemoveButtonTag];
//    NSString *productId = [dic objectForKey:@"productid"];
//    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
//    NSString *productUrl = [NSString stringWithFormat:@"%@?userid=%@&articleid=%@",kDeleteCollectionUrl,userid,productId];
////    NSLog(@"%@",productUrl);
//    _removeProductCollection = YES;
    [self createDeleteView];
//    [self requestDataWithUrlString:productUrl];
}

#pragma mark - MyCollectionCell callBack
- (void)deleteMyCollection:(MyCollectionCell *)cell
{
    /* 删除收藏
     http://192.168.0.153:8181/labonline/hyController/deleteWdsc.do?userid=5&articleid=6
     */
    _articalId = [[_collectionArray objectAtIndex:cell.cellIndex] objectForKey:@"articleid"];
    [self createDeleteView];
}

#pragma mark --高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMyCollectionTableViewTag)
    {
        return 66;
    }
    else
    {
        return 120;
    }
}

#pragma mark --点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kMyCollectionTableViewTag)
    {
        // 阅读
        NSDictionary *dic =[ _collectionArray objectAtIndex:indexPath.row];
        JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
        detailVC.articalDic = dic;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (tableView.tag == kMyProductTableViewTag)
    {
        ProductDetailViewController *proDV=[[ProductDetailViewController alloc] init];
        proDV.proDetail = [_productArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:proDV animated:YES];
    }
    
}



#pragma mark - 创建删除弹出框
- (void)createDeleteView
{
    UIView *askV = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-kAskViewWidth)/2, (kScreenHeight-kAskViewWidth)/2, kAskViewWidth, kAskViewHeight)];
    askV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    askV.layer.masksToBounds = YES;
    askV.tag = kAskViewTag;
    askV.userInteractionEnabled = YES;
    askV.layer.cornerRadius = 5;
    askV.layer.borderColor = [UIColor colorWithRed:223/255.0 green:45/255.0 blue:82/255.0 alpha:1].CGColor;
    askV.layer.borderWidth = 1;
    [self.view addSubview:askV];
    
    NSInteger space = (kAskViewWidth-kSuresButtonHeight*2)/3;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = kNOtSureButtonTag;
    [leftBtn setFrame:CGRectMake(space, 20, kSuresButtonHeight, kSuresButtonHeight)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"取消.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [askV addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(kAskViewWidth-kSuresButtonHeight-space, 20, 60, 60)];
    rightBtn.tag = kSureButtonTag;
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"确定.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [askV addSubview:rightBtn];
}

#pragma mark - 是否删除
- (void)sureButtonClicked:(UIButton *)btn
{
    switch (btn.tag)
    {
        case kSureButtonTag:
        {
            // 删除
            /* 删除收藏
             http://192.168.0.153:8181/labonline/hyController/deleteWdsc.do?userid=5&articleid=6
             */
            _deleteCollection = YES;
            NSString *urlString = [NSString stringWithFormat:@"%@?userid=%@&articleid=%@",kDeleteCollectionUrl,_userId,_articalId];
            [self requestDataWithUrlString:urlString];
        }
            break;
        case kNOtSureButtonTag:
        {
            // 取消
            
        }
            break;
            
        default:
            break;
    }
    UIView *askV = (UIView *)[self.view viewWithTag:kAskViewTag];
    [askV removeFromSuperview];
}

#pragma mark --下拉刷新
- (void)createRefreshView
{
    if (_refresV && [_refresV superview]) {
        [_refresV removeFromSuperview];
    }
    _refresV = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refresV.delegate = self;
    [_myCollectionTableView addSubview:_refresV];
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
        [self requestDataWithUrlString:[NSString stringWithFormat:@"%@?userid=%@",kMyCollectionUrlString,_userId]];
    }
}

- (void)stopRefresh
{
    _reloading = NO;
    [_refresV egoRefreshScrollViewDataSourceDidFinishedLoading:_myCollectionTableView];
    [_refresV reloadInputViews];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kMyCollectionTableViewTag)
    {
        [_refresV egoRefreshScrollViewDidScroll:scrollView];
    }
    if (scrollView.tag == kBackScrollViewTag)
    {
        UILabel *lineLab = (UILabel *)[self.view viewWithTag:kLineLabelTag];
        [UIView animateWithDuration:0.4 animations:^{
            lineLab.frame = CGRectMake(scrollView.contentOffset.x/2, 30, kScreenWidth/2, 2);
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag == kMyCollectionTableViewTag)
    {
        [_refresV egoRefreshScrollViewDidEndDragging:scrollView];
    }
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
