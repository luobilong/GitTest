//
//  JSZLCateView.m
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JSZLCateView.h"

@implementation JSZLCateView
#define kCategoryLableHeight 70
#define kCateLableTag 555
#define kTitleLableTag 999
{
    NSInteger _sumWidth;
}

- (void)awakeFromNib
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor colorWithWhite:232/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    _headButton.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    _headButton.layer.masksToBounds = YES;
    _headButton.layer.cornerRadius = 3;
    _headTitleLable.textColor = [UIColor colorWithRed:217/255.0 green:0 blue:6/255.0 alpha:1];
    _headTitleLable.backgroundColor = [UIColor clearColor];
    _headTitleLable.tag = kTitleLableTag;
    _headTitleLable.textColor = [UIColor colorWithRed:217/255.0 green:0/255.0 blue:37/255.0 alpha:1];
}

- (void)setCateDataArray:(NSArray *)cateDataArray
{
    _cateDataArray = cateDataArray;
    [self createCategoryLable];
}

- (void)createCategoryLable
{
     _headTitleLable.backgroundColor = [UIColor clearColor];
    NSInteger index = 0;
    NSInteger lableWidth = (self.bounds.size.width-25)/4;
    NSInteger hang = 2;
    if (_cateDataArray.count<=8)
    {
        hang = _cateDataArray.count%4?_cateDataArray.count/4+1:_cateDataArray.count/4;
    }
    for (int i = 0; i < hang; i ++)
    {
        for (int j = 0; j < 4; j ++)
        {
            if (_cateDataArray.count > i*4+j)
            {
                NSDictionary *subDict = [_cateDataArray objectAtIndex:index];
                UILabel *cateLab = [[UILabel alloc]initWithFrame:CGRectMake(5+j*(lableWidth+5), 40+i*(kCategoryLableHeight+10), lableWidth, kCategoryLableHeight)];
                cateLab.text = [subDict objectForKey:@"columnname"];
                cateLab.tag = kCateLableTag+index;
                cateLab.textAlignment = NSTextAlignmentCenter;
                cateLab.font = [UIFont systemFontOfSize:kTwoFontSize];
                cateLab.layer.masksToBounds = YES;
                cateLab.layer.cornerRadius = 5;
                cateLab.layer.borderWidth = 1;
                cateLab.layer.borderColor = [UIColor colorWithWhite:241/255.0 alpha:1].CGColor;
                cateLab.userInteractionEnabled = YES;
                cateLab.textColor = [UIColor colorWithWhite:86/255.0 alpha:1];
                cateLab.backgroundColor = [UIColor colorWithWhite:248/255.0 alpha:1];
                [self addSubview:cateLab];
                
                UITapGestureRecognizer *tapCateLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCateLableMethod:)];
                [cateLab addGestureRecognizer:tapCateLab];
                
                index ++;
            }
        }
    }
}

- (void)tapCateLableMethod:(UITapGestureRecognizer *)tap
{
    UILabel *tapLable = (UILabel *)tap.view;
    for (UIView *subV in self.subviews)
    {
        if ([subV isKindOfClass:[UILabel class]])
        {
            UILabel *cateLab = (UILabel *)subV;
            if (cateLab.tag != kTitleLableTag)
            {
                if (cateLab.tag == tapLable.tag)
                {
                    cateLab.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
                }
                else
                {
                    cateLab.backgroundColor = [UIColor colorWithWhite:248/255.0 alpha:1];
                }
            }
        }
    }
    
    if ([_target respondsToSelector:_action])
    {
        _enterMoreVC = YES;
        _selectedIndex = tapLable.tag - kCateLableTag;
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

- (IBAction)headButtonClicked:(id)sender
{
    if ([_target respondsToSelector:_action])
    {
        _enterMoreVC = NO;
        [_target performSelector:_action withObject:self afterDelay:NO];
    }}
@end
