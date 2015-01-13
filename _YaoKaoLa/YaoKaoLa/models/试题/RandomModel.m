//
//  RandomModel.m
//  yaokaola
//
//  Created by pro on 14/12/1.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "RandomModel.h"
#import "AnswerModel.h"
@implementation RandomModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([value isEqualToString:@"."]||[value isEqualToString:@""]||value==nil) {
        return;
    }else if([key hasPrefix:@"selectKey"]){
        if (self.answers == nil) {
            self.answers = [[NSMutableArray alloc] init];
        }
        AnswerModel *model = [[AnswerModel alloc] init];
        model.selectKey = key;
        model.selectValue = value;
        if ([self.questionsSortType isEqualToString:@"单选题"]) {
            model.isSigle = YES;
        }
        [self.answers addObject:model];
    }
}
@end
