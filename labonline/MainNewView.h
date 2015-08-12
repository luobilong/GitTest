//
//  MainNewView.h
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNewView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *magazineImageV;
@property (weak, nonatomic) IBOutlet UIButton *smallNewButton;
@property (weak, nonatomic) IBOutlet UILabel *magazineTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *qiCiLable;
@property (weak, nonatomic) IBOutlet UILabel *desLable;

@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic,strong) NSArray *imageDataArray;// 模拟数据
@property (nonatomic,strong) NSDictionary *mainMagazineDict;
@property (nonatomic,assign) NSInteger clickImageIndex;

@end
