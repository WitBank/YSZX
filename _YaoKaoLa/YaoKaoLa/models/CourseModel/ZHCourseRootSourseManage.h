//
//  ZHCourseRootSourseManage.h
//  YaoKaoLa
//
//  Created by HuXin on 14/12/29.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseManagedObject.h"
#import "ZHCourseRootSourseModel.h"

@interface ZHCourseRootSourseManage : ZHBaseManagedObject

@property (nonatomic, copy) NSString *courseId;         //课程id
@property (nonatomic, copy) NSString *courseName;       //课程名称
@property (nonatomic, copy) NSString *courseImg;        //图片路径地址
@property (nonatomic, copy) NSString *courseContent;    //课程描述
@property (nonatomic, copy) NSString *teacher;          //讲师
@property (nonatomic, copy) NSString *endTime;          //结束时间
@property (nonatomic, copy) NSString *videoCount;       //课时
@property (nonatomic, copy) NSString *acntNumber;       //账号

@end
