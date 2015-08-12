//
//  MainListCell.h
//  labonline
//
//  Created by cocim01 on 15/4/1.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *categoryTitleButton;
@property (weak, nonatomic) IBOutlet UIView *baseBackView;

@property (nonatomic,strong) NSDictionary *listDict;
@property (nonatomic,assign) NSInteger selectedIndex;//被点击的文章索引
@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,assign) BOOL addReadCounts;// 增加阅读数
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

@end
