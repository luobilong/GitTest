//
//  LeftViewController.h
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewControllerDelegate <NSObject>

- (void)pushViewControllerWithIndex:(NSInteger)type;

@end

@interface LeftViewController : UIViewController

@property (nonatomic,assign) id<LeftViewControllerDelegate> delegate;

@end
