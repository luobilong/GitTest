//
//  LeftViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_titleCateArray;
    UITableView *_cateTableView;
    UIView *_headLogedView;// 头视图
    UIView *_logedV;
    UIView *_notLogedV;
    BOOL _logined;// 判断是否登录
}
@end

@implementation LeftViewController
#define kLeftWidth 240
#define kHeadViewHeight 160
#define kImageHeight 80
#define kCircleHeight 90
#define kNameLableTag 1234
#define kImageTag 1235

#define kLoginButtonWidth 80
#define kLoginButtonHeight 30
#define kLoginButtonTag 8888

#define kCellHeight 40
#define kSettingButtonHeight 25


#pragma mark - 登陆后的头视图
- (void)createLoginHeadView
{
    _logedV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kLeftWidth, kHeadViewHeight)];
    // 头像
    UIImageView *headImgV = [[UIImageView alloc]initWithFrame:CGRectMake((kLeftWidth-kCircleHeight)/2, 30, kCircleHeight, kCircleHeight)];
    headImgV.backgroundColor = [UIColor clearColor];
    headImgV.layer.masksToBounds = YES;
    headImgV.layer.cornerRadius = kCircleHeight/2;
    headImgV.layer.borderWidth = 3;
    headImgV.layer.borderColor = [UIColor colorWithRed:162/255.0 green:203/255.0 blue:205/255.0 alpha:1].CGColor;
    [_logedV addSubview:headImgV];
    
    UIButton *userImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userImageButton setFrame:CGRectMake((kLeftWidth-kImageHeight)/2, 30+(kCircleHeight-kImageHeight)/2, kImageHeight, kImageHeight)];
    [userImageButton setBackgroundImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
    userImageButton.layer.masksToBounds = YES;
    userImageButton.layer.cornerRadius = kImageHeight/2;
    userImageButton.tag = kImageTag;
    [_logedV addSubview:userImageButton];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 35+kCircleHeight, kLeftWidth-20, 30)];
    nameLab.tag = kNameLableTag;
    nameLab.text = @"用户昵称";
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:15];
    [_logedV addSubview:nameLab];
}

#pragma mark - 未登陆时的头视图
- (void)createNotLoginView
{
    _notLogedV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kLeftWidth, kHeadViewHeight)];
    
    NSArray *buttonTitltArr = @[@"登陆",@"注册"];
    for (int i = 0; i < buttonTitltArr.count; i ++)
    {
        NSInteger y = (kHeadViewHeight-kLoginButtonHeight)/2;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake((kLeftWidth-kLoginButtonWidth*2)/2+i*kLoginButtonWidth, y>40?kHeadViewHeight-40-kLoginButtonHeight:y, kLoginButtonWidth, kLoginButtonHeight)];
        [button setTitle:[buttonTitltArr objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor colorWithRed:100/255.0 green:160/255.0 blue:170/255.0 alpha:1].CGColor;
        button.layer.borderWidth = 1;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = kLoginButtonTag +i;
        [button addTarget:self action:@selector(logButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(clickedDown:) forControlEvents:UIControlEventTouchDown];
        [_notLogedV addSubview:button];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景图
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imgV.image = [UIImage imageNamed:@"左侧列.png"];
    imgV.userInteractionEnabled = YES;
    [self.view addSubview:imgV];
    [self createLoginHeadView];
    [self createNotLoginView];
    
    NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
    if ([userDe objectForKey:@"userName"])
    {
        _logined = YES;
        UILabel *nameLab = (UILabel *)[self.view viewWithTag:kNameLableTag];
        nameLab.text = [userDe objectForKey:@"nickname"];
        if (![userDe objectForKey:@"nickname"])
        {
            nameLab.text = [userDe objectForKey:@"username"];
        }
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:kImageTag];
        if ([userDe objectForKey:@"icon"]&&[[userDe objectForKey:@"icon"] hasPrefix:@"http"])
        {
            NSData *imageDa = [NSData dataWithContentsOfURL:[NSURL URLWithString:[userDe objectForKey:@"icon"]]];
            [btn setBackgroundImage:[UIImage imageWithData:imageDa]  forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        _logined = NO;
    }
    
    _titleCateArray = [[NSMutableArray alloc]initWithObjects:@"首页",@"杂志",@"e检通产品",@"技术专栏",@"用户中心", nil];
    // 列表视图：从-5开始 UI设计需要
    _cateTableView = [[UITableView alloc]initWithFrame:CGRectMake(-5, 10, kLeftWidth-10, kScreenHeight-100) style:UITableViewStylePlain];
    _cateTableView.delegate = self;
    _cateTableView.dataSource = self;
    _cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cateTableView.backgroundColor = [UIColor clearColor];
    if (_logined)
    {
        // 登陆
        _cateTableView.tableHeaderView = _logedV;
    }
    else
    {
        //未登录
        _cateTableView.tableHeaderView = _notLogedV;
    }
    [imgV addSubview:_cateTableView];
    
    
    // 设置按钮
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(20, kScreenHeight-80, kSettingButtonHeight, kSettingButtonHeight)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"设置按钮.png"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(setButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(25+kSettingButtonHeight, kScreenHeight-80, 60, kSettingButtonHeight)];
    lable.text = @"设置";
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:kOneFontSize];
    lable.userInteractionEnabled = YES;
    [self.view addSubview:lable];
    // 设置标签添加手势 ---进入设置界面
    UITapGestureRecognizer *tapSettingLable = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setButtonClicked)];
    [lable addGestureRecognizer:tapSettingLable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 模拟数据 假设已经登陆
    NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
    if ([userDe objectForKey:@"userName"])
    {
        _logined = YES;
        // 登陆
        _cateTableView.tableHeaderView = _logedV;
        UILabel *nameLab = (UILabel *)[self.view viewWithTag:kNameLableTag];
        if ([userDe objectForKey:@"nickname"])
        {
            nameLab.text = [userDe objectForKey:@"nickname"];
        }
        else
        {
           nameLab.text = [userDe objectForKey:@"userName"];
        }
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:kImageTag];
        if ([userDe objectForKey:@"icon"]&&[[userDe objectForKey:@"icon"] hasPrefix:@"http"])
        {
            NSData *imageDa = [NSData dataWithContentsOfURL:[NSURL URLWithString:[userDe objectForKey:@"icon"]]];
            [btn setBackgroundImage:[UIImage imageWithData:imageDa]  forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"头像.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        _logined = NO;
        //未登录
        _cateTableView.tableHeaderView = _notLogedV;
    }
    [_cateTableView reloadData];
}

#pragma mark -- 登录注册按钮按下时调用该方法
- (void)clickedDown:(UIButton *)btn
{
    btn.backgroundColor = [UIColor colorWithRed:148/255.0 green:191/255.0 blue:196/255.0 alpha:0.7];
}

#pragma mark - 登陆注册
- (void)logButtonClicked:(UIButton *)button
{
    button.backgroundColor = [UIColor clearColor];
    switch (button.tag)
    {
        case kLoginButtonTag:
            // 登陆
            [self.delegate pushViewControllerWithIndex:LogIn];
            break;
        case kLoginButtonTag+1:
            // 注册
            [self.delegate pushViewControllerWithIndex:Register];
            break;
 
        default:
            break;
    }
}

#pragma mark - 设置
- (void)setButtonClicked
{
    [self.delegate pushViewControllerWithIndex:SettingCenter];
}

#pragma mark - 列表视图  UITableViewDelegate
/*
  利用分区实现cell之间的间距
 */
#pragma mark --分区section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 根据用户是否登陆 来判断是否显示用户中心
    return _logined?_titleCateArray.count:_titleCateArray.count-1;
}

#pragma mark --row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark -- 利用尾视图实现间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
#pragma mark - 尾部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kLeftWidth, 10)];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}

#pragma mark -- 绘制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdendifer = @"CateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifer];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifer];
        cell.backgroundColor = [UIColor clearColor];
    }
    // 设置cell圆角和边框
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    cell.layer.borderColor = [UIColor colorWithRed:120/255.0 green:170/255.0 blue:179/255.0 alpha:1].CGColor;
    cell.layer.borderWidth = 1;
    // 右侧箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 选中后背景色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:148/255.0 green:191/255.0 blue:196/255.0 alpha:0.7];
    // 赋值
    cell.textLabel.text = [_titleCateArray objectAtIndex:indexPath.section];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    return cell;
}
#pragma mark -- cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark -- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate pushViewControllerWithIndex:indexPath.section];
}

#pragma mark - didReceiveMemoryWarning
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
