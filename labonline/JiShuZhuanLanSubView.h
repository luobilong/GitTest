//
//  JiShuZhuanLanSubView.h
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiShuZhuanLanSubView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *fromLable;
@property (weak, nonatomic) IBOutlet UILabel *youLanCountsLable;
@property (weak, nonatomic) IBOutlet UIImageView *youLanImgV;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSDictionary *subDict;

@end
