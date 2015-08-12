//
//  PersonColumeView.m
//  labonline
//
//  Created by cocim01 on 15/4/1.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "PersonColumeView.h"

@implementation PersonColumeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
//        [self uiConfig];
        
    }
    return self;
}

- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    [self uiConfig];
}

- (void)setCurrentViewIndex:(NSInteger)currentViewIndex
{
    _currentViewIndex = currentViewIndex;
    self.tag = _currentViewIndex;
}

- (void)uiConfig
{
    NSInteger wid = self.frame.size.width;
    NSInteger hei = self.frame.size.height;
    UIImageView *columeImgV = [[UIImageView alloc]initWithFrame:self.bounds];
    columeImgV.layer.masksToBounds = YES;
    columeImgV.layer.cornerRadius = hei/2;
    columeImgV.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
    columeImgV.layer.borderWidth = 1;
    [self addSubview:columeImgV];
    
    UIImageView *subImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, hei-10, hei-10)];
    subImgV.image = [UIImage imageNamed:[_dataDict objectForKey:@"ImageName"]];
    [columeImgV addSubview:subImgV];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10+hei, 10, wid-50-hei, hei-20)];
    lable.text = [_dataDict objectForKey:@"Title"];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1];
    lable.font = [UIFont systemFontOfSize:kOneFontSize];
    [columeImgV addSubview:lable];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapColumeV:)];
    [self addGestureRecognizer:tap];
    
}


- (void)tapColumeV:(UITapGestureRecognizer *)tap
{
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
