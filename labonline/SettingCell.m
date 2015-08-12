//
//  SettingCell.m
//  labonline
//
//  Created by cocim01 on 15/4/7.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib
{
    // Initialization code
    _textLable.textColor = [UIColor colorWithWhite:87/255.0 alpha:1];
}

- (void)fillDataWithIndex:(NSInteger)index andDataArray:(NSArray *)array
{
    _cellIndex = index;
    _dataArray = array;
    _onOrOffSwich.hidden = YES;
    if (_cellIndex >= _dataArray.count-3)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = [_dataArray objectAtIndex:index];
    _subImageView.image = [UIImage imageNamed:[dic objectForKey:@"ImageName"]];
    _textLable.text = [dic objectForKey:@"TEXT"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onOrOffSwitchValueChanged:(id)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch.on)
    {
        // 开
    }
    else
    {
        // 关
    }
}

@end
