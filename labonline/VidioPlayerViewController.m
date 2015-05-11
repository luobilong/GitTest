//
//  VidioPlayerViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "VidioPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VidioView.h"
/*
     此界面已修改 还未合在一起
 */
@interface VidioPlayerViewController ()
{
    //里面带有一个视频播放器,(封装了视频播放器界面的视图控制器),系统内部基于AVPlayer 封装了一个带界面的播放器->MPMoviePlayerController
    AVPlayer *_player;
    MPMoviePlayerViewController *_playerController;
    VidioView *_vidioView;
    UISlider *_progressSlider;//用于显示和调整视频播放的进度
}

@end

@implementation VidioPlayerViewController
#define kVidioLayerHeight 300
#define kToolViewHeight 40
#define kPlayButtonTag 1122
#define kQuanPingButtonWidth 60

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self playerPlayVidioWithPath:self.vidioPath];
    
}

#pragma mark - 根据路径播放视频
- (void)playerPlayVidioWithPath:(NSString *)path
{
    if (path.length == 0)
    {
//        NSLog(@"没有视频资源");
        return;
    }
    NSURL *vidioUrl;
    if ([path hasPrefix:@"http://"]||[path hasPrefix:@"https://"])
    {
        // 远程地址
        vidioUrl = [NSURL URLWithString:path];
    }
    else
    {
        // 本地路径
        vidioUrl = [NSURL fileURLWithPath:path];
    }
    if (_playerController == nil)
    {
        _playerController = [[MPMoviePlayerViewController alloc]initWithContentURL:vidioUrl];
        _playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentViewController:_playerController animated:YES completion:^{
            
        }];
    }
    [_playerController.moviePlayer play];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
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
    [self backToLastPage];
}

#pragma mark - 自定义控件播放器
- (void)createCustomLayerPlayer
{
    _vidioView = [[VidioView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kVidioLayerHeight)];
    [self.view addSubview:_vidioView];
    
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 70+kVidioLayerHeight-kToolViewHeight, kScreenWidth, kToolViewHeight)];
    toolView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self.view addSubview:toolView];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setTitle:@"play" forState:UIControlStateNormal];
    [playBtn setFrame:CGRectMake(10,5,kToolViewHeight-10,kToolViewHeight-10)];
    playBtn.tag = kPlayButtonTag;
    playBtn.layer.masksToBounds = YES;
    playBtn.layer.cornerRadius = playBtn.frame.size.height/2;
    playBtn.layer.borderColor = [UIColor greenColor].CGColor;
    playBtn.layer.borderWidth = 1;
    playBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    playBtn.selected = NO;
    [playBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:playBtn];
    
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(kToolViewHeight+10,(kToolViewHeight-20)/2,kScreenWidth-kToolViewHeight-kQuanPingButtonWidth,20)];
    //设置最大最小值
    _progressSlider.minimumValue = 0.0;
    _progressSlider.maximumValue = 1.0;
    [_progressSlider addTarget:self action:@selector(progressSliderValue:) forControlEvents:UIControlEventValueChanged];
    [toolView addSubview:_progressSlider];
    
    // 开始播放
    [self playVideo:playBtn];
}

//滑动滑块，对应的方法
- (void)progressSliderValue:(UISlider *)sl{
    if (_player) {
        //获取滑块对应的进度
        float value = sl.value;
        //通过_player获取到视频总时长
        CMTime total = _player.currentItem.duration;
        if (CMTimeGetSeconds(total)==0.0) {
//            NSLog(@"无法获取资源信息");
            return;
        }
        //让player跳转到指定的播放进度
        //CMTimeMultiplyByFloat64 得到视频播放的CMTime结构体
        [_player seekToTime:CMTimeMultiplyByFloat64(total, value)];
    }
}

//播放视频
- (void)playVideo:(UIButton *)playButton
{
    if (playButton.selected == NO)
    {
        // 播放
        playButton.selected = YES;
        [playButton setTitle:@"pase" forState:UIControlStateNormal];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
        [self avplayerPlayVidioWithPath:path];
    }
    else
    {
        // 暂停
        playButton.selected = NO;
        if (_player)
        {
            [_player pause];
        }
        [playButton setTitle:@"play" forState:UIControlStateNormal];
    }
}

//暂停视频
- (void)pauseVideo
{
    if (_player) {
        [_player pause];
    }
}

// 自定义播放层播放
- (void)avplayerPlayVidioWithPath:(NSString *)path
{
    if (_player)
    {
        [_player play];
        return;
    }
    if (path.length == 0) {
//        NSLog(@"没有找到视频路径!");
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    //AVAsset 视频资源的集合类，能够收集视频资源的信息(视频的类型、总时长等),还能对视频进行预加载处理
    AVAsset *aset = [AVAsset assetWithURL:url];
    //aset对象，通过此方法，根据tracks关键字来收集视频资源的信息,操作为异步的
    [aset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        //获取到视频预加载的状态
        AVKeyValueStatus status = [aset statusOfValueForKey:@"tracks" error:nil];
        //视频预加载完毕，收集信息成功
        if (status == AVKeyValueStatusLoaded) {
            //创建视频对应的Item，将视频信息，通过asset对象传给Item
            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:aset];
            _player = [[AVPlayer alloc] initWithPlayerItem:item];
            [_vidioView setVideoViewWithPlayer:_player];
            [_player play];
            //保持弱引用
            __weak AVPlayer *weakPlayer = _player;
            __weak UISlider *weakSlider = _progressSlider;
            [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0,1.0) queue:dispatch_get_global_queue(0, 0) usingBlock:^(CMTime time) {
                //获取到当前的播放时间结构体CMTime
                CMTime current = weakPlayer.currentItem.currentTime;
                //获取总时间
                CMTime total = weakPlayer.currentItem.duration;
                //计算播放进度,需要把视频对应的时间结构体CMTime转化成秒数
                float progress =  CMTimeGetSeconds(current)/CMTimeGetSeconds(total);
                //回到主线程，刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progress>=0.0&&progress<=1.0) {
                        weakSlider.value = progress;
                    }
                });
            }];
        }
    }];
}

#pragma mark - 返回上一页
- (void)backToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
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
