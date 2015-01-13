//
//  AnswerCell.m
//  yaokaola
//
//  Created by pro on 14/11/30.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "AnswerCell.h"
#import "BaseViewController.h"
@interface AnswerCell()
{
    UILabel *_answerNum;
    UILabel *_answers;
}
@end
@implementation AnswerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //选项题号
        _answerNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
        _answerNum.textAlignment = NSTextAlignmentCenter;
        _answerNum.font = [UIFont systemFontOfSize:16];
        _answerNum.layer.borderWidth = 1;
        _answerNum.layer.borderColor = [[UIColor whiteColor ] CGColor];
        _answerNum.layer.masksToBounds = YES;
        [self.contentView addSubview:_answerNum];
        //内容
        _answers = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width-55, 60)];
        _answers.numberOfLines = 0;
        _answers.font = [UIFont systemFontOfSize:15];
        _answers.adjustsFontSizeToFitWidth = YES;
        _answers.textColor = [UIColor grayColor];
        [self.contentView addSubview:_answers];
        UIView *slv = [[UIView alloc] init];
        slv.backgroundColor = [UIColor whiteColor];
        [self setSelectedBackgroundView:slv];
    }
    return self;
}
//选中状态
- (void)setAnswerSelected:(BOOL)animated{
    UIColor *color = UIColorFromRGB(0x2ea4fe);
    if (!animated) {
        _answerNum.layer.borderColor = [color CGColor];
        _answerNum.textColor = color;
        _answerNum.backgroundColor = [UIColor whiteColor];
        _answers.textColor = [UIColor blackColor];
    }else{
        _answerNum.backgroundColor = color;
        _answerNum.textColor = [UIColor whiteColor];
        _answers.textColor = UIColorFromRGB(0x2ea4fe);
    }
}
- (void)updateData:(AnswerModel *)model{
    _answerNum.text = [NSString stringWithFormat:@"%c",[model.selectKey characterAtIndex:model.selectKey.length-1]];
    _answers.text = [NSString stringWithFormat:@"%@",model.selectValue];
    if (model.isSigle) {
        _answerNum.layer.cornerRadius = 15;

    }else{
        _answerNum.layer.cornerRadius = 0;
    }
    [self setAnswerSelected:model.isSelected];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
