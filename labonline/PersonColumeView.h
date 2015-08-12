//
//  PersonColumeView.h
//  labonline
//
//  Created by cocim01 on 15/4/1.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonColumeView : UIView

@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,assign) NSInteger currentViewIndex;
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;


@end
