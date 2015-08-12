//
//  OffLineVidioCell.m
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "OffLineVidioCell.h"

@implementation OffLineVidioCell

- (void)awakeFromNib
{
    // Initialization code
    
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 5;
    _backView.backgroundColor = [UIColor whiteColor];
    
    _titleLable.textColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1];
    _authorLable.textColor = [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1];
    
    _vidioImgView.layer.masksToBounds = YES;
    _vidioImgView.layer.cornerRadius = 5;
    _vidioImgView.layer.borderColor = [UIColor colorWithWhite:223/255.0 alpha:1].CGColor;
    _vidioImgView.layer.borderWidth = 1;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playButtonClicked:(id)sender
{
    if ([_target respondsToSelector:_action])
    {
        [_target performSelector:_action withObject:self afterDelay:NO];
    }
}
@end
