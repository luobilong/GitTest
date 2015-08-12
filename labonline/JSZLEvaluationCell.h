//
//  JSZLEvaluationCell.h
//  labonline
//
//  Created by cocim01 on 15/3/27.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSZLEvaluationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *evaluationLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (nonatomic,assign) NSInteger cellHeight;
@property (nonatomic,strong) NSDictionary *evaluDict;

@end
