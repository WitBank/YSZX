//
//  CourseChapterViewController.h
//  yaokaola
//
//  Created by HuXin on 14/12/24.
//  Copyright (c) 2014年 pro. All rights reserved.
//
//课程章节页面

#import "BaseViewController.h"
#import "ZHCourseRootSourseModel.h"
#import "ZHCourseDetailTabbarView.h"
#import "HJAlertView.h"

@interface CourseChapterViewController : BaseViewController<ZHCourseDetailTabbarViewDelegate,HJAlertViewDelegate>
{
    ZHCourseRootSourseModel *_courseModel;
}

@property (nonatomic, strong) NSMutableArray *chapterArray;
@property (nonatomic, strong) NSMutableArray *downLoadArray;
@property (nonatomic, strong) NSMutableArray *downLoadOperation;
@property (nonatomic, strong) NSMutableArray *partialDataArray;

- (instancetype)initWithCourseModel:(ZHCourseRootSourseModel *)courseModel andChapterArray:(NSArray *)array andDLArray:(NSArray *)dlArray;

@end
