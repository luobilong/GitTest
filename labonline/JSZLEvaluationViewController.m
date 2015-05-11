//
//  JSZLEvaluationViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/27.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JSZLEvaluationViewController.h"
#import "JSZLEvaluationCell.h"
#import "SearchViewController.h"
#import "AFNetworkTool.h"
#import "UIView+Category.h"


@interface JSZLEvaluationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_evalueTableV;
    UIView *downV;//底部评价View
    NSArray *_listArray;// 模拟数据 为了计算cell高度
    BOOL sendFinished;
}
@end

@implementation JSZLEvaluationViewController
#define kDownViewHeight 40
#define kSendButtonWidth 60
#define kTextFieldTag 100
#define kCellHeight 70

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"技术专栏评价界面";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    _evalueTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-kDownViewHeight) style:UITableViewStylePlain];
    _evalueTableV.delegate = self;
    _evalueTableV.dataSource = self;
    [self.view addSubview:_evalueTableV];
    
    downV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-kDownViewHeight-64, kScreenWidth, kDownViewHeight)];
    downV.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:downV];
    // 文本框
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-kSendButtonWidth-30, kDownViewHeight-10)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.delegate = self;
    textField.tag = kTextFieldTag;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    [downV addSubview:textField];
    // 发送按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(kScreenWidth-kSendButtonWidth-10, 5, kSendButtonWidth, kDownViewHeight-10)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1] forState:UIControlStateNormal];
    sendButton.backgroundColor = [UIColor whiteColor];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 5;
    sendButton.layer.borderWidth = 1;
    sendButton.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [downV addSubview:sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self requestEvaluesList];
}

- (void)requestEvaluesList
{
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
    NSDictionary *dic = @{@"articleid":_articalId};
    [AFNetworkTool postJSONWithUrl:kEvalueationURLString parameters:dic success:^(id responseObject) {
        [self.view removeLoadingVIewInView:self.view andTarget:self];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        _listArray = [dict objectForKey:@"list"];
        [_evalueTableV reloadData];
        if (sendFinished)
        {
            if (_evalueTableV.contentSize.height>_evalueTableV.frame.size.height)
            {
                _evalueTableV.contentOffset = CGPointMake(0, _evalueTableV.contentSize.height-_evalueTableV.frame.size.height);
            }
        }
    } fail:^{
        [self.view removeLoadingVIewInView:self.view andTarget:self];
    }];
}

#pragma mark - 发送按钮点击事件
- (void)sendButtonClicked:(UIButton *)btn
{
    // 收键盘
    UITextField *textField = (UITextField *)[self.view viewWithTag:kTextFieldTag];
    [textField resignFirstResponder];
    /*
        提交评论 提交成功后重新网络请求 刷新数据（可以看到自己评论的）
        http://192.168.0.153:8181/labonline/hyController/insertPl.do
        参数 articleid userid text
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"id"]!=nil)
    {
        if ([textField.text length])
        {
            [self.view addLoadingViewInSuperView:self.view andTarget:self];
            NSDictionary *dic = @{@"articleid":_articalId,@"userid":[defaults objectForKey:@"id"],@"text":textField.text};
            [AFNetworkTool postJSONWithUrl:kCommitEvaluationUrl parameters:dic success:^(id responseObject)
            {
                [self.view removeLoadingVIewInView:self.view andTarget:self];
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                if ([[dictionary objectForKey:@"respCode"] integerValue] == 1000)
                {
                    // 成功
                    [self createAlertViewWithMessage:@"评论提交成功"];
                    // 重新请求数据
                    sendFinished = YES;
                    [self requestEvaluesList];
                }
                else
                {
                    [self createAlertViewWithMessage:[dictionary objectForKey:@"remark"]];
                }
                
            } fail:^{
                [self createAlertViewWithMessage:@"评论提交失败"];
            }];
        }
        else
        {
            [self createAlertViewWithMessage:@"评论不可为空"];
        }
    }
    else
    {
        [self createAlertViewWithMessage:@"亲，请先登录后在进行评论."];
    }
}

#pragma mark - Alert
- (void)createAlertViewWithMessage:(NSString *)str
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertV show];
}

- (void)removeLoadingView
{
    UIView *loadingV = [self.view viewWithTag:1234];
    [loadingV removeFromSuperview];
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - UITextFieldDelegate
#pragma mark --收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --空白收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:kTextFieldTag];
    [textField resignFirstResponder];
}

#pragma mark --notification handler
// 键盘升起时 downV 跟着升起
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
//    NSLog(@"UIKeyboardDidShowNotification");
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    CGRect rect = downV.frame;
    rect.origin.y += yOffset;
    [UIView animateWithDuration:duration animations:^{
        downV.frame = rect;
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"EvaluCell";
    JSZLEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JSZLEvaluationCell" owner:self options:0] lastObject];
    }
    cell.cellHeight = [self countCellHeightOfIndex:indexPath.row];
    cell.evaluDict = [_listArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self countCellHeightOfIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 根据文字计算高度
- (NSInteger)countCellHeightOfIndex:(NSInteger)index
{
    // 根据索引找到当前cell的数据str 暂时假数据
    NSString *cellString = [[_listArray objectAtIndex:index] objectForKey:@"text"];
    NSInteger textWidth = kScreenWidth-kCellHeight;
    CGRect rect = [cellString boundingRectWithSize:CGSizeMake(textWidth, 99999)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    NSInteger height = rect.size.height+35;
    if (height<=kCellHeight)
    {
        return kCellHeight;
    }
    else
    {
        return height;
    }
}

#pragma mark - 返回上一页
- (void)popToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
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
