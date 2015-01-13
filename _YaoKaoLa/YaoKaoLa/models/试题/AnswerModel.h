//
//  AnswerModel.h
//  yaokaola
//
//  Created by pro on 14/12/2.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject
@property (nonatomic,copy)NSString *selectKey;
@property (nonatomic,copy)NSString *selectValue;
@property (nonatomic,assign)BOOL isSigle;//单选多选
@property (nonatomic,assign)BOOL isSelected;//是否选中
@end
