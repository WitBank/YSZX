//
//  HomeModel.m
//  Product-Medicine
//
//  Created by Mac on 14/12/1.
//  Copyright (c) 2014年 PengLi. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.examDays forKey:@"examDays"];
    [aCoder encodeObject:self.continuousLearning forKey:@"continuousLearning"];
    [aCoder encodeObject:self.totalLearning forKey:@"totalLearning"];
    
    [aCoder encodeObject:self.courseComplete forKey:@"courseComplete"];
    [aCoder encodeObject:self.courseTotal forKey:@"courseTotal"];
    [aCoder encodeObject:self.correct forKey:@"correct"];
    
    
    [aCoder encodeObject:self.examComplete forKey:@"examComplete"];
    [aCoder encodeObject:self.examTotal forKey:@"examTotal"];
    
    [aCoder encodeObject:self.todayExamComplete forKey:@"todayExamComplete"];
    [aCoder encodeObject:self.todayExamTotal forKey:@"todayExamTotal"];
    
    [aCoder encodeObject:self.todayCourseComplete forKey:@"todayCourseComplete"];
    [aCoder encodeObject:self.todayCourseTotal forKey:@"todayCourseTotal"];

}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.examDays= [aDecoder decodeObjectForKey:@"examDays"];
        self.continuousLearning= [aDecoder decodeObjectForKey:@"continuousLearning"];
        self.totalLearning= [aDecoder decodeObjectForKey:@"totalLearning"];
        
        self.courseComplete= [aDecoder decodeObjectForKey:@"courseComplete"];
        self.courseTotal= [aDecoder decodeObjectForKey:@"courseTotal"];
        self.correct= [aDecoder decodeObjectForKey:@"correct"];
        
        self.examComplete= [aDecoder decodeObjectForKey:@"examComplete"];
        self.examTotal= [aDecoder decodeObjectForKey:@"examTotal"];
        
        self.todayExamComplete= [aDecoder decodeObjectForKey:@"todayExamComplete"];
        self.todayExamTotal= [aDecoder decodeObjectForKey:@"todayExamTotal"];
        
        self.todayCourseComplete= [aDecoder decodeObjectForKey:@"todayCourseComplete"];
        self.todayCourseTotal= [aDecoder decodeObjectForKey:@"todayCourseTotal"];
    }
    return self;
}

@end
