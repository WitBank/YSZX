//
//  RandomModel.h
//  ;
//
//  Created by pro on 14/12/1.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomModel : NSObject
@property (nonatomic,copy)NSString *Orderss;            //题号
@property (nonatomic,copy)NSString *questionsId;
@property (nonatomic,copy)NSString *questionsSortType;  //单选题,多选题
@property (nonatomic,copy)NSString *baseType;           //单选类,多选类
@property (nonatomic,copy)NSString *episteme;           //题目描述
@property (nonatomic,copy)NSString *difficulty;
@property (nonatomic,copy)NSString *point;
@property (nonatomic,copy)NSString *questionsContent;
@property (nonatomic,copy)NSString *contentFile;
@property (nonatomic,copy)NSString *parentType;         //情景类
@property (nonatomic,copy)NSString *parentContent;

@property (nonatomic,strong)NSMutableArray *answers;
@property (nonatomic,copy)NSString *correctKey;         //正确答案
@property (nonatomic,strong)NSMutableArray *selectArray;//多选选中答案
@property (nonatomic,copy)NSString *analyes;            //分析
@end
