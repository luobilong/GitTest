//
//  NavigationButton.h
//  labonline
//
//  Created by cocim01 on 15/4/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationButton : UIButton

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) SEL action;
//- (void)setBackImageWithName:(NSString *)imageName andFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame andBackImageWithName:(NSString *)imageName;

@end
