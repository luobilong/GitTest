//
//  JSZLEvaluationCell.m
//  labonline
//
//  Created by cocim01 on 15/3/27.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JSZLEvaluationCell.h"
#import "UIButton+WebCache.h"


@implementation JSZLEvaluationCell

- (void)awakeFromNib
{
    // Initialization code
    _userImageButton.layer.masksToBounds = YES;
    _userImageButton.layer.cornerRadius = _userImageButton.frame.size.height/2;
    _userImageButton.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
    _userImageButton.layer.borderWidth = 1;
    
    _userNameLable.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    _evaluationLable.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1];
    _timeLable.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1];
    
}

- (void)setCellHeight:(NSInteger)cellHeight
{
    _cellHeight = cellHeight;
    self.frame = CGRectMake(0, 0, kScreenWidth, cellHeight);
    // 调整坐标
    NSInteger width = self.bounds.size.width;
    NSInteger height = cellHeight;
    _userImageButton.frame = CGRectMake(5, 10, 50, 50);
    _userNameLable.frame = CGRectMake(60, 5, width-70, 15);
    _timeLable.frame = CGRectMake(60, height-15, width-70, 10);
    _evaluationLable.frame = CGRectMake(60, 20, width-70, height-35);
}

- (void)setEvaluDict:(NSDictionary *)evaluDict
{
    _evaluDict = evaluDict;
    
    _evaluationLable.text = [[_evaluDict objectForKey:@"text"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _timeLable.text = [_evaluDict objectForKey:@"created_at"];
    _userNameLable.text = [_evaluDict objectForKey:@"source"];
    [_userImageButton setImageWithURL:[NSURL URLWithString:[_evaluDict objectForKey:@"urlsourcepic"]] placeholderImage:[UIImage imageNamed:@"头像.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
