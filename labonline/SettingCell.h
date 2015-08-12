//
//  SettingCell.h
//  labonline
//
//  Created by cocim01 on 15/4/7.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *subImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLable;
@property (weak, nonatomic) IBOutlet UISwitch *onOrOffSwich;
- (IBAction)onOrOffSwitchValueChanged:(id)sender;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) NSInteger cellIndex;
- (void)fillDataWithIndex:(NSInteger)index andDataArray:(NSArray *)array;

@end
