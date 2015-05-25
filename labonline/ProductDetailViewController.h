//
//  ProductDetailViewController.h
//  labonline
//
//  Created by 引领科技 on 15/5/5.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController

@property(nonatomic,strong)NSDictionary *proDetail;

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) SEL action;

@end
