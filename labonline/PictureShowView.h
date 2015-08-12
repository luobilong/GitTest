//
//  PictureShowView.h
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureShowView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *imageInfoArray;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

@property (nonatomic,assign) NSInteger imageIndex;

@end
