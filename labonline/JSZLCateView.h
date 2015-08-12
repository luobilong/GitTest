//
//  JSZLCateView.h
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSZLCateView : UIView
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *headTitleLable;
- (IBAction)headButtonClicked:(id)sender;

@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic,assign) BOOL enterMoreVC;
@property (nonatomic,strong) NSArray *cateDataArray;// 模拟数据
@property (nonatomic,assign) NSInteger selectedIndex;

@end
