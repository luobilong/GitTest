//
//  OffLineVidioCell.h
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffLineVidioCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *vidioImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *authorLable;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)playButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

@end
