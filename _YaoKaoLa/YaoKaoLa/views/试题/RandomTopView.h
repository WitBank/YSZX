//
//  RandomTopView.h
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandomTopView : UIView
//开始计时
- (void)startTime;
//停止计时
- (void)stopTime;
//设置当前是第几题
- (void)setCurrenPage:(int)page;
//总题数
- (void)setAllPage:(int)page;
//获取答题时间
- (int)getTime;
//设置标题
- (void)setTitleLbWith:(NSString *)st;

@end
