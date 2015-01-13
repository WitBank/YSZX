//
//  RandomViewController.h
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "BaseViewController.h"
@class RandomTopView;
@interface RandomViewController : BaseViewController
{
        NSMutableArray *_dataArray;
        UIScrollView *_scollView;
        RandomTopView *_topView;
}
- (NSArray *)dataArray;
- (void)loadScollViewData;
- (void)masklayer;
- (void)makeView;
@property (nonatomic,copy)NSString *examId; //试卷id
- (void)setDataArray:(NSMutableArray *)array;
@property (nonatomic,copy)NSString *questionstype;//章节0，练一练1，2模拟考试
@property (nonatomic,assign)BOOL isResolve; // 是答题no还是解析yes

@property (nonatomic,assign) int qType;
@property (nonatomic,copy) NSString * qSortId;
@end
