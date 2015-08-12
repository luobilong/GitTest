//
//  UITableView+AddRefreshCategory.m
//  labonline
//
//  Created by cocim01 on 15/4/20.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "UITableView+AddRefreshCategory.h"
#import "EGORefreshTableHeaderView.h"

@implementation UITableView (AddRefreshCategory)


- (void)addRefreshViewInTableview:(UITableView *)tableV andTarget:(id<EGORefreshTableHeaderDelegate>)target
{
    EGORefreshTableHeaderView *refresV = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight)];
    refresV.delegate = target;
    [tableV addSubview:refresV];
}

@end
