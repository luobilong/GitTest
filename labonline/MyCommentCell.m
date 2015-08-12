//
//  MyCommentCell.m
//  labonline
//
//  Created by cocim01 on 15/4/1.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MyCommentCell.h"
#import "UIButton+WebCache.h"


@implementation MyCommentCell

- (void)awakeFromNib
{
    // Initialization code
    
    _backImgView.backgroundColor = [UIColor whiteColor];
    _backImgView.layer.masksToBounds = YES;
    _backImgView.layer.cornerRadius = 8;
    _backImgView.layer.borderWidth = 1;
    _backImgView.layer.borderColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1].CGColor;
    
    _userImageButton.layer.masksToBounds = YES;
    _userImageButton.layer.cornerRadius = _userImageButton.frame.size.height/2;
    _userImageButton.layer.borderColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1].CGColor;
    _userImageButton.layer.borderWidth = 1;
    
    
    _downImgView.backgroundColor =[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    _downImgView.layer.masksToBounds = YES;
    _downImgView.layer.cornerRadius = 2;
    _downImgView.layer.borderWidth = 1;
    _downImgView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    
    _userNameLable.textColor = [UIColor colorWithRed:87/255.0 green:87/255.0 blue:87/255.0 alpha:1];
    _workTitleLable.textColor = [UIColor colorWithRed:87/255.0 green:87/255.0 blue:87/255.0 alpha:1];
    _desLable.textColor = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1];
    _fromLable.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
    _timeLable.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
}



- (void)setCellHeight:(NSInteger)cellHeight
{
    _cellHeight = cellHeight;
    
//    NSInteger width = self.bounds.size.width;
//    NSLog(@"%ld",width);
//    CGRect originalRect = self.bounds;
//    originalRect.size.height = cellHeight;
//    self.frame = originalRect;
//    _userImageButton.frame = CGRectMake(20, 15, 50, 50);
//    _userNameLable.frame = CGRectMake(80, 15, width-90, 15);
//    _desLable.frame = CGRectMake(80, 30, width-90, cellHeight-);
//    _timeLable.frame = CGRectMake(80, 30+desLableHeight, width-90, 10);
}

- (void)setEvaluDict:(NSDictionary *)evaluDict
{
    _evaluDict = evaluDict;
    // 控件赋值
    [self fillControls];
}

- (void)fillControls
{
    // 头像 昵称 (从本地获取)
//    [_userImageButton setImageWithURL:[NSURL URLWithString:[_evaluDict objectForKey:@""]] placeholderImage:[UIImage imageNamed:@"33.jpg"]];
//    _userNameLable.text = [_evaluDict objectForKey:@"user_screennam"];
    _userNameLable.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    // 上传评论时 编码 所以此处解码
    _desLable.text = [_evaluDict objectForKey:@"text"] ;//[[_evaluDict objectForKey:@"text"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _timeLable.text = [_evaluDict objectForKey:@"created_at"];
    NSDictionary *articalDic = [_evaluDict objectForKey:@"articleinfo"];
    _workTitleLable.text = [articalDic objectForKey:@"title"];
//    _fromLable.text = [articalDic objectForKey:@"magazinename"];
    if ([[articalDic objectForKey:@"articletype"] integerValue] == 0)
    {
        // 文章 显示作者
        _fromLable.text = [NSString stringWithFormat:@"作者: %@",[articalDic objectForKey:@"author"]];
    }
    else
    {
        // 技术专栏 显示类目
        _fromLable.text = [NSString stringWithFormat:@"发布时间: %@",[articalDic objectForKey:@"releasetime"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
