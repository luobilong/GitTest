//
//  EJTMainView.m
//  labonline
//
//  Created by cocim01 on 15/4/28.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EJTMainView.h"
#import "UIButton+WebCache.h"

@implementation EJTMainView
#define kProductsButtonBaseTag 800
#define kPageButtonTag 567


- (void)setProductInfoArray:(NSArray *)productInfoArray
{
    _productInfoArray = productInfoArray;
    [self createProductBoxWithDataArray:_productInfoArray];
    [self createPageButtonWithCounts:_productInfoArray.count%9?_productInfoArray.count/9+1:_productInfoArray.count/9];
}


- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor colorWithWhite:221/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    
    _topImgV.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    _topImgV.layer.masksToBounds = YES;
    _topImgV.layer.borderWidth = 1;
    _topImgV.layer.borderColor = [UIColor colorWithWhite:221/255.0 alpha:1].CGColor;
    _productScrollView.pagingEnabled = YES;
    _productScrollView.delegate =  self;
    
    _titleLabel.textColor = [UIColor colorWithRed:217/255.0 green:0/255.0 blue:37/255.0 alpha:1];

}

#pragma mark - 创建页码按钮
- (void)createPageButtonWithCounts:(NSInteger)counts
{
    for (int i = 0; i < counts; i ++)
    {
        _topImgV.userInteractionEnabled = YES;
        UIButton *pageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pageBtn setFrame:CGRectMake(kScreenWidth-40-30*i, 5, 20, 20)];
        [pageBtn setTitle:[NSString stringWithFormat:@"%d",counts-i] forState:UIControlStateNormal];
        pageBtn.tag = kPageButtonTag+counts-i-1;
        pageBtn.layer.masksToBounds = YES;
        pageBtn.layer.cornerRadius = 10;
        pageBtn.titleLabel.font = [UIFont systemFontOfSize:kTwoFontSize];
        [pageBtn addTarget:self action:@selector(pageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_topImgV addSubview:pageBtn];
    }
    [self changButtonBackColorWithIndex:0];
}

#pragma mark - 页码按钮点击事件
- (void)pageBtnClicked:(UIButton *)btn
{
    [self changButtonBackColorWithIndex:btn.tag-kPageButtonTag];
    _productScrollView.contentOffset = CGPointMake((btn.tag-kPageButtonTag)*(kScreenWidth-10), 0);
}

#pragma mark - 选中页码按钮
- (void)changButtonBackColorWithIndex:(NSInteger)index
{
    for (int i = 0; i <= 3; i ++)
    {
        UIButton *btn = (UIButton*)[self viewWithTag:i+kPageButtonTag];
        if (i == index)
        {
            [btn setBackgroundColor:[UIColor colorWithRed:217/255.0 green:0 blue:37/255.0 alpha:1]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:[UIColor colorWithRed:217/255.0 green:0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



#pragma mark - 创建产品按钮
- (void)createProductBoxWithDataArray:(NSArray *)array
{
    NSInteger pages = array.count%9?array.count/9+1:array.count/9;
//    float maxWidth = _productScrollView.bounds.size.width;
//    float maxHeight = _productScrollView.bounds.size.height;
    float maxWidth = self.bounds.size.width;
    float maxHeight = self.bounds.size.height-40;//(self.bounds.size.height*kScreenHeight/480);
    _productScrollView.contentSize = CGSizeMake(maxWidth*pages, 0);
    int currentProduct = 0;
    for (int i = 0; i < pages; i ++)
    {
        for (int j = 0; j < 3; j++)
        {
            for (int k = 0; k < 3; k ++)
            {
                if (currentProduct<array.count)
                {
                    NSDictionary *subDic= [_productInfoArray objectAtIndex:currentProduct];
                    float width = (maxWidth-12)/3;
                    float height = maxHeight/3;
                    float labHeight = 20;
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake(5+i*maxWidth+k*(width+1), 5+j*height, width, height-labHeight)];
                    btn.tag = kProductsButtonBaseTag+currentProduct;
//                    [btn setBackgroundImage:[UIImage imageNamed:@"文章缩略图.png"] forState:UIControlStateNormal];
                    if ([[subDic objectForKey:@"producticon"] length]>2)
                    {
                        [btn setImageWithURL:[NSURL URLWithString:[subDic objectForKey:@"producticon"]] placeholderImage:[UIImage imageNamed:@"暂无图片.jpg"]];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"暂无图片.jpg"] forState:UIControlStateNormal];
                    }
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 3;
                    btn .layer.borderColor = [UIColor colorWithWhite:235/255.0 alpha:1].CGColor;
                    btn.layer.borderWidth = 1;
                    [btn addTarget:self action:@selector(productBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [_productScrollView addSubview:btn];
                    
                    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(5+i*maxWidth+k*(width+1), 5+(j+1)*height-labHeight, width, labHeight)];
                    titleLab.textAlignment = NSTextAlignmentCenter;
                    titleLab.text = [subDic objectForKey:@"producttitle"];//[NSString stringWithFormat:@"产品%d",currentProduct+1];
                    titleLab.textColor = [UIColor colorWithWhite:86/255.0 alpha:1];
                    titleLab.font = [UIFont systemFontOfSize:kThreeFontSize];
                    [_productScrollView addSubview:titleLab];
                    
                    currentProduct++;
                }
            }
        }
    }
}

#pragma mark- 产品按钮点击事件
- (void)productBtnClicked:(UIButton *)btn
{
    NSDictionary *subDic= [_productInfoArray objectAtIndex:btn.tag-kProductsButtonBaseTag];
    if ([_target respondsToSelector:_action])
    {
        [_target performSelector:_action withObject:subDic afterDelay:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changButtonBackColorWithIndex:(int)scrollView.contentOffset.x/(kScreenWidth-10)];
}


@end
