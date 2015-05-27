//
//  JiShuZhuanLanMoreCell.m
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JiShuZhuanLanMoreCell.h"

@implementation JiShuZhuanLanMoreCell

- (void)awakeFromNib
{
    // Initialization code

    self.backgroundColor = [UIColor clearColor];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 5;
    
    _titleLable.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
    _detailLable.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
    _youLanCountsLable.textColor = [UIColor colorWithRed:239/255.0 green:0 blue:0 alpha:1];
    
}

- (void)setSubDict:(NSDictionary *)subDict
{
    _subDict = subDict;
//    NSLog(@"%@",subDict);
    
    _titleLable.text = [_subDict objectForKey:@"title"];
    _detailLable.text = [@"发布时间: " stringByAppendingFormat:@"%@",[_subDict objectForKey:@"releasetime"]];
    _youLanCountsLable.text = [NSString stringWithFormat:@"%ld",[[_subDict objectForKey:@"seenum"] integerValue]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    NSLog(@"4567890");
}

@end
