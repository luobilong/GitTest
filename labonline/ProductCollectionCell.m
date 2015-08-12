//
//  ProductCollectionCell.m
//  labonline
//
//  Created by cocim01 on 15/5/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "ProductCollectionCell.h"

@implementation ProductCollectionCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 2;
    self.contentView.layer.borderColor = [UIColor colorWithWhite:235/255.0 alpha:1].CGColor;
    self.contentView.layer.borderWidth = 0.5;
    _productDetailLabel.textColor = [UIColor colorWithWhite:160/255.0 alpha:1];
    _productTitleLabel.textColor = [UIColor colorWithWhite:128/255.0 alpha:1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
