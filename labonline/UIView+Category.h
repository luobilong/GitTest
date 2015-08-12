//
//  UIView+Category.h
//  labonline
//
//  Created by cocim01 on 15/4/14.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

//+(void)removeLoadingVIewInView:(UIView *)superV;
//+ (void)addLoadingViewInView:(UIView *)superView;
- (void)addAlertViewWithMessage:(NSString *)message andTarget:(id)target;

- (void)addLoadingViewInSuperView:(UIView *)superView andTarget:(UIViewController*)taget;
- (void)removeLoadingVIewInView:(UIView *)superV andTarget:(UIViewController *)target;

@end
