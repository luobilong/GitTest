//
//  ProductCollectionCell.h
//  labonline
//
//  Created by cocim01 on 15/5/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCollectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImgV;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *productRemoveButton;

@end
