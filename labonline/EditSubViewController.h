//
//  EditSubViewController.h
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditSubViewControllerDelegate <NSObject>

- (void)reloadNewInfoWithString:(NSString *)string andAlterType:(NSInteger)alterType;

@end

@interface EditSubViewController : UIViewController

@property (nonatomic,copy) NSString *userID;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,assign) NSInteger alterType;
@property (nonatomic,assign) id<EditSubViewControllerDelegate> delegate;


@end
