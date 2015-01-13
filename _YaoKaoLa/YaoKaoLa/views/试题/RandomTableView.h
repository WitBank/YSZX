//
//  RandomTableView.h
//  yaokaola
//
//  Created by pro on 14/11/30.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomModel.h"
@protocol RandomTableViewDelegate<NSObject>
- (void)gotoNextQuestion;
@end
@interface RandomTableView : UITableView
- (void)setDataWithData:(RandomModel *)data;
//设置底部视图
- (void)setFootView;
@property (nonatomic,assign)id<RandomTableViewDelegate>randomDelegate;
@end
