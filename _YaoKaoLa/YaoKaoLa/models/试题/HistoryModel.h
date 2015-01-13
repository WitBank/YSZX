//
//  HistoryModel.h
//  YaoKaoLa
//
//  Created by Mac on 14/12/26.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject

//历史
@property(nonatomic,copy)NSString *questionsName; // 练习效果标题
@property(nonatomic,copy)NSString *peoplenum; // 参加人数
@property(nonatomic,copy)NSString *avgnum; //平均正确
@property(nonatomic,copy)NSString *chapterdetailedId; //
@property(nonatomic,copy)NSString *questionsSortId; //ID
@property(nonatomic,copy)NSString *questionNum;//已经回答
@property(nonatomic,copy)NSString *peopleCount;//总题个数
@property(nonatomic,copy)NSString *correctNum; //正确个数
@property(nonatomic,copy)NSString *RowNum;
@property(nonatomic,strong)NSMutableArray *modelArray; //

@end
