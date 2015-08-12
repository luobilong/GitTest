//
//  EditPersonViewController.h
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditPersonViewControllerDelegate <NSObject>

- (void)iconAlertSuccess:(BOOL)sucseess;

@end
@interface EditPersonViewController : UIViewController

@property (nonatomic,assign) id<EditPersonViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *userID;


@end
