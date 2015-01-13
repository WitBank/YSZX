//
//  RandomTopView.m
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "RandomTopView.h"
#import "AControll.h"
@interface RandomTopView()
{
    UILabel *_countLabel;
    UILabel *_timeLabel;
    NSTimer *_timer;
    int _second;//秒
    int _minute;
    int _allPage; // 总题数
    int _currenPage;//当前题
    UILabel *lb;
}
@end
@implementation RandomTopView
- (int)getTime{
    int t = _second +_minute*60;
    return  t;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float t = 243/255.0;
        self.backgroundColor = [UIColor colorWithRed:t green:t blue:t alpha:1];
        [self makeView];
    }
    return self;
}
- (void)makeView{
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 20, 20)];
    imv.layer.masksToBounds = YES;
    imv.layer.cornerRadius = 10;
    imv.image = [UIImage imageNamed:@"exercise_title.png"];
    [self addSubview:imv];
    float t = (self.frame.size.width-20)/3.0;
    CGRect frame = CGRectMake(15, 10, t, 30);
    lb = [AControll createLabelWithFrame:frame text:@"全部题库" font:[UIFont boldSystemFontOfSize:17] textColor:nil];
    [self addSubview:lb];
    //题数
    _countLabel = [AControll createLabelWithFrame:CGRectMake(15+t, 10, t, 30) text:@"1/" font:[UIFont systemFontOfSize:17] textColor:nil];
    [self addSubview:_countLabel];
    //时间
    _timeLabel = [AControll createLabelWithFrame:CGRectMake(15+2*t, 10, t, 30) text:@"00:00" font:[UIFont systemFontOfSize:17] textColor:nil];
    [self addSubview:_timeLabel];
}
- (void)setCurrenPage:(int)page{
    _countLabel.text = [NSString stringWithFormat:@"%d/%d",page,_allPage];
}
- (void)setAllPage:(int)page{
    _allPage = page;
    _countLabel.text = [NSString stringWithFormat:@"1/%d",_allPage];
}
- (void)setTitleLbWith:(NSString *)st{
    lb.text = st;

    _timeLabel.text = @"";
}
//开始停止计时
- (void)startTime{
    if (_timer) {
        [_timer invalidate],_timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    _second = 0;
    _minute = 0;
}
- (void)stopTime{
   [_timer invalidate],_timer = nil;
}
- (void)runTimer{
    _second++;
    if (_second>=60) {
        _second = 0;
        _minute++;
    }
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",_minute,_second];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
