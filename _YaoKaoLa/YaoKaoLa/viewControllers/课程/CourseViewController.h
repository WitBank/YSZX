//
//  CourseViewController.h
//  yaokaola
//
//  Created by pro on 15/6/11.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import "BaseViewController.h"
#import "ZHPickTitleView.h"
#import "ZHCourseRootView.h"

@interface CourseViewController : BaseViewController<ZHPickTitleViewDelegate,ZHCourseRootViewDelegate>
{
    ZHCourseRootView *_courseRootView;
}

@end
