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
    _headTitleLable.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    [self createCategoryLable];
}

- (void)createCategoryLable
{
    NSInteger index = 0;
    NSInteger lableWidth = (self.bounds.size.width-50)/4;
    for (int i = 0; i < 2; i ++)
    {
        for (int j = 0; j < 4; j ++)
        {
            UILabel *cateLab = [[UILabel alloc]initWithFrame:CGRectMake(10+j*(lableWidth+10), 40+i*(kCategoryLableHeight+10), lableWidth, kCategoryLableHeight)];
            cateLab.text = @"生物检验";
            cateLab.tag = kCateLableTag+index;
            cateLab.textAlignment = NSTextAlignmentCenter;
            cateLab.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
            cateLab.font = [UIFont systemFontOfSize:kTwoFontSize];
            cateLab.layer.masksToBounds = YES;
            cateLab.layer.cornerRadius = 5;
            cateLab.layer.borderWidth = 1;
            cateLab.layer.borderColor = [UIColor colorWithWhite:241/255.0 alpha:1].CGColor;
            cateLab.userInteractionEnabled = YES;
            [self addSubview:cateLab];
            
            UITapGestureRecognizer *tapCateLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCateLableMethod:)];
            [cateLab addGestureRecognizer:tapCateLab];
            
            index ++;
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
                    cateLab.backgroundColor = [UIColor whiteColor];
                }
            }
        }
    }
    
    if ([_target respondsToSelector:_action])
    {
        _enterMoreVC = YES;
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
