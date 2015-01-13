//
//  AnswerCell.h
//  yaokaola
//
//  Created by pro on 14/11/30.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModel.h"
@interface AnswerCell : UITableViewCell
- (void)updateData:(AnswerModel *)model;
- (void)setAnswerSelected:(BOOL)animated;
@end
