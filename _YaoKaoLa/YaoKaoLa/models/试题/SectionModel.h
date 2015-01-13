//
//  SectionModel.h
//  yaokaola
//
//  Created by pro on 14/12/9.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject
@property (nonatomic,assign) BOOL isOn;

//章节
@property(nonatomic,copy)NSString *questionsName; //章节名称
@property(nonatomic,copy)NSString *questionsSortId; //章节ID
@property(nonatomic,copy)NSString *questionNum;//已经回答
@property(nonatomic,copy)NSString *totalNum;//总题个数
@property(nonatomic,copy)NSString *CorrectNum; //正确个数
@property (nonatomic,copy) NSString *depth;
@property(nonatomic,copy)NSString *avgnum;     //正确率
@property (nonatomic,strong) NSMutableArray *modelArray; // 二级内容

@end
