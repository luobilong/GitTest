//
//  ShowPicture.h
//  labonline
//
//  Created by cocim01 on 15/4/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPicture : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *imageDataArray;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

- (void)setSelectedIndex:(NSInteger)index andImageDataArray:(NSArray *)array;

@end
