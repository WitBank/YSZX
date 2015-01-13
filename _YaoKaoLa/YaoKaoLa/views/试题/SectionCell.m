//
//  SectionCell.m
//  yaokaola
//
//  Created by pro on 14/12/9.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "SectionCell.h"
#import "BaseViewController.h"
#import "SectionModel.h"

@interface SectionCell()

@end
@implementation SectionCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        UIView *bgv = [[UIView alloc] init];
        bgv.backgroundColor = UIColorFromRGB(0xF0F8FF);
//        bgv.backgroundColor = [UIColor redColor];
        self.selectedBackgroundView = bgv;
        [self makeView];
    }
    return self;
}
- (void)updateData:(SectionModel *)data{
    _questionsName.text = [NSString stringWithFormat:@"%@",data.questionsName];
    _CorrectNum.text = [NSString stringWithFormat:@"%@%%",data.CorrectNum];
    _totalNum.text = [NSString stringWithFormat:@"已答: %@ / %@ 道题",data.totalNum,data.questionNum];
}

- (void)makeView{
    
    _leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 22, 60)];
    _leftImg.image = [UIImage imageNamed:@"zjyuanquanshu.png"];
    [self.contentView addSubview:_leftImg];
    
    //标题
    _questionsName = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 40)];
    _questionsName.font = [UIFont boldSystemFontOfSize:14];
    _questionsName.numberOfLines = 0;
//    _questionsName.text = @"第八章 医疗用毒行药瓶管理方法";


    [self.contentView addSubview:_questionsName];
   
    //正确率
    UILabel *_crLb1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 37, 50, 20)];
    _crLb1.text = @"正确率";
    _crLb1.font = [UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:_crLb1];

    _CorrectNum = [[UILabel alloc] initWithFrame:CGRectMake(40, 37, 50, 20)];
//    _CorrectNum.text = @"10.22%";


    _CorrectNum.textColor = [UIColor orangeColor];
    _CorrectNum.font = [UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:_CorrectNum];

    
    //头像
    UIImageView *userim = [[UIImageView alloc] initWithFrame:CGRectMake(130, 40, 18, 18)];
    userim.image = [UIImage imageNamed:@"zjuser.png"];
//    userim.backgroundColor = [UIColor redColor];
    
    [self.contentView addSubview:userim];
    
    //已经回答
//    _questionNum = [[UILabel alloc] initWithFrame:CGRectMake(200, 37, 30, 20)];
//    _questionNum.font = [UIFont boldSystemFontOfSize:13];
//    _questionNum.textColor = [UIColor blueColor];
//    [self.contentView addSubview:_questionNum];

    //回答题数
    _totalNum = [[UILabel alloc] initWithFrame:CGRectMake(150, 37, 150, 20)];
    _totalNum.font = [UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:_totalNum];
    
    //输入铅笔
    UIImageView *editImg = [[UIImageView alloc] initWithFrame:CGRectMake(WinSize.width-30, 35, 20, 20)];
    editImg.image = [UIImage imageNamed:@"zjlxexam"];
    [self.contentView addSubview:editImg];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
