//
//  JiShuZhuanLanCell.h
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiShuZhuanLanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
- (IBAction)moreButtonClicked:(id)sender;

@property (nonatomic,strong) NSDictionary *articleDict;
@property (nonatomic,assign) NSInteger currentArticalIndex;// 当前文章的多音
@property (nonatomic,assign) NSInteger dataIndex;// 当前cell的索引
@property (nonatomic,assign) BOOL addReadCounts;// 增加阅读数 手动增加
@property (nonatomic) id target;
@property (nonatomic) SEL buttonClickSelector;
@property (nonatomic) SEL jszlViewClickedAction;

@end
