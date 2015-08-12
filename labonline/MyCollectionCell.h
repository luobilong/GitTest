//
//  MyCollectionCell.h
//  labonline
//
//  Created by cocim01 on 15/4/2.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *fromLable;
@property (weak, nonatomic) IBOutlet UILabel *cateLable;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;

@property (nonatomic,strong) NSDictionary *infoDict;
@property (nonatomic,assign) NSInteger cellIndex;

@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;


@end
