//
//  MenuCell.h
//  labonline
//
//  Created by cocim01 on 15/5/7.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
- (IBAction)btnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *selectedLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

@end
