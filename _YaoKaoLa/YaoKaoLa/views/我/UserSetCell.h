//
//  UserSetCell.h
//  yaokaola
//
//  Created by pro on 14/12/8.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSetModel.h"
@interface UserSetCell : UITableViewCell
- (void)updateData:(UserSetModel *)data;
- (void)setTestDate:(NSString *)date; // 设置考试日期
- (void)setTestDirect:(NSString *)direct1; // 设置报考方向
- (void)setSeperateLine;    //设置分割线
@end
