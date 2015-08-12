//
//  EJTMainView.h
//  labonline
//
//  Created by cocim01 on 15/4/28.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EJTMainView : UIView<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *productScrollView;

@property (nonatomic,strong) NSArray *productInfoArray;
//@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

@end
