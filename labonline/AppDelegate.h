//
//  AppDelegate.h
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YRSideViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) YRSideViewController *sideViewController;

extern NSString *const COCIM_SERVER_PATH;
extern NSString *const COCIM_INTERFACE_LOGIN;
extern NSString *const COCIM_INTERFACE_REG;
extern NSString *const COCIM_INTERFACE_PAST_MAGAZINE;


@end

