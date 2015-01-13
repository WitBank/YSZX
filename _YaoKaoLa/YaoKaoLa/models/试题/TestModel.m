//
//  TestModel.m
//  yaokaola
//
//  Created by pro on 14/11/30.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@", _complete,_total,_totalQuestions,_practiceDays,_ranking];
}
- (void)setNullValue{
    if (!self.complete) {
        self.complete = @"";
    }
    if (!self.total) {
        self.total = @"";
    }
    if (!self.totalQuestions) {
        self.totalQuestions = @"";
    }
    if (!self.practiceDays) {
        self.practiceDays = @"";
    }
    if (!self.ranking) {
        self.ranking = @"";
    }
    if (!self.correct) {
        self.correct = @"";
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.complete forKey:@"complete"];
    [aCoder encodeObject:self.total forKey:@"total"];
    [aCoder encodeObject:self.totalQuestions forKey:@"totalQuestions"];
    [aCoder encodeObject:self.practiceDays forKey:@"practiceDays"];
    [aCoder encodeObject:self.ranking forKey:@"ranking"];
    [aCoder encodeObject:self.correct forKey:@"correct"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.complete= [aDecoder decodeObjectForKey:@"complete"];
        self.total= [aDecoder decodeObjectForKey:@"total"];
        self.totalQuestions= [aDecoder decodeObjectForKey:@"totalQuestions"];
        self.practiceDays= [aDecoder decodeObjectForKey:@"practiceDays"];
        self.ranking= [aDecoder decodeObjectForKey:@"ranking"];
        self.correct= [aDecoder decodeObjectForKey:@"correct"];
    }
    return self;
}
@end
