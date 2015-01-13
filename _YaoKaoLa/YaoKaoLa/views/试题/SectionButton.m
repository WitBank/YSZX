//
//  SectionButton.m
//  yaokaola
//
//  Created by pro on 14/12/9.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "SectionButton.h"
#import "SectionModel.h"

@interface SectionButton()
{
UIButton *_bt;//加号减号

UILabel *_questionsName; //章节名称
UILabel *_questionsSortId; //章节ID
UILabel *_questionNum;//已经回答
UILabel *_totalNum;//总题个数
UILabel *_CorrectNum; //正确个数

UILabel *avgnum;     //正确率

int percent;
}
@end
@implementation SectionButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        float t = 250/255.0;
        self.backgroundColor = [UIColor colorWithRed:t green:t blue:t alpha:1];
        [self makeView];
    }
    return self;
}
- (void)openSection{
    self.isOn = YES;
    _bt.selected = YES;
}
- (void)closeSecton{
    self.isOn = NO;
    _bt.selected = NO;
}

//加号 减号 UIButton
- (void)makeView{
    
    //加号
    _bt = [UIButton buttonWithType:UIButtonTypeCustom];
    _bt.frame = CGRectMake(15,0,20,20);
    [_bt setBackgroundImage:[UIImage imageNamed:@"zhangjielianxi.png"] forState:UIControlStateNormal];
    //减号
    [_bt setBackgroundImage:[UIImage imageNamed:@"suo.png"] forState:UIControlStateSelected];

    //竖线
    UIImageView *line =  [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 20, 60)];
    line.image = [UIImage imageNamed:@"zjshuxian.png"];
//    line.backgroundColor = [UIColor redColor];
    
    [self addSubview:line];
    [self addSubview:_bt];
    
    [self makeView1];
}
- (void)updateData:(SectionModel *)data{
    if (data == nil) {
        return;
    }
    _questionsName.text = [NSString stringWithFormat:@"%@",data.questionsName];
    _CorrectNum.text = [NSString stringWithFormat:@"%@%%",data.CorrectNum];
    _totalNum.text = [NSString stringWithFormat:@"已答: %@ / %@ 道题",data.totalNum,data.questionNum];
    
}
- (void)makeView1{
    
    _questionsName = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 50)];
    _questionsName.font = [UIFont boldSystemFontOfSize:16];
    _questionsName.numberOfLines = 0;


    [self addSubview:_questionsName];
    //正确率
    UILabel *corect = [[UILabel alloc] initWithFrame:CGRectMake(85, 45, 50, 30)];
    corect.text = @"正确率";
    corect.font = [UIFont boldSystemFontOfSize:13];
    [self addSubview:corect];
    
    _CorrectNum = [[UILabel alloc] initWithFrame:CGRectMake(40, 45, 50, 30)];
    _CorrectNum.textAlignment = NSTextAlignmentCenter;

    
    _CorrectNum.textColor = [UIColor orangeColor];
    _CorrectNum.font = [UIFont boldSystemFontOfSize:13];
    [self addSubview:_CorrectNum];
    
    
    //头像
    UIImageView *userim = [[UIImageView alloc] initWithFrame:CGRectMake(130, 52, 18, 18)];
    userim.image = [UIImage imageNamed:@"zjuser.png"];
    [self addSubview:userim];
    
//    //已经回答
//    _questionNum = [[UILabel alloc] initWithFrame:CGRectMake(200, 45, 100, 30)];
//
//    
//    _questionNum.font = [UIFont boldSystemFontOfSize:13];
//
//    _questionNum.textColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
//    [self addSubview:_questionNum];
    
    
    
    
    //回答总题数
    _totalNum = [[UILabel alloc] initWithFrame:CGRectMake(150, 45, 150, 30)];

    _totalNum.font = [UIFont boldSystemFontOfSize:13];
    [self addSubview:_totalNum];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
