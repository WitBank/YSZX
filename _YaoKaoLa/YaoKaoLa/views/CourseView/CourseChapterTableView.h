//
//  CourseChapterTableView.h
//  yaokaola
//
//  Created by HuXin on 14/12/24.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHCourseDetailTabbarView.h"
#import "UIScrollView+PullLoad.h"

@interface CourseChapterTableView : UIView<UITableViewDelegate,UITableViewDataSource,ZHCourseDetailTabbarViewDelegate,PullDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray *courseChapterArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) void (^refreshData)(void);
@property (nonatomic, strong) void (^playVideo)(int);
@property (nonatomic, strong) void (^downloadVideo)(int);

- (void)PullDownLoadEnd;

@end
