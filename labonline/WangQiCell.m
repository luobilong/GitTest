//
//  WangQiCell.m
//  labonline
//
//  Created by 引领科技 on 15/3/25.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "WangQiCell.h"

@implementation WangQiCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
