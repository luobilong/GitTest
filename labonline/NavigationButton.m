//
//  NavigationButton.m
//  labonline
//
//  Created by cocim01 on 15/4/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "NavigationButton.h"

@implementation NavigationButton


- (instancetype)initWithFrame:(CGRect)frame andBackImageWithName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(butttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)setBackImageWithName:(NSString *)imageName andFrame:(CGRect)frame
{
    self.frame = frame;
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addTarget:self.delegate action:self.action forControlEvents:UIControlEventTouchUpInside];
}

- (void)butttonClick
{
    if ([_delegate respondsToSelector:_action])
    {
        [_delegate performSelector:_action withObject:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
