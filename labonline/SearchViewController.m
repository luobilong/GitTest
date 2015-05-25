//
//  SearchViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "AFNetworkTool.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "UIView+Category.h"
#import "SearchProductListTableViewController.h"
#import "SearchArticleTableViewController.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_moNiDataArray;// 标签的数据
    NSArray *_searchDataArray;//搜索回来的数据
    UITextField *searchTextField;
     UIView *touView;// 标签View
    NSInteger _markHeaderHeight;// 标签View的高度
    UITableView *_tableV;
    NSInteger _markCellIndex;// 标记当前观看的文章 增加阅读数
    BOOL _addReadCounts;// 是否增加阅读数
    BOOL _requestSubLebel;// 请求标签
}
@end

@implementation SearchViewController
#define kTouViewHeight 35
#define kMarkButtonTag 66

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 左侧按钮
    NavigationButton *leftButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 35, 36) andBackImageWithName:@"返回角.png"];
    leftButton.delegate = self;
    leftButton.action = @selector(popBack);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
//    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
//    searchTextField.keyboardType = UIKeyboardTypeNamePhonePad;
//    searchTextField.delegate = self;
//    searchTextField.textColor = [UIColor redColor];
//    searchTextField.font = [UIFont systemFontOfSize:kOneFontSize];
//    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.navigationItem.title = @"检索";
    
//    UIButton *searchBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchBUtton setFrame:CGRectMake(0, 0, 50, 25)];
//    [searchBUtton setTitle:@"搜文章" forState:UIControlStateNormal];
//    searchBUtton.layer.masksToBounds = YES;
//    searchBUtton.layer.cornerRadius = 10;
//    searchBUtton.titleLabel.font =[UIFont systemFontOfSize:kTwoFontSize];
//    searchBUtton.backgroundColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
//    [searchBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [searchBUtton addTarget:self action:@selector(searchMethod) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:searchBUtton];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *searchV=[[UIView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, 70)];
//    searchV.backgroundColor=[UIColor redColor];
    [self.view addSubview:searchV];
    
    UIImageView  *shurukImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10,0,kScreenWidth-60*2-20,32)];
    shurukImgV.image = [UIImage imageNamed:@"shurukuang_05.png"];
    [searchV addSubview:shurukImgV];
    
    UIImageView  *searchImgV = [[UIImageView alloc] initWithFrame:CGRectMake(14,2,30,28)];
    searchImgV.image = [UIImage imageNamed:@"aniu_09.png"];
    [searchV addSubview:searchImgV];
    
    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(15+30, 1, kScreenWidth-60*2-20-30-5, 30)];
    searchTextField.borderStyle = UITextBorderStyleNone;//UITextBorderStyleRoundedRect;
    searchTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    searchTextField.delegate = self;
    searchTextField.textColor = [UIColor redColor];
    searchTextField.font = [UIFont systemFontOfSize:kOneFontSize];
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
//    searchTextField.text=@"分析仪";
    [searchV addSubview:searchTextField];
    
    UIButton *searchBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBUtton setFrame:CGRectMake(kScreenWidth-60*2, 2, 50, 26)];
    [searchBUtton setTitle:@"搜文章" forState:UIControlStateNormal];
    searchBUtton.layer.masksToBounds = YES;
    searchBUtton.layer.cornerRadius = 10;
    searchBUtton.titleLabel.font =[UIFont systemFontOfSize:kTwoFontSize];
    searchBUtton.backgroundColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
    [searchBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBUtton addTarget:self action:@selector(searchMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBUtton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBUtton2 setFrame:CGRectMake(kScreenWidth-60, 2, 50, 26)];
    [searchBUtton2 setTitle:@"搜产品" forState:UIControlStateNormal];
    searchBUtton2.layer.masksToBounds = YES;
    searchBUtton2.layer.cornerRadius = 10;
    searchBUtton2.titleLabel.font =[UIFont systemFontOfSize:kTwoFontSize];
    searchBUtton2.backgroundColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
    [searchBUtton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBUtton2 addTarget:self action:@selector(searchProductMethod) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lable1=[[UILabel alloc] initWithFrame:CGRectMake(10, 42, 80, 20)];
    lable1.text=@"标签集：";
    lable1.font=[UIFont boldSystemFontOfSize:15.0f];
    lable1.textColor=[UIColor redColor];
    [searchV addSubview:searchBUtton];
    [searchV addSubview:searchBUtton2];
    [searchV addSubview:lable1];
    
    touView  = [[UIView alloc]initWithFrame:CGRectMake(0, 70+70, kScreenWidth, 1)];
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 70+70, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.tableHeaderView = touView;
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableV];
    _requestSubLebel = NO;
    
    [self requestTopSubLebel];
}

#pragma mark - 网络
#pragma mark -- 请求搜索标签
- (void)requestTopSubLebel
{
    _requestSubLebel = YES;
    [self requestWithUrl:kSearchLableUrl Params:nil];
}

#pragma mark -- 搜索文章
- (void)searchMethod
{
    // 搜索
    [searchTextField resignFirstResponder];
    if (searchTextField.text.length==0) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入查询关键字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertV show];
    }else{
//        NSDictionary *paramDic = @{@"labelid":@"1",@"label":searchTextField.text,@"querytype":@"0"};
//        [self requestWithUrl:kSearchUrl Params:paramDic];
        SearchArticleTableViewController *saTv=[[SearchArticleTableViewController alloc] init];
        saTv.searchStr=searchTextField.text;
        saTv.querytypeStr=@"0";
        [self.navigationController pushViewController:saTv animated:YES];
    }
}
#pragma mark -- 搜索产品
- (void)searchProductMethod
{
    // 搜索
    [searchTextField resignFirstResponder];
    if (searchTextField.text.length==0) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入查询关键字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertV show];
    }else{
//        NSDictionary *paramDic = @{@"currentPage":@"1",@"keyword":searchTextField.text,@"pageSize":@"20"};
//        [self requestWithUrl:kSearchProductUrl Params:paramDic];
        SearchProductListTableViewController *spTv=[[SearchProductListTableViewController alloc] init];
        spTv.searchStr=searchTextField.text;
        [self.navigationController pushViewController:spTv animated:YES];
    }
}

#pragma mark --网络请求
- (void)requestWithUrl:(NSString *)url Params:(NSDictionary *)dict
{
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
    [AFNetworkTool postJSONWithUrl:url parameters:dict success:^(id responseObject)
     {
         [self.view removeLoadingVIewInView:self.view andTarget:self];
         if (_requestSubLebel)
         {
             // 搜索标签
             _requestSubLebel = NO;
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             if ([[dict objectForKey:@"respCode"] integerValue] == 1000)
             {
                 _moNiDataArray = [[dict objectForKey:@"data"] objectForKey:@"labelList"];
                 [self createSubLables];
                 [_tableV reloadData];
             }
         }
         else
         {
             // 搜索结果
             NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             if ([[dic objectForKey:@"respCode"] intValue] == 1000)
             {
                 _searchDataArray = [[dic objectForKey:@"data"] objectForKey:@"resultList"];
                 [_tableV reloadData];
                 _tableV.tableHeaderView = nil;
             }
             else
             {
                 [self.view addAlertViewWithMessage:[dic objectForKey:@"remark"] andTarget:self];
             }

         }
     } fail:^{
         [self.view removeLoadingVIewInView:self.view andTarget:self];
         if (_requestSubLebel)
         {
             _requestSubLebel = NO;
         }
         else
         {
             [self.view addAlertViewWithMessage:@"搜索失败" andTarget:self];
         }
    }];
}


- (void)createSubLables
{
    NSInteger jugeWidth = 10;
    NSInteger hang = 0;
    for (int i = 0; i < _moNiDataArray.count; i ++)
    {
        NSDictionary *dic = [_moNiDataArray objectAtIndex:i];
        NSInteger currentWidth = [self heightFromText:[dic objectForKey:@"label"]];
        if (jugeWidth+currentWidth > kScreenWidth-10)
        {
            jugeWidth = 10;
            hang ++;
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[dic objectForKey:@"label"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:128/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(jugeWidth, 5+kTouViewHeight*hang, currentWidth, kTouViewHeight-10)];
        btn.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = (kTouViewHeight-10)/2;
        btn.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
        btn.tag = kMarkButtonTag + i;
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [touView addSubview:btn];
        jugeWidth += currentWidth+20;
    }
    _markHeaderHeight = kTouViewHeight*(hang+1);
    touView.frame = CGRectMake(0, 70, kScreenWidth, _markHeaderHeight);
}


#pragma mark - 列表 delegate
#pragma mark -- 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchDataArray.count;
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
    if (_addReadCounts && indexPath.row == _markCellIndex)
    {
        cell.LookCountLable.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"seenum"] integerValue]+1];
    }
    return cell;
}

#pragma mark -- 去掉多余的线
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark -- 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark -- 选中cell 进入详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _markCellIndex = indexPath.row;
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
    _addReadCounts = YES;
    [_tableV reloadData];
}

#pragma mark - 标签点击事件
- (void)buttonClicked:(UIButton *)btn
{
//    searchTextField.text = [[_moNiDataArray objectAtIndex:btn.tag - kMarkButtonTag] objectForKey:@"label"];
    SearchArticleTableViewController *saTv=[[SearchArticleTableViewController alloc] init];
    saTv.searchStr=[[_moNiDataArray objectAtIndex:btn.tag - kMarkButtonTag] objectForKey:@"label"];
    saTv.querytypeStr=@"1";
    [self.navigationController pushViewController:saTv animated:YES];
}

#pragma mark - 计算宽度
- (NSInteger)heightFromText:(NSString *)text
{
     CGRect rect = [text boundingRectWithSize:CGSizeMake(9999, 20)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kOneFontSize]} context:nil];
    NSInteger width = rect.size.width+10;
    return width;
}


#pragma mark - 返回上一页
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchTextField resignFirstResponder];
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
