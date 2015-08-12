//
//  ProductCateView.h
//  labonline
//
//  Created by cocim01 on 15/4/28.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCateView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

// 模拟数据
//@property (nonatomic,assign) int counts;
@property (nonatomic,strong) NSArray *productArray;
@property (nonatomic,assign) NSInteger selectedButtonIndex;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) SEL action;

@end
