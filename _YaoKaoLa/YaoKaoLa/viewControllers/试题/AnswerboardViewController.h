//
//  AnswerboardViewController.h
//  yaokaola
//
//  Created by pro on 14/12/2.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "BaseViewController.h"
@protocol AnswerbordViewDelegate<NSObject>
- (void)setScollTopage:(int)page;//滚动
- (int)getSeconds;//获取答题时间
@end
@interface AnswerboardViewController : BaseViewController
@property (nonatomic,assign)NSMutableArray *dataArray;
@property (nonatomic,copy)NSString *examid; //试卷id
@property (nonatomic,copy)NSString *questionstype;//章节0，练一练1
@property (nonatomic,copy) NSString *questionbankId;
@property (nonatomic,assign)id<AnswerbordViewDelegate>delegate;
@end
