//
//  ShareView.h
//  labonline
//
//  Created by cocim01 on 15/4/9.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "TencentOpenAPI.framework/Headers/QQApi.h"
#import "TencentOpenAPI.framework/Headers/QQApiInterface.h"
#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"


@interface ShareView : UIView<WXApiDelegate>
@property (weak, nonatomic) IBOutlet UIButton *QQButton;
@property (weak, nonatomic) IBOutlet UIButton *QzoneButton;
@property (weak, nonatomic) IBOutlet UIButton *WeChatButton;
@property (weak, nonatomic) IBOutlet UIButton *momentsButton;
@property (weak, nonatomic) IBOutlet UIButton *EMailButton;
@property (weak, nonatomic) IBOutlet UIButton *SinaWebButton;
- (IBAction)QQButtonClicked:(id)sender;
- (IBAction)QzoneButtonClicked:(id)sender;
- (IBAction)WeChatButtonClicked:(id)sender;
- (IBAction)momentsButtonClicked:(id)sender;
- (IBAction)EMailButtonClicked:(id)sender;
- (IBAction)SinaWebButtonClicked:(id)sender;

@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

@property(nonatomic,strong) NSString *shareTitle;//要分享的标题
@property(nonatomic,strong) NSString *shareUrl;//要分享的网址

@end
