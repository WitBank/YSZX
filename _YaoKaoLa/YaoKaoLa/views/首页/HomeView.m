//
//  HomeView.m
//  Product-Medicine
//
//  Created by Mac on 14/11/30.
//  Copyright (c) 2014年 PengLi. All rights reserved.
//

#import "HomeView.h"
#import "UIViewExt.h"
#import "HomeModel.h"
#import "KDGoalBar.h"
#import "PLGoalBar.h"



//获取物理屏幕的尺寸
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width) 
#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/homeModel.plist"]

@interface HomeView()
{
    UIImageView *imgView1;
    KDGoalBar *firstGoalBar;
    PLGoalBar *secondGoalBar;
    UIImageView *imgView2;
}

@end
@implementation HomeView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
    

}
//无网
- (void)faildUpdata{
    //解档
    HomeModel *data =[NSKeyedUnarchiver unarchiveObjectWithFile:PATH];
    

    self.homeModel= data;
    [self setNeedsDisplay ];
}

-(void)setHomeModel:(HomeModel *)homeModel
{
    if (_homeModel != homeModel) {
        _homeModel = homeModel;
        
    }

        _examDays.text = [NSString stringWithFormat:@"%@",_homeModel.examDays];
        _continuousLearning.text = [NSString stringWithFormat:@"%@",_homeModel.continuousLearning];
        _totalLearning.text = [NSString stringWithFormat:@"%@",_homeModel.totalLearning];
        
        
        _courseComplete.text = [NSString stringWithFormat:@"%@",_homeModel.courseComplete];
        _courseTotal.text = [NSString stringWithFormat:@"/%@分钟",_homeModel.courseTotal];
        classRate = [_homeModel.courseComplete floatValue]/[_homeModel.courseTotal floatValue]*100;
        [firstGoalBar setPercent:classRate animated:YES];

        
        _examComplete.text = [NSString stringWithFormat:@"%@",_homeModel.examComplete];
        _examTotal.text = [NSString stringWithFormat:@"/%@道",_homeModel.examTotal];

        practiceRate = [_homeModel.examComplete floatValue]/[_homeModel.examTotal floatValue]*100;
        [secondGoalBar setPercent:practiceRate animated:YES];


        
        _todayCourseComplete.text = [NSString stringWithFormat:@"%@",_homeModel.todayCourseComplete];
        _todayCourseTotal.text = [NSString stringWithFormat:@"/%@",_homeModel.todayCourseTotal];
        
        
        _todayExamComplete.text = [NSString stringWithFormat:@"%@",_homeModel.todayExamComplete];
        _todayExamTotal.text = [NSString stringWithFormat:@"/%@",_homeModel.todayExamTotal];

        //归档
        [NSKeyedArchiver archiveRootObject:homeModel toFile:PATH];

}
//- (void)update:(HomeModel *)model{
//    _examDays.text = [NSString stringWithFormat:@"%@",model.examDays];
//    _continuousLearning.text = [NSString stringWithFormat:@"%@",model.continuousLearning];
//    _totalLearning.text = [NSString stringWithFormat:@"%@",model.totalLearning];
//    
//    
//    _courseComplete.text = [NSString stringWithFormat:@"%@",model.courseComplete];
//    _courseTotal.text = [NSString stringWithFormat:@"/%@分钟",model.courseTotal];
//    classRate = [model.courseComplete floatValue]/[model.courseTotal floatValue];
//    
//    _examComplete.text = [NSString stringWithFormat:@"%@",model.examComplete];
//    _examTotal.text = [NSString stringWithFormat:@"/%@道",model.examTotal];
//    practiceRate = [model.examComplete floatValue]/[model.examTotal floatValue]*100;
//    NSLog(@"绿色:%.0f",practiceRate);
//    
//    _todayCourseComplete.text = [NSString stringWithFormat:@"%@",model.todayCourseComplete];
//    _todayCourseTotal.text = [NSString stringWithFormat:@"/%@分钟",model.todayCourseTotal];
//
//    
//    _todayExamComplete.text = [NSString stringWithFormat:@"%@",model.todayExamComplete];
//    _todayExamTotal.text = [NSString stringWithFormat:@"/%@道",model.todayExamTotal];
//    
//    
//}

-(void)layoutSubviews
{
    
    

    [super layoutSubviews];
    
    float h = (kScreenHeight-64-48)/3;

    
    



        if (self.frame.size.height == 480) {
        
        
        
        //iPhone 4
        //-------------------第一部分大图----------------------//
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, h)];
        img.image = [UIImage imageNamed:@"banner_02.png"];
        img.backgroundColor = [UIColor greenColor];
        [self addSubview:img];
        
        
        //备考
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(5,20, 20, 20)];
        img1.image = [UIImage imageNamed:@"shouye_06"];
        [self addSubview:img1];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(img.left + 30, img.top +15, 100, 30)];
        label.text = @"备考状态";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        
        //第一部分三个label
        
        NSArray *imgs1 = @[@"shouye_12@2x.png",@"shouye_15@2x.png",@"shouye_09@2x.png"];
        for (int i = 0; i < imgs1.count; i++) {
            
            UIImageView *imgs = [[UIImageView alloc] initWithFrame:CGRectMake((img.left + 25)+(kScreenWidth/3-10)*i, img.bottom - ((kScreenHeight-64-48)/3)/3-3,15,15)];
            [imgs setImage:[UIImage imageNamed:imgs1[i]]];
            [self addSubview:imgs];
            
        }
        
        
        NSArray *label1 = @[@"距离考试",@"连续学习",@"累计学习"];
        for (int i = 0;i < label1.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((img.left + 42)+(kScreenWidth/3-10)*i, img.bottom - ((kScreenHeight-64-48)/3)/3, 100, 10)];
            NSString *name = [label1 objectAtIndex:i];
            [label setText:name];
            //         label.adjustsFontSizeToFitWidth = YES;
            
            label.font = [UIFont fontWithName:nil size:12];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            
        }
        
        
        NSArray *dayImgs = @[@"天",@"天",@"天"];
        for (int i = 0; i < dayImgs.count; i++) {
            
            UILabel *dayimgs = [[UILabel alloc] initWithFrame:CGRectMake((img.left + 70)+(kScreenWidth/3-10)*i, img.bottom - ((kScreenHeight-64-48)/3)/6,10,10)];
            NSString *name = [dayImgs objectAtIndex:i];
            [dayimgs setText:name];
            dayimgs.textColor = [UIColor whiteColor];
            dayimgs.font = [UIFont fontWithName:nil size:10];
            
            
            //        [dayimgs setText:[UILabel :dayImgs[i]]];
            [img addSubview:dayimgs];
            
        }
        
        
        
        
        //请求数据的三个label布局
        
        _examDays = [[UILabel alloc]initWithFrame:CGRectMake(img.left +25, img.bottom - ((kScreenHeight-64-48)/3)/6-15,40,30)];
        
        _examDays.backgroundColor = [UIColor clearColor];
        _examDays.textColor = [UIColor whiteColor];
        _examDays.textAlignment = 2;
        
        
        [self addSubview:_examDays];
        
        
        _continuousLearning = [[UILabel alloc]initWithFrame:CGRectMake((img.left + 25)+(kScreenWidth/3-10), img.bottom - ((kScreenHeight-64-48)/3)/6-15,40,30)];
        _continuousLearning.backgroundColor = [UIColor clearColor];
        _continuousLearning.textColor = [UIColor whiteColor];
        _continuousLearning.textAlignment = 2;
        
        [self addSubview:_continuousLearning];
        
        _totalLearning = [[UILabel alloc]initWithFrame:CGRectMake((img.left + 25)+(kScreenWidth/3-10)*2, img.bottom - ((kScreenHeight-64-48)/3)/6-15,40,30)];
        _totalLearning.backgroundColor = [UIColor clearColor];
        _totalLearning.textColor = [UIColor whiteColor];
        _totalLearning.textAlignment = 2;
        
        [img addSubview:_totalLearning];
        
        
        
        
        
        
        
        //---------------第二部分两个百分比圆--------------------//
        
        
        //红色
        if(imgView1 == nil)
        {
            imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/8, h+h/8, 0, 0)];
            imgView1.backgroundColor = [UIColor redColor];
            
            
            firstGoalBar = [[KDGoalBar alloc]initWithFrame:CGRectMake((375-177)/2., 200, 177, 177)];
            //    [firstGoalBar setPercent:classRate animated:YES];
            [self addSubview:imgView1];
            [imgView1 addSubview:firstGoalBar];
            [firstGoalBar.percentLabel setTextColor:[UIColor colorWithRed:208/255.0 green:62/255.0 blue:34/255.0 alpha:1.0]];
            
            
            UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 60, 20)];
            redLabel.backgroundColor = [UIColor clearColor];
            redLabel.text = @"听课完成率";
            redLabel.font = [UIFont fontWithName:nil size:12];
            redLabel.textColor = [UIColor colorWithRed:208/255.0 green:62/255.0 blue:34/255.0 alpha:1.0];
            
            [imgView1 addSubview:redLabel];
            
            
        }
        
        
        
        
        
        //142, 193, 51绿色
        if (imgView2 == nil) {
            imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imgView1.right +kScreenWidth/8*3.5, h+h/8, 0, 0)];
            
            
            secondGoalBar = [[PLGoalBar alloc]initWithFrame:CGRectMake((375-177)/2., 200, 177, 177)];
            //    [secondGoalBar setPercent:practiceRate animated:YES];
            [self addSubview:imgView2];
            [imgView2 addSubview:secondGoalBar];
            [secondGoalBar.percentLabel setTextColor:[UIColor colorWithRed:142/255.0 green:193/255.0 blue:51/255.0 alpha:1.0]];
            
            
            UILabel *greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 60, 20)];
            greenLabel.backgroundColor = [UIColor clearColor];
            greenLabel.text = @"练习完成率";
            greenLabel.font = [UIFont fontWithName:nil size:12];
            greenLabel.textColor = [UIColor colorWithRed:142/255.0 green:193/255.0 blue:51/255.0 alpha:1.0];
            //        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0].CGColor);
            
            
            [imgView2 addSubview:greenLabel];
            
        }
        
        
        
        
        
        
        //分钟
        _courseComplete = [[UILabel alloc]initWithFrame:CGRectMake(_courseTotal.left -30,h+h/8+95, 30, 30)];
        
        _courseComplete.font = [UIFont fontWithName:nil size:12];
        _courseComplete.textColor = [UIColor colorWithRed:208/255.0 green:62/255.0 blue:34/255.0 alpha:1.0];
        _courseComplete.backgroundColor = [UIColor clearColor];
        _courseComplete.textAlignment = 2;
        [self addSubview:_courseComplete];
        
        _courseTotal = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/6+20,h+h/8+95, 80, 30)];
        //    _courseTotal.text = @"/3000分钟";
        _courseTotal.font = [UIFont fontWithName:nil size:12];
        _courseTotal.textColor = [UIColor blackColor];
        _courseTotal.backgroundColor = [UIColor clearColor];
        [self addSubview:_courseTotal];
        
        //道
        _examComplete = [[UILabel alloc]initWithFrame:CGRectMake(_examTotal.left-30, h+h/8+95, 30, 30)];
        _examComplete.textAlignment = 2;
        _examComplete.font = [UIFont fontWithName:nil size:12];
        _examComplete.textColor = [UIColor colorWithRed:142/255.0 green:193/255.0 blue:51/255.0 alpha:1.0];
        _examComplete.backgroundColor = [UIColor clearColor];
        [self addSubview:_examComplete];
        
        
        _examTotal = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/6*4+10, h+h/8+95, 80, 30)];
        //    _examTotal.text = @"/3499道";
        _examTotal.font = [UIFont fontWithName:nil size:12];
        _examTotal.textColor = [UIColor blackColor];
        _examTotal.backgroundColor = [UIColor clearColor];
        [self addSubview:_examTotal];
        
        
        
        
        
        //分隔线horizontal_gray_line
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,h+h*2/5*3, kScreenWidth, 1)];
        lineImg.image = [UIImage imageNamed:@"horizontal_gray_line"];
        lineImg.backgroundColor = [UIColor greenColor];
        [self addSubview:lineImg];
        
        
        //-----------------------第三部分-----------------------//
        //01
        
        
        
        //    UIImageView *img04 = [[UIImageView alloc] initWithFrame:CGRectMake(40,lineImg.bottom + kScreenHeight/6*2/10, 35, 35)];
        UIImageView *img04 = [[UIImageView alloc] initWithFrame:CGRectMake(40,h+h*2/5*3+h*2/5*2/6, 35, 35)];
        img04.image = [UIImage imageNamed:@"today_task"];
        [self addSubview:img04];
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(25, img04.bottom +3, 70, 30)];
        label4.text = @"今日任务";
        label4.font = [UIFont fontWithName:nil size:16];
        label4.textColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
        label4.backgroundColor = [UIColor whiteColor];
        [self addSubview:label4];

        UIImageView *img05 = [[UIImageView alloc] initWithFrame:CGRectMake(30 +(kScreenWidth - 30)/3,lineImg.bottom + kScreenHeight/6*2/10-5,20, 20)];
        img05.image = [UIImage imageNamed:@"headset"];
        [self addSubview:img05];
        
        UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(img05.right+4, lineImg.bottom + kScreenHeight/6*2/10-5, 30, 25)];
        label5.text = @"听课";
        label5.font = [UIFont fontWithName:nil size:14];
        label5.textColor = [UIColor blackColor];
        label5.backgroundColor = [UIColor clearColor];
        [self addSubview:label5];

        //分钟
        
        //请求数据----------------------------------------
        _todayCourseComplete = [[UILabel alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 60)/3-30, img05.bottom, 30, 25)];
        
        _todayCourseComplete.font = [UIFont fontWithName:nil size:17];
        _todayCourseComplete.textColor = [UIColor blackColor];
        _todayCourseComplete.textAlignment = 2;
        
        _todayCourseComplete.backgroundColor = [UIColor clearColor];
        _todayCourseComplete.textColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
        [self addSubview:_todayCourseComplete];
        
        
        
        
        
        
        _todayCourseTotal = [[UILabel alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 60)/3, img05.bottom, 35, 25)];
        
        _todayCourseTotal.font = [UIFont fontWithName:nil size:17];
        _todayCourseTotal.textColor = [UIColor blackColor];
        _todayCourseTotal.backgroundColor = [UIColor clearColor];
        [self addSubview:_todayCourseTotal];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(_todayCourseTotal.right, _todayCourseTotal.top+10, 25, 10)];
            lab.text = @"分钟";
            lab.font = [UIFont fontWithName:nil size:10];
            lab.textColor = [UIColor blackColor];
            lab.backgroundColor = [UIColor clearColor];
            [self addSubview:lab];

        
        
        
        
        //03
        UIImageView *img06 = [[UIImageView alloc] initWithFrame:CGRectMake(40 +(kScreenWidth - 40)/3*2,lineImg.bottom + kScreenHeight/6*2/10-5, 20, 20)];
        img06.image = [UIImage imageNamed:@"from_test@2x.png"];
        [self addSubview:img06];
        UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(img06.right +4,lineImg.bottom + kScreenHeight/6*2/10-5, 30, 25)];
        label6.text = @"练习";
        label6.font = [UIFont fontWithName:nil size:14];
        label6.textColor = [UIColor blackColor];
        label6.backgroundColor = [UIColor clearColor];
        [self addSubview:label6];
        
        //道----------------------------------------------------
        _todayExamComplete= [[UILabel alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 60)/3*2+20-30, img06.bottom, 30, 25)];
        //    _todayExamComplete.text = @"/10道";
        _todayExamComplete.font = [UIFont fontWithName:nil size:17];
        _todayExamComplete.textColor = [UIColor blackColor];
        _todayExamComplete.backgroundColor = [UIColor clearColor];
        _todayExamComplete.textAlignment = 2;
        _todayExamComplete.textColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
        [self addSubview:_todayExamComplete];
        
        
        
        _todayExamTotal = [[UILabel alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 60)/3*2+20, img06.bottom, 35, 25)];
        
        _todayExamTotal.font = [UIFont fontWithName:nil size:17];
        _todayExamTotal.textColor = [UIColor blackColor];
        _todayExamTotal.backgroundColor = [UIColor clearColor];
        [self addSubview:_todayExamTotal];
            
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(_todayExamTotal.right, _todayExamTotal.top+10, 25, 10)];
        lab2.text = @"道";
        lab2.font = [UIFont fontWithName:nil size:10];
        lab2.textColor = [UIColor blackColor];
        lab2.backgroundColor = [UIColor clearColor];
        [self addSubview:lab2];

    // 分隔线 竖线 vertical_gray_line  (label5.right)+(img06.left-label5.right)/2
        UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake((30 +(kScreenWidth - 30)/3-10+70)+((40 +(kScreenWidth - 40)/3*2-10)-(30 +(kScreenWidth - 30)/3-10+70))/2, h+h*2/3*2+h*2/3/7, 0.5, 60)];
        verticalLine.image = [UIImage imageNamed:@"vertical_gray_line@2x.png"];
            [self addSubview:verticalLine];
            

        
        
        
    }else if(self.frame.size.height != 480){
        
        
        
        
        
        
        //iPhone 5---------------------------------------//
        //-------------------第一部分大图----------------------//
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, h)];
        img.image = [UIImage imageNamed:@"banner_02.png"];
        img.backgroundColor = [UIColor greenColor];
        [self addSubview:img];
        
        
        //备考
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(5,20, 20, 20)];
        img1.image = [UIImage imageNamed:@"shouye_06"];
        [self addSubview:img1];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(img.left + 30, img.top +15, 100, 30)];
        label.text = @"备考状态";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        
        //第一部分三个label
        
        NSArray *imgs1 = @[@"shouye_12@2x.png",@"shouye_15@2x.png",@"shouye_09@2x.png"];
        for (int i = 0; i < imgs1.count; i++) {
            
            UIImageView *imgs = [[UIImageView alloc] initWithFrame:CGRectMake((img.left + 25)+(kScreenWidth/3-10)*i, img.bottom - ((kScreenHeight-64-48)/3)/3-3,15,15)];
            [imgs setImage:[UIImage imageNamed:imgs1[i]]];
            [self addSubview:imgs];
            
        }
        
        
        NSArray *label1 = @[@"距离考试",@"连续学习",@"累计学习"];
        for (int i = 0;i < label1.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((img.left + 42)+(kScreenWidth/3-10)*i, img.bottom - ((kScreenHeight-64-48)/3)/3, 100, 10)];
            NSString *name = [label1 objectAtIndex:i];
            [label setText:name];
            //         label.adjustsFontSizeToFitWidth = YES;
            
            label.font = [UIFont fontWithName:nil size:12];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            
        }
        
        
        NSArray *dayImgs = @[@"天",@"天",@"天"];
        for (int i = 0; i < dayImgs.count; i++) {
            
            UILabel *dayimgs = [[UILabel alloc] initWithFrame:CGRectMake((img.left + 70)+(kScreenWidth/3-10)*i, img.bottom - ((kScreenHeight-64-48)/3)/6,10,10)];
            NSString *name = [dayImgs objectAtIndex:i];
            [dayimgs setText:name];
            dayimgs.textColor = [UIColor whiteColor];
            dayimgs.font = [UIFont fontWithName:nil size:10];
            
            
            //        [dayimgs setText:[UILabel :dayImgs[i]]];
            [img addSubview:dayimgs];
            
        }
        
        
        
        
        //请求数据的三个label布局
        
        _examDays = [[UILabel alloc]initWithFrame:CGRectMake(img.left +25, img.bottom - ((kScreenHeight-64-48)/3)/6-15+5,40,30)];
        
        _examDays.backgroundColor = [UIColor clearColor];
        _examDays.textColor = [UIColor whiteColor];
        _examDays.textAlignment = 2;
        
        
        [self addSubview:_examDays];
        
        
        _continuousLearning = [[UILabel alloc]initWithFrame:CGRectMake((img.left + 25)+(kScreenWidth/3-10), 5+img.bottom - ((kScreenHeight-64-48)/3)/6-15,40,30)];
        _continuousLearning.backgroundColor = [UIColor clearColor];
        _continuousLearning.textColor = [UIColor whiteColor];
        _continuousLearning.textAlignment = 2;
        
        [self addSubview:_continuousLearning];
        
        _totalLearning = [[UILabel alloc]initWithFrame:CGRectMake((img.left + 25)+(kScreenWidth/3-10)*2, 5+img.bottom - ((kScreenHeight-64-48)/3)/6-15,40,30)];
        _totalLearning.backgroundColor = [UIColor clearColor];
        _totalLearning.textColor = [UIColor whiteColor];
        _totalLearning.textAlignment = 2;
        
        [img addSubview:_totalLearning];
        
        
        
        
        
        
        
        //---------------第二部分两个百分比圆------------------------//
        
        
        //红色
        if(imgView1 == nil)
        {
            imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/8, h+h/5, 0, 0)];
            imgView1.backgroundColor = [UIColor redColor];
            
            
            firstGoalBar = [[KDGoalBar alloc]initWithFrame:CGRectMake((375-177)/2., 200, 177, 177)];
            //    [firstGoalBar setPercent:classRate animated:YES];
            [self addSubview:imgView1];
            [imgView1 addSubview:firstGoalBar];
            [firstGoalBar.percentLabel setTextColor:[UIColor colorWithRed:208/255.0 green:62/255.0 blue:34/255.0 alpha:1.0]];
            
            
            UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 60, 20)];
            redLabel.backgroundColor = [UIColor clearColor];
            redLabel.text = @"听课完成率";
            redLabel.font = [UIFont fontWithName:nil size:12];
            redLabel.textColor = [UIColor colorWithRed:208/255.0 green:62/255.0 blue:34/255.0 alpha:1.0];
            
            [imgView1 addSubview:redLabel];
            
            
        }
        
        
        
        
        
        //142, 193, 51绿色
        if (imgView2 == nil) {
            imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imgView1.right +kScreenWidth/8*3.5, h+h/5, 0, 0)];
            
            
            secondGoalBar = [[PLGoalBar alloc]initWithFrame:CGRectMake((375-177)/2., 200, 177, 177)];
            //    [secondGoalBar setPercent:practiceRate animated:YES];
            [self addSubview:imgView2];
            [imgView2 addSubview:secondGoalBar];
            [secondGoalBar.percentLabel setTextColor:[UIColor colorWithRed:142/255.0 green:193/255.0 blue:51/255.0 alpha:1.0]];
            
            
            UILabel *greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 60, 20)];
            greenLabel.backgroundColor = [UIColor clearColor];
            greenLabel.text = @"练习完成率";
            greenLabel.font = [UIFont fontWithName:nil size:12];
            greenLabel.textColor = [UIColor colorWithRed:142/255.0 green:193/255.0 blue:51/255.0 alpha:1.0];
            //        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0].CGColor);
            
            
            [imgView2 addSubview:greenLabel];
            
        }
        
        
        
        
        
        
        //分钟
        _courseComplete = [[UILabel alloc]initWithFrame:CGRectMake(_courseTotal.left -30,h+h/5+100, 30, 30)];
        
        _courseComplete.font = [UIFont fontWithName:nil size:12];
        _courseComplete.textColor = [UIColor colorWithRed:208/255.0 green:62/255.0 blue:34/255.0 alpha:1.0];
        _courseComplete.backgroundColor = [UIColor clearColor];
        _courseComplete.textAlignment = 2;
        [self addSubview:_courseComplete];
        
        _courseTotal = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/6+20,h+h/5+100, 80, 30)];
        //    _courseTotal.text = @"/3000分钟";
        _courseTotal.font = [UIFont fontWithName:nil size:12];
        _courseTotal.textColor = [UIColor blackColor];
        _courseTotal.backgroundColor = [UIColor clearColor];
        [self addSubview:_courseTotal];
        
        //道
        _examComplete = [[UILabel alloc]initWithFrame:CGRectMake(_examTotal.left-30, h+h/5+100, 30, 30)];
        _examComplete.textAlignment = 2;
        _examComplete.font = [UIFont fontWithName:nil size:12];
        _examComplete.textColor = [UIColor colorWithRed:142/255.0 green:193/255.0 blue:51/255.0 alpha:1.0];
        _examComplete.backgroundColor = [UIColor clearColor];
        [self addSubview:_examComplete];
        
        
        _examTotal = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/6*4+10, h+h/5+100, 80, 30)];
        //    _examTotal.text = @"/3499道";
        _examTotal.font = [UIFont fontWithName:nil size:12];
        _examTotal.textColor = [UIColor blackColor];
        _examTotal.backgroundColor = [UIColor clearColor];
        [self addSubview:_examTotal];
        
        
        
        
        
        //分隔线horizontal_gray_line
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,h+h*2/5*3, kScreenWidth, 1)];
        lineImg.image = [UIImage imageNamed:@"horizontal_gray_line"];
        lineImg.backgroundColor = [UIColor greenColor];
        [self addSubview:lineImg];
        
        
        //-----------------------第三部分-----------------------//
        //01
        
        
        
        //    UIImageView *img04 = [[UIImageView alloc] initWithFrame:CGRectMake(40,lineImg.bottom + kScreenHeight/6*2/10, 35, 35)];
        UIImageView *img04 = [[UIImageView alloc] initWithFrame:CGRectMake(40,h+h*2/5*3+h*2/5*2/5, 35, 35)];
        img04.image = [UIImage imageNamed:@"today_task"];
        [self addSubview:img04];
        
        UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(25, img04.bottom +5, 70, 30)];
        label4.text = @"今日任务";
        label4.font = [UIFont fontWithName:nil size:16];
        label4.textColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
        label4.backgroundColor = [UIColor whiteColor];
        [self addSubview:label4];
        
        
        //02

        UIImageView *img05 = [[UIImageView alloc] initWithFrame:CGRectMake(30 +(kScreenWidth - 30)/3,h+h*2/5*3+h*2/5*2/7,20, 20)];
        img05.image = [UIImage imageNamed:@"headset"];
        [self addSubview:img05];
    
        UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(img05.right+2, h+h*2/5*3+h*2/5*2/7, 30, 25)];
       label5.text = @"听课";
       label5.font = [UIFont fontWithName:nil size:14];
       label5.textColor = [UIColor blackColor];
       label5.backgroundColor = [UIColor clearColor];
       [self addSubview:label5];

    
    //分钟
    
//请求数据----------------------------------------
    _todayCourseComplete = [[UILabel alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 60)/3-30, img05.bottom, 30, 30)];
    
    _todayCourseComplete.font = [UIFont fontWithName:nil size:17];
    _todayCourseComplete.textColor = [UIColor blackColor];
    _todayCourseComplete.textAlignment = 2;
    
    _todayCourseComplete.backgroundColor = [UIColor clearColor];
    _todayCourseComplete.textColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
    [self addSubview:_todayCourseComplete];



    
    
    
    _todayCourseTotal = [[UILabel alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 60)/3, img05.bottom, 35, 30)];
    
    _todayCourseTotal.font = [UIFont fontWithName:nil size:17];
    _todayCourseTotal.textColor = [UIColor blackColor];
    _todayCourseTotal.backgroundColor = [UIColor clearColor];
    [self addSubview:_todayCourseTotal];
        
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(_todayCourseTotal.right, _todayCourseTotal.top+10, 25, 15)];
    lab.text = @"分钟";
    lab.font = [UIFont fontWithName:nil size:10];
    lab.textColor = [UIColor blackColor];
    lab.backgroundColor = [UIColor clearColor];
    [self addSubview:lab];
   
        
    
    
    
    
//03
    UIImageView *img06 = [[UIImageView alloc] initWithFrame:CGRectMake(40 +(kScreenWidth - 40)/3*2,h+h*2/5*3+h*2/5*2/7, 20, 20)];
    img06.image = [UIImage imageNamed:@"from_test@2x.png"];
    [self addSubview:img06];
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(img06.right +2,h+h*2/5*3+h*2/5*2/7, 30, 25)];
    label6.text = @"练习";
    label6.font = [UIFont fontWithName:nil size:14];
    label6.textColor = [UIColor blackColor];
    label6.backgroundColor = [UIColor clearColor];
    [self addSubview:label6];
    
//道----------------------------------------------------
    _todayExamComplete= [[UILabel alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 60)/3*2+20-30, img06.bottom, 30, 30)];
    //    _todayExamComplete.text = @"/10道";
    _todayExamComplete.font = [UIFont fontWithName:nil size:17];
    _todayExamComplete.textColor = [UIColor blackColor];
    _todayExamComplete.backgroundColor = [UIColor clearColor];
    _todayExamComplete.textAlignment = 2;
    _todayExamComplete.textColor = [UIColor colorWithRed:46/255.0 green:173/255.0 blue:254/255.0 alpha:1.0];
    [self addSubview:_todayExamComplete];


    
    _todayExamTotal = [[UILabel alloc]initWithFrame:CGRectMake(40 +(kScreenWidth - 60)/3*2+20, img06.bottom, 35, 30)];
    
    _todayExamTotal.font = [UIFont fontWithName:nil size:17];
    _todayExamTotal.textColor = [UIColor blackColor];
    _todayExamTotal.backgroundColor = [UIColor clearColor];
    [self addSubview:_todayExamTotal];
        
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(_todayExamTotal.right, _todayExamTotal.top+10, 25, 15)];
        lab2.text = @"道";
        lab2.font = [UIFont fontWithName:nil size:10];
        lab2.textColor = [UIColor blackColor];
        lab2.backgroundColor = [UIColor clearColor];
        [self addSubview:lab2];

   
    
    
// 分隔线 竖线 vertical_gray_line  (label5.right)+(img06.left-label5.right)/2
    UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake((30 +(kScreenWidth - 30)/3-10+70)+((40 +(kScreenWidth - 40)/3*2-10)-(30 +(kScreenWidth - 30)/3-10+70))/2, h+h*2/3*2+h*2/3/7, 0.5, 60)];
    verticalLine.image = [UIImage imageNamed:@"vertical_gray_line@2x.png"];
    [self addSubview:verticalLine];

   }

    
}

@end
