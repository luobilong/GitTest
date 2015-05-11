//
//  PictureShowView.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "PictureShowView.h"
#import "DeviceManager.h"
#import "UIImageView+WebCache.h"

@implementation PictureShowView
{
    NSInteger width;
    NSInteger height;
    NSInteger _currentPage;
    UIPageControl *_pageControl;
    UILabel *_titleLab;
    UIScrollView *_imageScroll;
    NSTimer *_mainTimer;
    UIView *_downV;
}
#define kPageControlWidth 80
#define kImageViewTag 5555

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self makeUpContent];
    }
    return self;
}

#pragma mark - 搭建UI控件
- (void)makeUpContent
{
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    _currentPage = 0;
    self.backgroundColor = [UIColor whiteColor];
    _imageScroll = [[UIScrollView alloc]initWithFrame:self.bounds];
    _imageScroll.contentSize = CGSizeMake(width, 0);
    _imageScroll.pagingEnabled = YES;
    _imageScroll.delegate = self;
    _imageScroll.showsHorizontalScrollIndicator = NO;
    [self addSubview:_imageScroll];
    
    _downV = [[UIView alloc]initWithFrame:CGRectMake(0, height-30, width, 30)];
    _downV.backgroundColor = [UIColor colorWithRed:169/255.0 green:168/255.0 blue:168/255.0 alpha:0.5];
    [self addSubview:_downV];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(width-kPageControlWidth, 10, kPageControlWidth-10, 10)];
    _pageControl.numberOfPages = 1;
    _pageControl.currentPage = 0;
    [_downV addSubview:_pageControl];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width-kPageControlWidth, 30)];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont systemFontOfSize:13];
    _titleLab.numberOfLines = 0;
    [_downV addSubview:_titleLab];
}


#pragma mark - 数据赋值
- (void)setImageInfoArray:(NSArray *)imageInfoArray
{
    _imageInfoArray = imageInfoArray;
    _imageScroll.contentSize = CGSizeMake(width*imageInfoArray.count, 0);
    [self createImageView];
    if (_imageInfoArray.count != 0)
    {
        _mainTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    }
    else
    {
        _titleLab.hidden = YES;
        _pageControl.hidden = YES;
        _downV.hidden = YES;
    }
}

#pragma mark - 根据数据创建轮播图
- (void)createImageView
{
    for (int i = 0; i < _imageInfoArray.count; i ++)
    {
        NSDictionary *dict = [_imageInfoArray objectAtIndex:i];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
        imgV.layer.masksToBounds = YES;
        imgV.layer.cornerRadius = 5;
        imgV.tag = kImageViewTag+i;
        imgV.userInteractionEnabled = YES;
        [_imageScroll addSubview:imgV];
        [imgV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"pictureurl"]] placeholderImage:[UIImage imageNamed:@"moren.png"]];// 加载时显示加载图片 pictureurl
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageMethod:)];
        [imgV addGestureRecognizer:tap];
        _pageControl.numberOfPages = _imageInfoArray.count;
    }
    if (_imageInfoArray.count == 0)
    {
        // 显示默认图
        _pageControl.numberOfPages = 1;
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        imgV.layer.masksToBounds = YES;
        imgV.image = [UIImage imageNamed:@"moren.png"];
        imgV.layer.cornerRadius = 5;
        imgV.userInteractionEnabled = YES;
        [_imageScroll addSubview:imgV];
    }
}

#pragma mark - 点击图片进入详情
- (void)tapImageMethod:(UITapGestureRecognizer *)tap
{
    _imageIndex = tap.view.tag-kImageViewTag;
    if ([self.target respondsToSelector:self.action])
    {
        [self.target performSelector:self.action withObject:self withObject:nil];
    }
}

#pragma mark - 定时器转换图片
- (void)timerMethod
{
    // 定时器
    if (_currentPage<_imageInfoArray.count-1)
    {
        _currentPage++;
    }
    else if ((_imageInfoArray.count-1)== _currentPage)
    {
        _currentPage = 0;
    }
    [self changePicture];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentPage = scrollView.contentOffset.x/width;
    _pageControl.currentPage = _currentPage;
    NSDictionary *subDict = [_imageInfoArray objectAtIndex:_currentPage];
    _titleLab.text = [subDict objectForKey:@"title"];;
}

#pragma mark - 变换图片与标题
- (void)changePicture
{
    NSDictionary *subDict = [_imageInfoArray objectAtIndex:_currentPage];
    float y = _imageScroll.contentOffset.y;
    _imageScroll.contentOffset = CGPointMake(_currentPage*width, y);
    _pageControl.currentPage = _currentPage;
    _titleLab.text = [subDict objectForKey:@"title"];
}


- (void)dealloc
{
    [_mainTimer invalidate];
    _mainTimer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
