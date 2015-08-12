//
//  EJTListCell.m
//  labonline
//
//  Created by cocim01 on 15/4/29.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EJTListCell.h"

@implementation EJTListCell

- (void)awakeFromNib
{
    // Initialization code
    _backImgV.layer.masksToBounds = YES;
    _backImgV.layer.cornerRadius = 5;
    _backImgV.layer.borderColor = [UIColor colorWithWhite:227/255.0 alpha:1].CGColor;
    _backImgV.layer.borderWidth = 1;
    _backImgV.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    _imageV.layer.masksToBounds = YES;
    _imageV.layer.cornerRadius = 2;
    _imageV.layer.borderColor = [UIColor colorWithWhite:245/255.0 alpha:1].CGColor;
    _imageV.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
