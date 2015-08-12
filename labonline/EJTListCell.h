//
//  EJTListCell.h
//  labonline
//
//  Created by cocim01 on 15/4/29.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EJTListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qKLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatetimeLabel;

@end
