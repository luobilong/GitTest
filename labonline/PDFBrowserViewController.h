//
//  PDFBrowserViewController.h
//  labonline
//
//  Created by cocim01 on 15/3/31.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFBrowserViewController : UIViewController

@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic,copy) NSString *articalId;
@property (nonatomic,copy) NSString *filePath;
//@property (nonatomic,copy) NSString *fileName;

@end
