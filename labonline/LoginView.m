//
//  LoginView.m
//  labonline
//
//  Created by 引领科技 on 15/4/21.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithWhite:100/255.0 alpha:0.7];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 12;
    _backView.layer.borderColor = [UIColor colorWithWhite:248/255.0 alpha:1].CGColor;
    _backView.layer.borderWidth = 1;
    _backView.backgroundColor = [UIColor colorWithWhite:248/255.0 alpha:1];
    
    _backView.center = self.center;
    
    [_resBtn setTitleColor:[UIColor colorWithRed:218/255.0 green:44/255.0 blue:73/255.0 alpha:1] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = [UIColor colorWithRed:218/255.0 green:44/255.0 blue:73/255.0 alpha:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
