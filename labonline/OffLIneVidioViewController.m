//
//  OffLIneVidioViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "OffLIneVidioViewController.h"
#import "OffLineVidioCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Category.h"
//#import <AVFoundation/AVFoundation.h>

@interface OffLIneVidioViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_vidioTableView;
    MPMoviePlayerViewController *_playerController;
    NSMutableArray *_downloadArray;
}
@end

@implementation OffLIneVidioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"离线视频";
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
    
    _downloadArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"VidioList"]];
    
    _vidioTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, kScreenHeight-80) style:UITableViewStylePlain];
    _vidioTableView.delegate = self;
    _vidioTableView.dataSource = self;
    _vidioTableView.showsVerticalScrollIndicator = NO;
    _vidioTableView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    _vidioTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_vidioTableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _downloadArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cell";
    OffLineVidioCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OffLineVidioCell" owner:self options:0] lastObject];
        cell.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        cell.target = self;
        cell.action = @selector(playVidioButtonCallBack:);
    }
    NSDictionary *dic = [_downloadArray objectAtIndex:indexPath.row];
    cell.vidioImgView.image = [UIImage imageWithData:[dic objectForKey:@"image"]];
    cell.titleLable.text = [dic objectForKey:@"title"];
    cell.authorLable.text = [dic objectForKey:@"type"];
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteLocalVidio:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

#pragma mark - 删除本地视频
- (void)deleteLocalVidio:(UIButton *)btn
{
    // 删除本地文件
    NSDictionary *dict = [_downloadArray objectAtIndex:btn.tag];
    // 此处由于模拟器路径存在变化 所以自己拼接字符串 在手机上测试后 再决定用哪个路径
    // 存储的路径
//    NSString *filePath = [dict objectForKey:@"VidioPath"];
    // 合成的路径
    NSString *path = [NSString stringWithFormat:@"%@/Documents/MyOff-lineVidio/%@",NSHomeDirectory(),[dict objectForKey:@"VidioName"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
    // 更改沙河存储数据
    [_downloadArray removeObjectAtIndex:btn.tag];
    [[NSUserDefaults standardUserDefaults] setObject:_downloadArray forKey:@"VidioList"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    [self.view addAlertViewWithMessage:@"视频删除成功" andTarget:self];
}

#pragma mark - 警告框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_vidioTableView reloadData];
}

#pragma mark - 播放视频
- (void)playVidioButtonCallBack:(OffLineVidioCell *)offLineCell
{
    // 播放离线视频
    NSDictionary *dict = [_downloadArray objectAtIndex:offLineCell.index];
    
    // 此处由于模拟器路径存在变化 所以自己拼接字符串 在手机上测试后 再决定用哪个路径
//    NSString *path = [NSString stringWithFormat:@"%@/Documents/MyOff-lineVidio/%@",NSHomeDirectory(),[dict objectForKey:@"VidioName"]];
//    [self playerPlayVidioWithPath:path];
    
    [self playerPlayVidioWithPath:[dict objectForKey:@"VidioPath"]];
}


#pragma mark - 根据路径播放视频
- (void)playerPlayVidioWithPath:(NSString *)path
{
    if (path.length == 0)
    {
//        NSLog(@"没有视频资源");
        return;
    }
    BOOL exit;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&exit])
    {
        NSURL *vidioUrl = [NSURL fileURLWithPath:path];
        
        if (_playerController == nil)
        {
            _playerController = [[MPMoviePlayerViewController alloc]initWithContentURL:vidioUrl];
            _playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
            
        }
        [self presentMoviePlayerViewControllerAnimated:_playerController];
        [_playerController.moviePlayer play]; //MPMoviePlayerPlaybackDidFinishNotification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
    else
    {
//        NSLog(@"文件不存在");
    }
}

#pragma mark- 播放结束
- (void)playFinished
{
    // 播放完毕
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    // 停止播放 并销毁
    if (_playerController)
    {
        [_playerController.moviePlayer stop];
        _playerController = nil;
    }
}

- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
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
