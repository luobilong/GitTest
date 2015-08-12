//
//  EditPersonViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EditPersonViewController.h"
#import "PersonEditCell.h"
#import "EditSubViewController.h"
#import "AFNetworkTool.h"
#import "UIView+Category.h"

@interface EditPersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditSubViewControllerDelegate,UIAlertViewDelegate>
{
    UITableView *_myTableV;
    NSMutableArray *_baseDataArray;
    UIButton *imageBtn;
    UIImage *_currentImage;
    BOOL _commitSuccess;
}
@end

@implementation EditPersonViewController
#define kHeadViewHeight 110
#define kHeadViewTag 888
#define kHeadImageButtonTAg 889
#define kHeadImageButtonHeight 80
#define kSubViewHeight 40
#define kSubViewTag 999
#define kLeftLableWidth 100

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _commitSuccess = NO;
    self.title = @"个人编辑";
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // 左侧返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 35, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"返回角.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToPrePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 22)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(commitImage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadViewHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setFrame:CGRectMake((kScreenWidth-kHeadImageButtonHeight)/2, (kHeadViewHeight-kHeadImageButtonHeight)/2, kHeadImageButtonHeight, kHeadImageButtonHeight)];
    
    if ([defaults objectForKey:@"icon"]&&[[defaults objectForKey:@"icon"] hasPrefix:@"http"])
    {
        NSData *imageDa = [NSData dataWithContentsOfURL:[NSURL URLWithString:[defaults objectForKey:@"icon"]]];
        [imageBtn setBackgroundImage:[UIImage imageWithData:imageDa] forState:UIControlStateNormal];
    }
    else
    {
        _currentImage = [UIImage imageNamed:@"头像.png"];
        [imageBtn setBackgroundImage:_currentImage forState:UIControlStateNormal];
    }
    
    imageBtn.layer.masksToBounds = YES;
    imageBtn.layer.cornerRadius = kHeadImageButtonHeight/2;
    imageBtn.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
    imageBtn.layer.borderWidth = 1;
    [imageBtn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:imageBtn];
    
    [self makeUpDataContent];
    _myTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 1+kHeadViewHeight, kScreenWidth, kScreenHeight-200) style:UITableViewStylePlain];
    _myTableV.delegate = self;
    _myTableV.dataSource = self;
    _myTableV.showsVerticalScrollIndicator = NO;
    _myTableV.backgroundColor = [UIColor clearColor];
    _myTableV.separatorColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    [self.view addSubview:_myTableV];
    
    _currentImage = imageBtn.imageView.image;
//    NSLog(@"%@",_currentImage);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self makeUpDataContent];
    [_myTableV reloadData];
}

#pragma mark - 构成数据源
- (void)makeUpDataContent
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _baseDataArray = [[NSMutableArray alloc]init];
    NSArray *cateTitle = @[@"nickname",@"phone",@"email"];
    NSArray *textArray = @[@"昵称",@"手机号",@"邮箱"];
    for (int i = 0;i < cateTitle.count;i ++)
    {
        NSString *content;
        if ([defaults objectForKey:[cateTitle objectAtIndex:i]])
        {
            content = [defaults objectForKey:[cateTitle objectAtIndex:i]];
        }
        else
        {
            content = @"";
        }
        NSDictionary *subDict = @{@"Title":[textArray objectAtIndex:i],@"Content":content};
        [_baseDataArray addObject:subDict];
    }
}

- (void)commitImage
{
    // 修改完成  http://192.168.0.153:8181/labonline/hyController/updateTx.do?userid=80BE983A9EBC4B079247C4DDA518C2A8&usericon=dfwsvwsvedwvds
    NSData *_data = UIImageJPEGRepresentation(_currentImage, 0.3);
//    NSLog(@"提交图片");
    NSString *encodedImageStr = [_data base64Encoding];
    NSString *imageString = [encodedImageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"userid":_userID,@"usericon":imageString};
    [self.view addLoadingViewInSuperView:self.view andTarget:self];
    [AFNetworkTool postJSONWithUrl:kCommitImageUrl parameters:dic success:^(id responseObject)
    {
        [self.view removeLoadingVIewInView:self.view andTarget:self];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger respCode = [[dic objectForKey:@"respCode"] integerValue];
        if (respCode == 1000)
        {
            // 成功
            _commitSuccess = YES;
        }
        else
        {
            _commitSuccess = NO;
        }
        [self createAlertViewWithMessage:[dic objectForKey:@"remark"]];
    } fail:^{
        [self.view removeLoadingVIewInView:self.view andTarget:self];
       [self createAlertViewWithMessage:[dic objectForKey:@"修改失败"]];
    }];
}

#pragma mark - 创建alertView
- (void)createAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_commitSuccess)
    {
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(iconAlertSuccess:)])
        {
            [self.delegate iconAlertSuccess:_commitSuccess];
        }
    }
}


- (void)backToPrePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 修改头像
#pragma mark -- 图片点击事件
- (void)selectImage:(UIButton *)btn
{
    // 选取图片
    [self createActionSheet];
}
#pragma mark --创建选择器
- (void)createActionSheet
{
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册获取图片", nil];
    [chooseImageSheet showInView:self.view];

}

#pragma mark --UIActionSheetDelegate -->选取图片方式
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0://From album
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController presentModalViewController:picker animated:YES];
            break;
        }
        default:
        {
            break;
        }
    }
}


#pragma mark --拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSData *data;
    if ([mediaType isEqualToString:@"public.image"]){
        //不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.8];
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        //将二进制数据生成UIImage
        _currentImage = [UIImage imageWithData:data];
        [imageBtn setBackgroundImage:_currentImage forState:UIControlStateNormal];
    }
}

#pragma mark --压缩图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma mark - UITableView
#pragma mark --UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _baseDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSubViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"PersonEditCell";
    PersonEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonEditCell" owner:self options:0] lastObject];
    }
    NSDictionary *dict = [_baseDataArray objectAtIndex:indexPath.row];
    cell.titleLable.text = [dict objectForKey:@"Title"];
    cell.contentLable.text = [dict objectForKey:@"Content"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_baseDataArray objectAtIndex:indexPath.row];
    EditSubViewController *subVC = [[EditSubViewController alloc]init];
    subVC.delegate = self;
    subVC.dataDict = dict;
    subVC.alterType = indexPath.row;
    subVC.userID = _userID;
    [self.navigationController pushViewController:subVC animated:YES];
}


- (void)reloadNewInfoWithString:(NSString *)string andAlterType:(NSInteger)alterType
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[_baseDataArray objectAtIndex:alterType]];
    [dict setObject:string forKey:@"Content"];
    [_baseDataArray replaceObjectAtIndex:alterType withObject:dict];
    [_myTableV reloadData];
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
