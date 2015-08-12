//
//  MenuCell.m
//  labonline
//
//  Created by cocim01 on 15/5/7.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (void)awakeFromNib
{
    // Initialization code
    self.selectedLable.hidden = YES;
    _backBtn.backgroundColor = [UIColor clearColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    NSLog(@"setSelected");
    
    // Configure the view for the selected state
}

- (IBAction)btnClicked:(id)sender
{
//    NSLog(@"12345566");
    if ([_target respondsToSelector:_action])
    {
        [_target performSelector:_action withObject:self afterDelay:0];
    }
}
@end
