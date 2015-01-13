//
//  HomeModel.h
//  Product-Medicine
//
//  Created by Mac on 14/12/1.
//  Copyright (c) 2014年 PengLi. All rights reserved.
//

/*
 <NewDataSet><HomePage><Ranking>49</Ranking><ExamDays>320</ExamDays><ContinuousLearning>1</ContinuousLearning><TotalLearning>26</TotalLearning><Course><Complete>0</Complete><Total>3000</Total></Course><Exam><Complete>610</Complete><Total>3499</Total></Exam><TodayTaskCourse><Complete>0</Complete><Total>60</Total></TodayTaskCourse><TodayTaskExam><Complete>10</Complete><Total>9</Total></TodayTaskExam></HomePage></NewDataSet>

 */
#import <Foundation/Foundation.h>

@interface HomeModel : NSObject<NSCoding>

@property (nonatomic,copy)NSString *examDays;//距离考试
@property (nonatomic,copy)NSString *continuousLearning;//连续学习
@property (nonatomic,copy)NSString *totalLearning;//累计学习

@property (nonatomic,copy)NSString *courseComplete;// 总听课完成分钟
@property (nonatomic,copy)NSString *courseTotal;// 总听课分钟

@property (nonatomic,copy)NSString *examComplete;// 总练习完成道
@property (nonatomic,copy)NSString *examTotal;// 总练习道

@property (nonatomic,copy)NSString *todayCourseComplete;// 今日听课完成分钟
@property (nonatomic,copy)NSString *todayCourseTotal;// 今日听课总分钟

@property (nonatomic,copy)NSString *todayExamComplete;// 今日听课完成分钟
@property (nonatomic,copy)NSString *todayExamTotal;// 今日听课总分钟

@property (nonatomic,copy)NSString *correct;//正确率

//- (void)setNullValue;

@end
