//
//  TestTopView.m
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "TestTopView.h"
#import "AControll.h"
#import "BaseViewController.h"

#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/testTopModel.plist"]
@interface TestTopView()
{
    UILabel *_crectlb; // 正确率
    UISlider *sl;//进度条
    UILabel *_prDays;//练习天使数
    UILabel *_number;//全站排名
    UILabel *_answerCount;//答题数
    UILabel *_allCount;//总题数
    NSTimer *_timer;
}
@end
@implementation TestTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeView];

    }
    return self;
}
//无网
- (void)faildUpdata{
    //解档
    TestModel *data =[NSKeyedUnarchiver unarchiveObjectWithFile:PATH];
    
    [self updateDataWith:data];
}
//下载图片
- (void)downloadTest{
   
}
//更新数据
- (void)updateDataWith:(TestModel *)data{
    if (data == nil) {
        return;
    }
    
    [data setNullValue];


    _allCount.text = [NSString stringWithFormat:@"/%@",data.totalQuestions];
    _answerCount.text = [NSString stringWithFormat:@"%@",data.total];
    _crectlb.text = [NSString stringWithFormat:@"%@",data.correct];
    _prDays.text = [NSString stringWithFormat:@"%@",data.practiceDays];
    _number.text = [NSString stringWithFormat:@"%@",data.ranking];
    sl.value = 0;
    if (_timer) {
        [_timer invalidate],_timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0f target:self selector:@selector(sliderChanged:) userInfo:data.correct repeats:YES];
    
    //归档
    [NSKeyedArchiver archiveRootObject:data toFile:PATH];
    

}
- (void)sliderChanged:(NSTimer*)timer{
    int t = [[timer userInfo] floatValue]*100;

    if (t <= (int)(sl.value*100)) {
        [_timer invalidate],_timer = nil;
        return;
    }
    sl.value += 0.01;
}
- (void)makeView{
    float tty = (self.frame.size.height - 170)*0.5;
    //总题数
    _allCount = [AControll createLabelWithFrame:CGRectMake(WinSize.width-95, tty, 60, 40) text:@"/0" font:[UIFont systemFontOfSize:15] textColor:[UIColor grayColor]];
    [self addSubview:_allCount];
    //答题数
    _answerCount = [AControll createLabelWithFrame:CGRectMake(WinSize.width-166, tty, 80, 40) text:@"0" font:[UIFont systemFontOfSize:20] textColor:UIColorFromRGB(0x87BF26)];
    _answerCount.textAlignment = NSTextAlignmentRight;
    [self addSubview:_answerCount];
    //下载图片
//    UIButton *dimg = [AControll createButtonWithFrame:CGRectMake(WinSize.width-35, tty+10, 20, 20) title:nil titleColor:nil backgroungImage:@"shitixiazai" tag:0];
//    [dimg addTarget:self action:@selector(downloadTest) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:dimg];
    //正确率
    _crectlb = [AControll createLabelWithFrame:CGRectMake(20, tty, 80, 40) text:@"正确率0%" font:[UIFont boldSystemFontOfSize:14] textColor:UIColorFromRGB(0x2ea4fe)];
    //进度条
    sl = [[UISlider alloc] initWithFrame:CGRectMake(15, tty+30, WinSize.width-30, 30)];
    [sl addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [sl setThumbImage:[UIImage imageNamed:@"currentimg.png"] forState:UIControlStateNormal];
    [sl setMaximumTrackImage:[UIImage imageNamed:@"gundong.png"] forState:UIControlStateNormal];
    [sl setMinimumTrackImage:[[UIImage imageNamed:@"gundong1.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]forState:UIControlStateNormal];
    UIView *imsl = [[UIView alloc] initWithFrame:sl.frame];
    [self addSubview:sl];
    [self addSubview:imsl];
    //三个button
    float tx = (WinSize.width-60-120)*0.5;
    NSArray *imags = @[@"kaoruo",@"kaoba",@"kaoshen"];
    NSArray *titles = @[@"考弱",@"考霸",@"考神"];
    for (int i = 0 ; i < 3; ++i) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(30+i*(tx+40), 60+tty, 40, 45);
        [bt setBackgroundImage:[UIImage imageNamed:imags[i]] forState:UIControlStateNormal];
        [bt setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1",imags[i]]] forState:UIControlStateSelected];
        UILabel *lb = [AControll createLabelWithFrame:CGRectMake(30+i*(tx+40), 100+tty, 40, 40) text:titles[i] font:[UIFont boldSystemFontOfSize:16] textColor:[UIColor grayColor]];
        [self addSubview:lb];
        [self addSubview:bt];
        bt.tag = 100+i;
    }
    [self addSubview:_crectlb];
    //练习天数，全站排名
    NSArray * imgs2 = @[@"shitilianxidays",@"shitiquanzhan"];
    NSArray * titles2 = @[@"练习天数",@"全站排名"];
    float ttx = (WinSize.width-220)*0.5;
    for(int i = 0;i < 2; ++i){
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(ttx+(110)*i, 145+tty, 20, 20)];
        UILabel *lb = [AControll createLabelWithFrame:CGRectMake(ttx+20+(110)*i, 145+tty, 60, 20) text:titles2[i] font:[UIFont boldSystemFontOfSize:14] textColor:nil];
        if (i == 0) {
            _prDays = [AControll createLabelWithFrame:CGRectMake(lb.frame.origin.x+60, 145+tty, 30, 20) text:@"0" font:[UIFont systemFontOfSize:15] textColor:UIColorFromRGB(0x2ea4fe)];
            _prDays.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_prDays];
        }else{
            _number = [AControll createLabelWithFrame:CGRectMake(lb.frame.origin.x+60, 145+tty, 30, 20) text:@"0" font:[UIFont systemFontOfSize:15] textColor:UIColorFromRGB(0x2ea4fe)];
            _number.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_number];
        }
        img1.image = [UIImage imageNamed:imgs2[i]];
        [self addSubview:lb];
        [self addSubview:img1];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    float t = sl.value;
    _crectlb.text = [NSString stringWithFormat:@"正确率%d%%",(int)(t*100)];
    if (t < 0.1) {
        [self setSeletedWithNum:0];
    }else if(t < 0.5){
        [self setSeletedWithNum:1];
    }else if(t < 0.9){
        [self setSeletedWithNum:2];
    }else{
        [self setSeletedWithNum:3];
    }
}

- (void)setSeletedWithNum:(int)num{
    for (int i = 0; i<3; ++i) {
        UIButton *bt = (UIButton *)[self viewWithTag:100+i];
        if (i < num) {
            bt.selected = YES;
        }else{
            bt.selected = NO;
        }
    }
}
- (void)dealloc
{
    [sl removeObserver:self forKeyPath:@"value"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
