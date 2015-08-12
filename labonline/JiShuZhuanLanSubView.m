//
//  JiShuZhuanLanSubView.m
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JiShuZhuanLanSubView.h"

@implementation JiShuZhuanLanSubView


- (void)awakeFromNib
{
    _titleLable.textColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1];
    _titleLable.font = [UIFont systemFontOfSize:kOneFontSize];
    
    _fromLable.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1];
    _fromLable.font = [UIFont systemFontOfSize:kTwoFontSize];
    
    _youLanCountsLable.textColor = [UIColor colorWithRed:232/255.0 green:0 blue:13/255.0 alpha:1];
    _youLanCountsLable.font = [UIFont systemFontOfSize:kTwoFontSize];
}

- (void)setSubDict:(NSDictionary *)subDict
{
    _subDict = subDict;
    _titleLable.text = [_subDict objectForKey:@"title"];
    _fromLable.text = [@"发布时间: " stringByAppendingFormat:@"%@",[_subDict objectForKey:@"releasetime"]];
    _youLanCountsLable.text = [NSString stringWithFormat:@"%ld",[[_subDict objectForKey:@"seenum"] integerValue]];
    ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
