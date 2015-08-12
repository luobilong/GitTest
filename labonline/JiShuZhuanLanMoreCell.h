//
//  JiShuZhuanLanMoreCell.h
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiShuZhuanLanSubView.h"

@interface JiShuZhuanLanMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;
@property (weak, nonatomic) IBOutlet UIButton *youLanButton;
@property (weak, nonatomic) IBOutlet UILabel *youLanCountsLable;
@property (weak, nonatomic) IBOutlet UIView *backView;


@property (nonatomic,strong) NSDictionary *subDict;

@end
