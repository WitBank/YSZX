//
//  HomeView.h
//  Product-Medicine
//
//  Created by Mac on 14/11/30.
//  Copyright (c) 2014年 PengLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeView : UIView{
    UILabel *_examDays;
    UILabel *_continuousLearning;
    UILabel *_totalLearning;

    UILabel *_courseComplete;// 总听课完成分钟
    UILabel *_courseTotal;// 总听课分钟
    
    UILabel *_examComplete;// 总练习完成道
    UILabel *_examTotal;// 总练习道
    
    UILabel *_todayCourseComplete;// 今日听课完成分钟
    UILabel *_todayCourseTotal;// 今日听课总分钟
    
    UILabel *_todayExamComplete;// 今日听课完成分钟
    UILabel *_todayExamTotal;// 今日听总道
    float classRate;
    float practiceRate;
}
@property(nonatomic,retain)HomeModel *homeModel;
- (void)faildUpdata;




//- (void)update:(HomeModel *)model;
@end
