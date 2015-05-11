//
//  MyMagazineViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MyMagazineViewController.h"
//#import "WangQiCell.h"
#import "MyCollectionCell.h"
#import "JiShuZhuanLanDetailViewController.h"
#import "UIView+Category.h"

@interface MyMagazineViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_myMagazineTableV;
    NSMutableArray *_pdfArray;
    NSInteger _deletePdfIndex;
    BOOL _deleting;
}
@end

@implementation MyMagazineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的文章";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 35, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"返回角.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToPrePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self makeUpArray];
    _myMagazineTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, kScreenHeight-80) style:UITableViewStylePlain];
    _myMagazineTableV.delegate = self;
    _myMagazineTableV.dataSource = self;
    _myMagazineTableV.showsVerticalScrollIndicator = NO;
    _myMagazineTableV.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _myMagazineTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myMagazineTableV];
    
}

#pragma mark - 构成PDF数组
- (void)makeUpArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"PDFArray"])
    {
        _pdfArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PDFArray"]];
    }
}

#pragma mark - 返回上一页
- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pdfArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"MyCollectionCell";
    MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCollectionCell" owner:self options:0] lastObject];
        cell.target = self;
        cell.action = @selector(deleteMyPDF:);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cellIndex = indexPath.row;
    cell.infoDict = [_pdfArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark --点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 阅读
    NSDictionary *dic =[ _pdfArray objectAtIndex:indexPath.row];
    JiShuZhuanLanDetailViewController *detailVC = [[JiShuZhuanLanDetailViewController alloc]init];
    detailVC.articalDic = dic;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)deleteMyPDF:(MyCollectionCell *)cell
{
    _deletePdfIndex = cell.cellIndex;
    _deleting = YES;
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"警告" message:@"确定要删除这篇文章么？" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (_deleting)
        {
            _deleting = NO;
            NSString *pdfPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/LocalFile"];
            NSString *fileName = [[[[_pdfArray objectAtIndex:_deletePdfIndex] objectForKey:@"urlpdf"] componentsSeparatedByString:@"/"] lastObject];
            NSError *error;
            BOOL deleteSuccesee = [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",pdfPath,fileName] error:&error];
            if (deleteSuccesee)
            {
                // 删除
                [_pdfArray removeObjectAtIndex:_deletePdfIndex];
                [[NSUserDefaults standardUserDefaults] setObject:_pdfArray forKey:@"PDFArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [_myMagazineTableV reloadData];
//                [self.view addAlertViewWithMessage:@"删除文件成功" andTarget:self];
            }
            else
            {
//                NSLog(@"删除失败");
//                NSLog(@"%@",error);
//                [self.view addAlertViewWithMessage:@"删除文件失败" andTarget:self];
            }
        }
    }
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
