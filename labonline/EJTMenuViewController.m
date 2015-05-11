//
//  EJTMenuViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/28.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EJTMenuViewController.h"
#import "EJTListViewController.h"
#import "MenuButton.h"
#import "MenuCell.h"


@interface EJTMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *leftArray;
    NSArray *rightArray;
    UITableView *leftTab;
    UITableView *rightTab;
    
    NSInteger _secMenu;
    NSInteger _thirdMenu;
    
    BOOL _first;
}
@end

#define kOneBtnTag 10
#define kTwoBtnTag 11
#define kLeftTabTag 12
#define kRightTabTag 13
#define kFirstCellTag 555
#define kSecondCellTag 888

@implementation EJTMenuViewController

- (void)setFirstMenu:(NSInteger)firstMenu
{
    _firstMenu = firstMenu;
    _secMenu = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _first = YES;
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"MENUARRAY"];
//    NSLog(@"here :%@",array);
    leftArray = [[array objectAtIndex:_firstMenu] objectForKey:@"submenus"];
    rightArray = [[leftArray objectAtIndex:_secMenu] objectForKey:@"submenus"];
    self.title = [[[array objectAtIndex:_firstMenu] objectForKey:@"info"] objectForKey:@"classifyname"];
    
//    MenuButton *oneBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
//    [oneBtn setFrame:CGRectMake(0, 0, kScreenWidth/2, 30)];
//    [oneBtn setTitle:[[[leftArray objectAtIndex:0] objectForKey:@"info"] objectForKey:@"classifyname"] forState:UIControlStateNormal];
//    [oneBtn addTarget:self action:@selector(oneMenu:) forControlEvents:UIControlEventTouchUpInside];
//    oneBtn.backgroundColor = [UIColor whiteColor];
//    oneBtn.tag = kOneBtnTag;
//    [self.view addSubview:oneBtn];
//    
//    MenuButton *secBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
//    [secBtn setFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 30)];
//    [secBtn setTitle:[[rightArray objectAtIndex:0] objectForKey:@"classifyname"] forState:UIControlStateNormal];
//    [secBtn addTarget:self action:@selector(secBtn:) forControlEvents:UIControlEventTouchUpInside];
//    secBtn.tag = kTwoBtnTag;
//    [self.view addSubview:secBtn];
    
    leftTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, kScreenHeight-64) style:UITableViewStylePlain];
    leftTab.delegate = self;
    leftTab.dataSource = self;
    leftTab.tag = kLeftTabTag;
    leftTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTab.layer.masksToBounds = YES;
    leftTab.layer.cornerRadius = 2;
//    leftTab.layer.borderWidth = 1;
//    leftTab.layer.borderColor = [UIColor colorWithWhite:230/255.0 alpha:1].CGColor;
    [self.view addSubview:leftTab];
//    [self changeTableViewFrameWithTag:kLeftTabTag andCount:leftArray.count];
    
    rightTab = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, kScreenHeight-64) style:UITableViewStylePlain];
    rightTab.delegate = self;
    rightTab.dataSource = self;
    rightTab.tag = kRightTabTag;
    rightTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    rightTab.layer.masksToBounds = YES;
    rightTab.layer.cornerRadius = 2;
//    rightTab.layer.borderWidth = 1;
//    rightTab.layer.borderColor = [UIColor colorWithWhite:244/255.0 alpha:1].CGColor;
    [self.view addSubview:rightTab];
//    [self changeTableViewFrameWithTag:kRightTabTag andCount:rightArray.count];
    
    leftTab.hidden = NO;
    rightTab.hidden = NO;
    leftTab.backgroundColor = [UIColor clearColor];
    rightTab.backgroundColor = [UIColor clearColor];
    
}

- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)oneMenu:(MenuButton *)btn
{
//    NSLog(@"oneMenu");
    [self changeButtonSelectedWithButtonTag:btn.tag];
    if (btn.selected)
    {
        [self changeTableViewFrameWithTag:kLeftTabTag andCount:leftArray.count];
        leftTab.hidden = NO;
        [leftTab reloadData];
    }
    else
    {
        leftTab.hidden = YES;
        rightTab.hidden = YES;
    }
    
}


- (void)secBtn:(MenuButton *)btn
{
    [self changeButtonSelectedWithButtonTag:btn.tag];
    if (btn.selected)
    {
        rightArray = [[leftArray objectAtIndex:_secMenu] objectForKey:@"submenus"];
        [self changeTableViewFrameWithTag:kRightTabTag andCount:rightArray.count];
        rightTab.hidden = NO;
        [rightTab reloadData];
    }
    else
    {
        rightTab.hidden = YES;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kLeftTabTag)
    {
        // left
        return leftArray.count;
    }
    else if (tableView.tag == kRightTabTag)
    {
        return rightArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:0] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.target = self;
    if (tableView.tag == kLeftTabTag)
    {
        // left
//        NSLog(@"%@",[leftArray objectAtIndex:indexPath.row] );
        cell.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
        cell.titleLabel.text = [[[leftArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyname"];
        cell.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
        cell.action = @selector(firstMenu:);
        cell.tag = indexPath.row + kFirstCellTag;
        if (_first)
        {
            if (indexPath.row == 0)
            {
                [cell btnClicked:cell.backBtn];
            }
        }
    }
    else if (tableView.tag == kRightTabTag)
    {
        cell.titleLabel.textColor = [UIColor colorWithWhite:128/255.0 alpha:1];
        cell.titleLabel.text = [[rightArray objectAtIndex:indexPath.row] objectForKey:@"classifyname"];
        cell.titleLabel.font = [UIFont systemFontOfSize:kTwoFontSize];
        cell.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
        cell.action = @selector(secondMenu:);
        cell.tag = indexPath.row + kSecondCellTag;
        if (indexPath.row == 0)
        {
            cell.titleLabel.textColor = [UIColor redColor];
        }
    }
    
    return cell;
}

- (void)firstMenu:(MenuCell *)cell
{
    [self changeSelectedCell:cell andBaseTag:kFirstCellTag andSumCounts:leftArray.count];
    _secMenu = cell.tag-kFirstCellTag;//indexPath.row;
    rightArray = [[leftArray objectAtIndex:_secMenu] objectForKey:@"submenus"];
    [rightTab reloadData];
}

- (void)secondMenu:(MenuCell *)cell
{
    [self changeSelectedCell:cell andBaseTag:kSecondCellTag andSumCounts:rightArray.count];
    _thirdMenu = cell.tag-kSecondCellTag;
    NSString *classifyid = [[rightArray objectAtIndex:_thirdMenu] objectForKey:@"classifyid"];
//    NSLog(@"%@",classifyid);
    EJTListViewController *eJTListVC = [[EJTListViewController alloc]init];
    eJTListVC.firstMenu = _firstMenu;
    eJTListVC.seconMenu = _secMenu;
    eJTListVC.thirdMenu = _thirdMenu;
    eJTListVC.classifyid = classifyid;
    [self.navigationController pushViewController:eJTListVC animated:YES];

}

- (void)changeSelectedCell:(MenuCell *)cell andBaseTag:(NSInteger)tag andSumCounts:(NSInteger)counts
{
    for (int i = 0;i < counts;i ++)
    {
        MenuCell *newCell = (MenuCell *)[self.view viewWithTag:i+tag];
        if (cell.tag == newCell.tag)
        {
            if (tag == kSecondCellTag)
            {
                newCell.titleLabel.textColor = [UIColor redColor];
            }
            else
            {
                newCell.selectedLable.hidden = NO;
            }
            newCell.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
        }
        else
        {
            newCell.selectedLable.hidden = YES;
            newCell.titleLabel.textColor = [UIColor colorWithWhite:128/255.0 alpha:1];
            if (tag == kFirstCellTag)
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

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kLeftTabTag)
    {
        _secMenu = indexPath.row;
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:kOneBtnTag];
        [btn setTitle:[[[leftArray objectAtIndex:indexPath.row] objectForKey:@"info"] objectForKey:@"classifyname"] forState:UIControlStateNormal];
        
        rightArray = [[leftArray objectAtIndex:indexPath.row] objectForKey:@"submenus"];
        [self changeTableViewFrameWithTag:kRightTabTag andCount:rightArray.count];
        rightTab.hidden = NO;
        [rightTab reloadData];
    }
    else
    {
        // 跳到下一界面
        UIButton *btn = (UIButton *)[self.view viewWithTag:kTwoBtnTag];
        [btn setTitle:[[rightArray objectAtIndex:indexPath.row] objectForKey:@"classifyname"] forState:UIControlStateNormal];
//        [self changeButtonSelectedWithButtonTag:kTwoBtnTag];
        _thirdMenu = indexPath.row;
        NSString *classifyid = [[rightArray objectAtIndex:indexPath.row] objectForKey:@"classifyid"];
        NSLog(@"%@",classifyid);
        EJTListViewController *eJTListVC = [[EJTListViewController alloc]init];
        eJTListVC.firstMenu = _firstMenu;
        eJTListVC.seconMenu = _secMenu;
        eJTListVC.thirdMenu = _thirdMenu;
        eJTListVC.classifyid = classifyid;
        [self.navigationController pushViewController:eJTListVC animated:YES];
    }
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 改变按钮选中状态
- (void)changeButtonSelectedWithButtonTag:(NSInteger)tag
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
    if (btn.selected)
    {
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        btn.selected = YES;
        [btn setBackgroundColor:[UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1]];
    }
}

- (void)changeTableViewFrameWithTag:(NSInteger)tag andCount:(NSInteger)counts
{
    UITableView *tabV = (UITableView *)[self.view viewWithTag:tag];
    CGRect rect = tabV.frame;
    if (counts*40<kScreenHeight-94)
    {
        rect.size.height = counts*40;
    }
    else
    {
        rect.size.height = kScreenHeight-94;
    }
    tabV.frame = rect;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    leftTab.hidden = YES;
    rightTab.hidden = YES;
    UIButton *btn = (UIButton *)[self.view viewWithTag:kOneBtnTag];
    btn.selected = NO;
    [btn setBackgroundColor:[UIColor whiteColor]];
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:kTwoBtnTag];
    btn1.selected = NO;
    [btn1 setBackgroundColor:[UIColor whiteColor]];
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
