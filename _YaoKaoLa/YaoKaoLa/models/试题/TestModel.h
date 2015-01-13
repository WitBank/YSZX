//
//  TestModel.h
//  yaokaola
//
//  Created by pro on 14/11/30.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject<NSCoding>
@property (nonatomic,copy)NSString *complete;//正确数
@property (nonatomic,copy)NSString *total;//总答题数
@property (nonatomic,copy)NSString *totalQuestions;// 总题数
@property (nonatomic,copy)NSString *practiceDays;// 练习天数
@property (nonatomic,copy)NSString *ranking;//全站排名
@property (nonatomic,copy)NSString *correct;//正确率
- (void)setNullValue;

@end
