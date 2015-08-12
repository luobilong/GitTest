//
//  SearchCell.m
//  labonline
//
//  Created by cocim01 on 15/4/9.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib
{
    // Initialization code
    
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 5;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
    
    _titleLable.textColor = [UIColor colorWithWhite:93/255.0 alpha:1];
    _detailLable.textColor = [UIColor colorWithWhite:125/255.0 alpha:1];
    _LookCountLable.textColor = [UIColor colorWithRed:241/255.0 green:0 blue:38/255.0 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
