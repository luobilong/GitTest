//
//  JiShuZhuanLanCell.m
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "JiShuZhuanLanCell.h"
#import "JiShuZhuanLanSubView.h"

@implementation JiShuZhuanLanCell
{
    NSInteger _selfViewWidth;
    NSInteger _selfViewHeight;
    NSArray *_articleArray;
}

#define kJiShuZhuanLanSubViewTag 222

- (void)awakeFromNib
{
    // Initialization code
    
    // 背景
    _selfViewWidth = self.contentView.frame.size.width;
    _selfViewHeight = self.contentView.frame.size.height;
    _backImgView.frame = CGRectMake(5, 5, self.bounds.size.width-10,self.bounds.size.height-10);
    _backImgView.backgroundColor = [UIColor whiteColor];
    _backImgView.layer.masksToBounds = YES;
    _backImgView.layer.cornerRadius = 8;
    _backImgView.layer.borderWidth = 1;
    _backImgView.layer.borderColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
    
    // 头部条
    _topImgView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _topImgView.layer.masksToBounds = YES;
    _topImgView.layer.cornerRadius = 3;
//    [self createJSZLSubViewWithCounts:5];
    //
    UIColor *redColor = [UIColor colorWithRed:232/255.0 green:0 blue:13/255.0 alpha:1];
    _titleLable.textColor = redColor;
    _titleLable.font = [UIFont systemFontOfSize:kOneFontSize];
    [_moreButton setTitleColor:redColor forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
}

- (void)setDataIndex:(NSInteger)dataIndex
{
    _dataIndex = dataIndex;
}

- (void)setCurrentArticalIndex:(NSInteger)currentArticalIndex
{
    _currentArticalIndex = currentArticalIndex;
}

- (void)setArticleDict:(NSDictionary *)articleDict
{
    _articleDict = articleDict;
    _titleLable.text = [_articleDict objectForKey:@"type"];
    _articleArray = [_articleDict objectForKey:@"article"];
    if (_articleArray.count<=5)
    {
        _moreButton.hidden = YES;
    }
    [self createJSZLSubViewWithCounts:_articleArray.count];
}


#pragma mark - 循环创建JiShuZhuanLanSubView 
// 最多5个
- (void)createJSZLSubViewWithCounts:(NSInteger)counts
{
    if (counts>=5)
    {
        counts = 5;
    }
    for (int i = 0; i < counts; i ++)
    {
        NSDictionary *subDict = [_articleArray objectAtIndex:i];
        JiShuZhuanLanSubView *jiShuZLView = [[[NSBundle mainBundle]loadNibNamed:@"JiShuZhuanLanSubView" owner:self options:0] lastObject];
        jiShuZLView.tag = kJiShuZhuanLanSubViewTag+i;
        jiShuZLView.frame = CGRectMake(11, 35+i*40, kScreenWidth-22, 39);
        jiShuZLView.subDict = subDict;
        jiShuZLView.index = i;
        [self addSubview:jiShuZLView];
        
        if (_addReadCounts&&(i == _currentArticalIndex))
        {
            NSInteger readCounts = [[subDict objectForKey:@"seenum"] integerValue] + 1;
            jiShuZLView.youLanCountsLable.text = [NSString stringWithFormat:@"%ld",readCounts];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
        [jiShuZLView addGestureRecognizer:tap];
        
        if (i<counts-1)
        {
            UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 74+i*40, kScreenWidth-30, 1)];
            lineLab.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
            [self  addSubview:lineLab];
        }
    }
}

#pragma mark - 点击技术专栏View
- (void)tapMethod:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    if ([tapView isKindOfClass:[JiShuZhuanLanSubView class]])
    {
        JiShuZhuanLanSubView *jszlSunV = (JiShuZhuanLanSubView *)tapView;
        _currentArticalIndex = jszlSunV.tag - kJiShuZhuanLanSubViewTag;
        if ([self.target respondsToSelector:self.jszlViewClickedAction])
        {
            [self.target performSelector:self.jszlViewClickedAction withObject:jszlSunV afterDelay:NO];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreButtonClicked:(id)sender
{
    if ([self.target respondsToSelector:self.buttonClickSelector])
    {
        [self.target performSelector:self.buttonClickSelector withObject:self afterDelay:NO];
    }
}
@end
