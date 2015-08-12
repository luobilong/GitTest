//
//  JiShuZhuanLanDetailViewController.h
//  labonline
//
//  Created by cocim01 on 15/3/27.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"
//#import "WXApi.h"
//#import "TencentOpenAPI.framework/Headers/QQApi.h"
//#import "TencentOpenAPI.framework/Headers/QQApiInterface.h"
//#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"
#import <MessageUI/MessageUI.h>

@interface JiShuZhuanLanDetailViewController : UIViewController</*WXApiDelegate,*/MFMailComposeViewControllerDelegate>


@property (nonatomic,strong) NSDictionary *articalDic;

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) SEL action;
//@property(nonatomic, strong)TencentOAuth *tencentAuth;


@end
