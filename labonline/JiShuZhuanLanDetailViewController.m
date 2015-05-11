//
//  JiShuZhuanLanDetailViewController.m
//  labonline
//
//  Created by cocim01 on 15/3/27.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JiShuZhuanLanDetailViewController.h"
#import "JSZLEvaluationViewController.h"
#import "SearchViewController.h"
#import "NetManager.h"
#import "PathManager.h"
#import "UIView+Category.h"
#import <AVFoundation/AVFoundation.h>
#import <QuickLook/QuickLook.h>

#import "YRSideViewController.h"
#import "AppDelegate.h"
#import "PathManager.h"
#import "LoginView.h"

#import "RegisterViewController.h"

@interface JiShuZhuanLanDetailViewController ()<UIWebViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIWebView *_webView;
    BOOL _addReadCounts; // 是否在增加阅读数
    BOOL _isPDF; // 是否是PDF
    BOOL _haveVidio;// 是否有视频
    BOOL _downLoadVidio;// 是否在下载视频
    BOOL _collection; // 是否在网络请求--收藏
    NSString *_vidioUrl; // 视频网址
    NSString *_titleStr;// 文章名称
    NSString *_urlstring;// PDF or HTML网址
    NSString *_articalID;// 文章id
    
    BOOL _downloadPdf; // 正在下载PDF
    BOOL _login;// 判断是否登录
    BOOL _netRequesting;
    
    MFMailComposeViewController *mailComposer;
    
}
@end

@implementation JiShuZhuanLanDetailViewController

#define kLogViewTag  456
#define kToolBarHeight 60
#define kSubItemsTag 68

#pragma mark - 传递的数据
- (void)setArticalDic:(NSDictionary *)articalDic
{
    _articalDic = articalDic;
    _articalID = [_articalDic objectForKey:@"articleid"];
    // 图片轮播文章id字段为id 其他页面文章id字段为articleid 在此加以判断
    if ([_articalDic objectForKey:@"articleid"])
    {
        _articalID = [_articalDic objectForKey:@"articleid"];
    }
    else
    {
        _articalID = [_articalDic objectForKey:@"id"];
    }
    NSLog(@"~~~~~~%@",_articalDic);
    if ([[_articalDic objectForKey:@"urlpdf"] length]>5)
    {
        _isPDF = YES;
        _urlstring = [_articalDic objectForKey:@"urlpdf"];
    }
    else if ([_articalDic objectForKey:@"urlhtml"])
    {
        _isPDF = NO;
       _urlstring = [_articalDic objectForKey:@"urlhtml"];
        if ([[_articalDic objectForKey:@"urlvideo"] length]>5)
        {
            // 视频
            _haveVidio = YES;
            _vidioUrl = [_articalDic objectForKey:@"urlvideo"];
        }
    }
    if ([_articalDic objectForKey:@"title"])
    {
        _titleStr = [_articalDic objectForKey:@"title"];
    }
}


#pragma mark - 本地文件路径
// 自己写的
//- (NSString*)localFilePath
//{
//    NSString *documentsPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/LocalFile"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDir = FALSE;
//    BOOL isDirExist = [fileManager fileExistsAtPath:documentsPath isDirectory:&isDir];
//    if (isDirExist == NO)
//    {
//        BOOL bCreateDir = [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        if(!bCreateDir)
//        {
//            NSLog(@"Create Audio Directory Failed.");
//        }
//    }
//    return documentsPath;
//}
//
#pragma mark - 增加阅读数
- (void)upReadCounts
{
    // 增加阅读数
    _addReadCounts = YES;
    [self requestMainDataWithURLString:[NSString stringWithFormat:kAddReadCountsUrl,_articalID]];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [WXApi registerApp:@"wxe0742138717ee3fe"];
//    self.tencentAuth = [[TencentOAuth alloc] initWithAppId:@"1104472845" andDelegate:self];
    
    self.title=_titleStr;
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
    
    // 底部工具栏
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreenHeight - kToolBarHeight-64, kScreenWidth, kToolBarHeight)];
    
    NSArray *imageArray = @[@"收藏.png",@"评价.png",@"分享.png",@"下载.png"];
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < imageArray.count; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, (kToolBarHeight-10)*0.7, kToolBarHeight-10)];
        [btn setBackgroundImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = kSubItemsTag + i;
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [itemArray addObject:item];
        
        if (i < imageArray.count-1)
        {
            UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            [itemArray addObject:spaceItem];
        }
    }
    [toolBar setItems:itemArray animated:YES];
    toolBar.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:toolBar];
    // 增加阅读数
    [self upReadCounts];
    
    NSURL *url;
    if (_isPDF)
    {
        NSString *fileName = [[_urlstring componentsSeparatedByString:@"/"] lastObject];
        NSString *toPath = [NSString stringWithFormat:@"%@/%@",[PathManager getCatePathWithType:PDFPath],fileName];
        BOOL exit = [[NSFileManager defaultManager] fileExistsAtPath:toPath isDirectory:nil];
        if (exit)
        {
            url = [NSURL fileURLWithPath:toPath];
        }
        else
        {
            url = [NSURL URLWithString:_urlstring];
        }
    }
    else
    {
       url = [NSURL URLWithString:_urlstring];
    }
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kToolBarHeight-64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    // 可以缩放
    _webView.multipleTouchEnabled = YES;
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinAction:)];
    [_webView addGestureRecognizer:pin];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_webView addGestureRecognizer:pan];
    
    [self.view bringSubviewToFront:toolBar];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.needSwipeShowMenu=NO;
}

#pragma mark - 页面将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.needSwipeShowMenu=YES;
    
    if (_netRequesting)
    {
        [[NetManager getShareManager] cancelRequestOperation];
    }
}

#pragma mark - 拖拽
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self.view];
//    NSLog(@"%f,%f",point.x,point.y);
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
}
#pragma mark - 缩放
- (void)pinAction:(UIPinchGestureRecognizer *)pin
{
    pin.view.transform = CGAffineTransformScale(pin.view.transform, pin.scale, pin.scale);
    pin.scale = 1.0f;
}


#pragma mark - 网络请求
#pragma mark -- 开始请求
- (void)requestMainDataWithURLString:(NSString *)urlStr
{
    _netRequesting = YES;
    NetManager *netManager = [NetManager getShareManager];
    netManager.delegate = self;
    netManager.action = @selector(requestFinished:);
    [netManager requestDataWithUrlString:urlStr];
}

#pragma mark --网络请求完成
- (void)requestFinished:(NetManager *)netManager
{
    _netRequesting = NO;
    if (_collection)// 收藏
    {
        _collection = NO;
        if (netManager.downLoadData)
        {
            [self.view removeLoadingVIewInView:self.view andTarget:self];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
            if ([[dict objectForKey:@"respCode"] integerValue] == 1000)
            {
                [self.view addAlertViewWithMessage:@"收藏成功" andTarget:self];
            }
            else
            {
                [self.view addAlertViewWithMessage:[dict objectForKey:@"remark"] andTarget:self];
            }
        }
        else
        {
            // 失败
            [self.view addAlertViewWithMessage:@"请求不到数据，请重试" andTarget:self];
        }
    }
    else if (_downLoadVidio) // 下载
    {
        _downLoadVidio = NO;
        [self.view removeLoadingVIewInView:self.view andTarget:self];
        if (netManager.downLoadData)
        {
            NSString *fileName = [[_vidioUrl componentsSeparatedByString:@"/"] lastObject];
            NSString *toPath = [NSString stringWithFormat:@"%@/%@",[PathManager getCatePathWithType:VidioPath],fileName];
            if (toPath)
            {
                BOOL exit = [netManager.downLoadData writeToFile:toPath atomically:YES];
                if (exit)
                {
                    [self.view addAlertViewWithMessage:@"文件下载成功" andTarget:self];
                    UIImage *image = [self getVidioImageWithVidioPath:toPath];
                    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                    NSDictionary *currentDownloadVidio = @{@"VidioName":fileName,@"VidioPath":toPath,@"title":[_articalDic objectForKey:@"title"],@"type":[_articalDic objectForKey:@"type"],@"image":imageData};
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSMutableArray *downloadVidioArray = [[NSMutableArray alloc]init];
                    [downloadVidioArray addObject:currentDownloadVidio];
                    if ([defaults objectForKey:@"VidioList"])
                    {
                        NSArray *savedArray = [defaults objectForKey:@"VidioList"];
                        for (NSDictionary *dic in savedArray)
                        {
                            [downloadVidioArray addObject:dic];
                        }
                    }
                    [defaults setObject:downloadVidioArray forKey:@"VidioList"];
                    [defaults synchronize];
                }
                else {
                    [self.view addAlertViewWithMessage:@"文件写入本地失败" andTarget:self];
                }
            }
            else {
                [self.view addAlertViewWithMessage:@"文件存储路径不存在" andTarget:self];
            }
        }
        else {
            [self.view addAlertViewWithMessage:@"文件下载失败,请检查网络" andTarget:self];
        }
    }
    else if (_addReadCounts) // 增加阅读数
    {
        _addReadCounts = NO;
    }
    else if (_login)// 登陆
    {
        _login = NO;
        [self.view removeLoadingVIewInView:self.view andTarget:self];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:netManager.downLoadData options:0 error:nil];
        if ([[dic objectForKey:@"respCode"] integerValue] == 1000)
        {
            LoginView *logView = (LoginView *)[self.view viewWithTag:kLogViewTag];
            NSArray *keyArray = @[@"id",@"nickname",@"phone",@"email",@"icon"];
            NSDictionary *userInfo = [[dic objectForKey:@"userinfo"] lastObject];
            NSUserDefaults *userDe=[NSUserDefaults standardUserDefaults];
            [userDe setObject:logView.nameField.text forKey:@"userName"];
            [userDe setObject:logView.passwordField.text forKey:@"password"];
            for (NSString *keys in keyArray)
            {
                if ([userInfo objectForKey:keys])
                {
                    [userDe setObject:[userInfo objectForKey:keys] forKey:keys];
                }
            }
            [userDe synchronize];
            [self removeLogView];
        }
    }
}

#pragma mark - 获取视频缩略图
- (UIImage *)getVidioImageWithVidioPath:(NSString *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}


#pragma mark - 按钮点击事件
- (void)buttonClicked:(UIButton *)btn
{
    NSString *userid;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = btn.tag - kSubItemsTag;
    switch (index)
    {
        case 0:
        {
           // 收藏
            if ([defaults objectForKey:@"id"])
            {
                userid = [defaults objectForKey:@"id"];
                _collection = YES;
                NSString *urlStr = [NSString stringWithFormat:@"%@?userid=%@&articleid=%@",kCollectionUrl,userid,_articalID];
                NSLog(@"%@",urlStr);
                [self requestMainDataWithURLString:urlStr];
                [self.view addLoadingViewInSuperView:self.view andTarget:self];
            }
            else
            {
                _login = YES;
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户未登录，请登陆后再收藏" delegate:self cancelButtonTitle:@"登陆" otherButtonTitles:@"取消", nil];
                [alertV show];
            }
    }
            break;
        case 1:
        {
            // 评价
            if ([defaults objectForKey:@"id"])
            {
                JSZLEvaluationViewController *jszlEvaluVC = [[JSZLEvaluationViewController alloc]init];
                jszlEvaluVC.articalId = _articalID;// 9185
                [self.navigationController pushViewController:jszlEvaluVC animated:YES];
            }
            else
            {
                _login = YES;
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户未登录，请登陆后可评价" delegate:self cancelButtonTitle:@"登陆" otherButtonTitles:@"取消", nil];
                [alertV show];
            }
        }
            break;
        case 2:
        {
            [self createShareView];
        }
            break;
        case 3:
        {
            // 下载
            if ([defaults objectForKey:@"id"])
            {
                [self downLoad];
            }
            else
            {
                _login = YES;
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户未登录，请登陆后可下载" delegate:self cancelButtonTitle:@"登陆" otherButtonTitles:@"取消", nil];
                [alertV show];
            }
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - 分享View
- (void)createShareView
{
    UIView *darkV = [[UIView alloc]initWithFrame:self.view.bounds];
    darkV.backgroundColor = [UIColor colorWithWhite:14/255.0 alpha:0.5];
    darkV.tag = 11223344;
    [self.view addSubview:darkV];
    
    ShareView *shareV = [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:self options:0] lastObject];
    shareV.frame = CGRectMake(0, kScreenHeight-220-64, kScreenWidth, 220);
    shareV.backgroundColor = [UIColor colorWithWhite:248/255.0 alpha:1];
    shareV.target = self;
    shareV.action = @selector(shareCallBack:);
    shareV.shareTitle=_titleStr;
    shareV.shareUrl=_urlstring;
    [self.view addSubview:shareV];
}
- (void)shareCallBack:(id)sender
{
//    int shareTag=((UIButton *)sender).tag;//有可能不是按钮
//    NSLog(@"%d in share",shareTag);
    if ([sender isKindOfClass:[UIButton class]]&&((UIButton *)sender).tag==604) {
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:@"临床实验室"];
        NSString *mailContent=[@"<a href='" stringByAppendingFormat:@"%@'>链接地址</a>",_urlstring];
        [mailComposer setMessageBody:mailContent isHTML:YES];
        [self presentModalViewController:mailComposer animated:YES];
    }
    UIView *darkV = [self.view viewWithTag:11223344];
    [darkV removeFromSuperview];
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
//        NSLog(@"Result : %d",result);
    }
    if (error) {
//        NSLog(@"Error : %@",error);
    }
    [self dismissModalViewControllerAnimated:YES];
    
}

- (BOOL)localExitCurrentVidioName:(NSString *)vidioName
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"VidioList"];
    for (NSDictionary *dic in arr)
    {
        NSString *fileName = [dic objectForKey:@"VidioName"];
        if ([fileName isEqualToString:vidioName])
        {
            // 本地已经存在
            return YES;
        }
    }
    return NO;
}

#pragma mark - 上一页
- (void)popToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([_delegate respondsToSelector:_action])
    {
        [_delegate performSelector:_action withObject:nil afterDelay:NO];
    }
}

#pragma mark - 搜索
- (void)enterSearchViewController
{
    // 搜索
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建登陆View
- (void)createMinLoginView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    LoginView *logInV = [[[NSBundle mainBundle]loadNibNamed:@"LoginView" owner:self options:0] lastObject];
    logInV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-kToolBarHeight);
    logInV.center = CGPointMake(kScreenWidth/2, (kScreenHeight-64-kToolBarHeight)/2);
    logInV.tag = kLogViewTag;
    [self.view addSubview:logInV];
    
    logInV.backView.center = logInV.center;
    logInV.nameField.delegate = self;
    logInV.passwordField.delegate = self;
    
    [logInV.loginBtn addTarget:self action:@selector(logInMethod) forControlEvents:UIControlEventTouchUpInside];
    [logInV.resBtn addTarget:self action:@selector(resignMethod) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 登陆
- (void)logInMethod
{
    LoginView *logView = (LoginView *)[self.view viewWithTag:kLogViewTag];
    if ([logView.nameField.text length]&&[logView.passwordField.text length])
    {
        // 登陆
        [self.view addLoadingViewInSuperView:self.view andTarget:self];
        
        [self requestMainDataWithURLString:[NSString stringWithFormat:@"%@?username=%@&password=%@",COCIM_INTERFACE_LOGIN,logView.nameField.text,logView.passwordField.text]];
    }
    else
    {
        [self.view addAlertViewWithMessage:@"用户名或密码不能为空" andTarget:self];
    }
}

#pragma mark - 注册
- (void)resignMethod
{
    RegisterViewController *regVC = [[RegisterViewController alloc]init];
    [self presentViewController:regVC animated:YES completion:nil];
    _login = NO;
    [self removeLogView];
}

#pragma mark - 删除登陆View
- (void)removeLogView
{
    UIView *logView = [self.view viewWithTag:kLogViewTag];
    [logView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeLogView];
}

#pragma mark - 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - notification handler
// 键盘升起时 downV 跟着升起
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    LoginView *logView = (LoginView *)[self.view viewWithTag:kLogViewTag];
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    CGRect rect = logView.backView.frame;
    rect.origin.y += yOffset/3;
    [UIView animateWithDuration:duration animations:^{
        logView.backView.frame = rect;
    }];
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_downloadPdf)
    {
        _downloadPdf = NO;
        if (buttonIndex == 0)
        {
            // 下载
            [self saveCurrentFile];
        }
    }
    else if (_login)
    {
        if (buttonIndex == 0)
        {
            // 登陆
            [self createMinLoginView];
        }
        else
        {
           _login = NO;
        }
    }
}

#pragma mark - 下载
- (void)downLoad
{
    if (_isPDF)
    {
        // 下载PDF
        NSString *fileName = [[_urlstring componentsSeparatedByString:@"/"] lastObject];
        NSString *toPath = [NSString stringWithFormat:@"%@/%@",[PathManager getCatePathWithType:PDFPath],fileName];
        BOOL exit = [[NSFileManager defaultManager] fileExistsAtPath:toPath isDirectory:nil];
        if (exit)
        {
            _downloadPdf = YES;
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"本地已存在文件：%@",fileName] delegate:self cancelButtonTitle:@"覆盖" otherButtonTitles:@"取消", nil];
            [alertV show];
        }
        else
        {
            [self saveCurrentFile];
        }
    }
    else
    {
        // 下载视频
        if (_haveVidio)
        {
            _downLoadVidio = YES;
            NSString *currentVidioName = [[_vidioUrl componentsSeparatedByString:@"/"] lastObject];
            if ([self localExitCurrentVidioName:currentVidioName])
            {
                [self.view addAlertViewWithMessage:@"本地已经存在该视频" andTarget:self];
            }
            else
            {
                [self requestMainDataWithURLString:_vidioUrl];
                // 加载View
                [self.view addLoadingViewInSuperView:self.view andTarget:self];
            }
        }
        else
        {
            [self.view addAlertViewWithMessage:@"暂无视频" andTarget:self];
        }
    }
}

#pragma mark - 保存pdf
- (void)saveCurrentFile
{
    NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_urlstring]];
    NSString *fileName = [[_urlstring componentsSeparatedByString:@"/"] lastObject];
    NSString *toPath = [NSString stringWithFormat:@"%@/%@",[PathManager getCatePathWithType:PDFPath],fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:toPath isDirectory:nil])
    {
        [self.view addAlertViewWithMessage:@"文件已经存在" andTarget:self];
    }
    else
    {
        if (fileName != nil)
        {
            NSError *error = nil;
            BOOL exit = [fileData writeToFile:toPath options:NSDataWritingAtomic error:&error];
            if (exit)
            {
                [self pdfInfoSaveToUserDefaults];
            }
            else
            {
                // 写入本地失败
                [self.view addAlertViewWithMessage:@"文件写入本地失败" andTarget:self];
            }
        }
    }
}

#pragma mark - 将PDF文章信息存入沙盒
- (void)pdfInfoSaveToUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *pdfArray;
    if ([defaults objectForKey:@"PDFArray"])
    {
        pdfArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PDFArray"]];
    }
    else
    {
        pdfArray = [[NSMutableArray alloc]init];
    }
    [pdfArray insertObject:_articalDic atIndex:0];
    [defaults setObject:pdfArray forKey:@"PDFArray"];
    [self.view addAlertViewWithMessage:@"文件下载成功" andTarget:self];
}

//#pragma mark 微信所用
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [WXApi handleOpenURL:url delegate:self];
//}
//#pragma mark 微信所用
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [WXApi handleOpenURL:url delegate:self];
//}
//
//
//-(void) onResp:(BaseResp*)resp{
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
