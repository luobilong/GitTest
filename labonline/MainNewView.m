//
//  MainNewView.m
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainNewView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@implementation MainNewView
#define kImageButtonTag 112233


- (void)awakeFromNib
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    
    _smallNewButton.layer.masksToBounds = YES;
    _smallNewButton.layer.cornerRadius = 10;
    _smallNewButton.layer.borderColor = [UIColor colorWithWhite:245/255.0 alpha:1].CGColor;
    _smallNewButton.layer.borderWidth = 1;
    
    _magazineTitleLable.textColor = [UIColor colorWithWhite:86/255.0 alpha:1];
    _qiCiLable.textColor = [UIColor colorWithWhite:177/255.0 alpha:1];
    _desLable.textColor = [UIColor colorWithWhite:177/255.0 alpha:1];
    _magazineImageV.layer.masksToBounds = YES;
    _magazineImageV.layer.cornerRadius = 3;
    _magazineImageV.layer.borderColor = [UIColor colorWithWhite:235/255.0 alpha:1].CGColor;
    _magazineImageV.layer.borderWidth = 1;
}

- (void)setMainMagazineDict:(NSDictionary *)mainMagazineDict
{
    _mainMagazineDict = mainMagazineDict;
    [_magazineImageV setImageWithURL:[NSURL URLWithString:[_mainMagazineDict objectForKey:@"pictureurl"]] placeholderImage:nil];
    _magazineTitleLable.text = [_mainMagazineDict objectForKey:@"title"];
    _qiCiLable.text = [_mainMagazineDict objectForKey:@"qc"];
    _desLable.text = [_mainMagazineDict objectForKey:@"content"];
}

- (void)setImageDataArray:(NSArray *)imageDataArray
{
    _imageDataArray = imageDataArray;
    [self createImagesButton];
}

#pragma mark - 创建图片展示View
- (void)createImagesButton
{
    // 根据数据决定创建几个图片button
    NSInteger wid = self.frame.size.width;
    NSInteger hei = self.frame.size.height;
    NSInteger btnWidth = (wid-20)/5;
    NSInteger btnHeight = 70;
    for (int i = 0; i < _imageDataArray.count; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kImageButtonTag + i;
        [btn setFrame:CGRectMake(10+i*btnWidth, hei-btnHeight-5, btnWidth-3, btnHeight)];
        [btn setImageWithURL:[NSURL URLWithString:[_imageDataArray objectAtIndex:i]]];
        NSLog(@"%@",_imageDataArray);
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 1;
        btn.layer.borderColor = [UIColor colorWithWhite:220/255.0 alpha:1].CGColor;
        btn.layer.borderWidth = 1;
        [self addSubview:btn];
    }
}

#pragma mark - 点击放大图片
- (void)btnClicked:(UIButton *)btn
{
    _clickImageIndex = btn.tag - kImageButtonTag;
    // 图片按钮点击事件
    if ([_target respondsToSelector:_action])
    {
        [_target performSelector:_action withObject:self afterDelay:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
